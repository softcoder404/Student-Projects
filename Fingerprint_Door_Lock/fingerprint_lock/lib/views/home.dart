import 'dart:convert';

import 'package:fingerprint_lock/utils/service/fingerprint_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final name;

  HomeScreen({@required this.name});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> saveData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('validate', true);
  }

  FingerprintHandler fingerprintHandler = FingerprintHandler();
  bool _connected = false;
  bool showBottomSheet = false;
  bool _isButtonUnavailable = false;
  //start
  //Initializing the bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Get the instance of the bluetooth
  FlutterBluetoothSerial _bluetoothSerial = FlutterBluetoothSerial.instance;
  //Track the bluetooth connection with the remote device
  BluetoothConnection connection;
  //To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection.isConnected;
  //we first have to get the current bluetooth state. if the state indicate that bluetooth isn ot turned on, request that the user give bluetooth permission for enabling bluetooth on their device.

  int deviceState; //the bluetooth device connection state

  List<BluetoothDevice> _devicesList = [];

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await _bluetoothSerial.getBondedDevices();
    } on PlatformException {
      print("error");
    }
    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  Future<void> enableBluetooth() async {
    //Retrieving the current bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    //if the bluetooth is off, then turn it on first and then retrieve the devices that are paired.

    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> _connect() async {
    if (_device == null) {
      print('No device selected');
    } else {
      //if a device is selected from the dropdown, the use it here
      if (!isConnected) {
        print('device address $_device.address');
        //try to connect to the device using its address
       await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          //updating the device connectivity status to true
          setState(() {
            _connected = true;
          });
          connection.input.listen(null).onDone(() {
            if (isDisconnecting)
              print('Disconnecting locally!');
            else
              print('Disconnected remotely!');

            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((err) {
          print('Cannot connect, exception occurred');
          print(err);
        });
        print('Device connected');
      }
    }
  }

  Future<void> _disconnect() async {
    //colsing the bluetooth connection
    await connection.close();
    print('Device disconnected');

    if (!connection.isConnected) {
      setState(() {
        _connected = false;
      });
    }
  }

// Method to send message
// for turning the Bluetooth device on
void _sendOnMessageToBluetooth() async {
  connection.output.add(utf8.encode("1" + "\r\n"));
  await connection.output.allSent;
  print('Device Turned On');
  setState(() {
    deviceState = 1; // device on
  });
}

// Method to send message
// for turning the Bluetooth device off
Future<void> _sendOffMessageToBluetooth() async {
  connection.output.add(utf8.encode("0" + "\r\n"));
  await connection.output.allSent;
  print('Device Turned Off');
  setState(() {
    deviceState = -1; // device off
  });
}

  @override
  void initState() {
    fingerprintHandler.getBiometricsSupport().then((_) => setState(() {}));

    super.initState();
    //Get current state
    FlutterBluetoothSerial.instance.state
        .then((state) => setState(() => _bluetoothState = state));
    deviceState = 0; // neutral
    // If the Bluetooth of the device is not enabled,
    // then request permission to turn on Bluetooth
    // as the app starts up
    enableBluetooth();
    // Listen for further state changes
    FlutterBluetoothSerial.instance.onStateChanged().listen((event) {
      setState(() {
        _bluetoothState = event;
        //For retrieving the paired devices list
        getPairedDevices();
      });
    });
  }

  // Define a member variable to track
// when the disconnection is in progress
  bool isDisconnecting = false;
  BluetoothDevice _device;
  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    saveData();
    return Scaffold(
      appBar: AppBar(
        title: Text("Hey ${widget.name} !"),
        actions: [
          Row(
            children: [
              Icon(Icons.bluetooth),
              Switch(
                  value: _bluetoothState.isEnabled,
                  onChanged: (bool val) {
                    future() async {
                      if (val) {
                        //Turn on bluetooth
                        await FlutterBluetoothSerial.instance.requestEnable();
                      } else {
                        //Turn off bluetooth
                        await FlutterBluetoothSerial.instance.requestDisable();
                      }
                      // update the devices list
                      await getPairedDevices();
                      _isButtonUnavailable = false;

                      //disconnect from any connected device

                      if (_connected) _disconnect();
                    }

                    future().then((_) => setState(() {}));
                  }),
            ],
          )
        ],
      ),
      body: Container(
        color: Theme.of(context).primaryColorDark,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Device : ',
                          style: Theme.of(context).primaryTextTheme.subtitle1),
                    ),
                    Expanded(
                      child: DropdownButton(
                        isExpanded: true,
                        items: _getDeviceItems(),
                        onChanged: (value) => setState(() => _device = value),
                        value: _devicesList.isNotEmpty ? _device : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 12),
                      child: RaisedButton(
                        child: Text(_connected ? 'Disconnect' : 'Connect'),
                        color: Colors.green,
                        onPressed: _isButtonUnavailable
                            ? null
                            : _connected ? _disconnect : _connect,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'NOTE: if you cannot find the device in the list, please pair the device by going to the bluetooth settings',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).primaryTextTheme.subtitle2.apply(
                          color: Colors.white60,
                        ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => fingerprintHandler
                  .authenticateMe()
                  .then((val) => setState(() {
                        print("Finger found ? $val");
                      })),
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      fingerprintHandler.hasFingerprintSupport
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: fingerprintHandler.hasFingerprintSupport
                          ? Colors.amber
                          : Colors.red,
                    ),
                  ),
                  Text(
                    fingerprintHandler.hasFingerprintSupport
                        ? "Device support fingerprint biometric"
                        : "Device does not support fingerprint",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .subtitle1
                        .apply(color: Colors.white.withOpacity(.9)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }
}
