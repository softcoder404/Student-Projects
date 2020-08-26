import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
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

  List<BluetoothDevice> devicesList = [];

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
      devicesList = devices;
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

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:null ,
      ),
    );
  }

  // Define a member variable to track
// when the disconnection is in progress
  bool isDisconnecting = false;

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }
    super.dispose();
  }
}
