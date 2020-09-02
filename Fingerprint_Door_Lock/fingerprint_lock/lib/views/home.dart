import 'dart:async';
import 'package:fingerprint_lock/utils/custom_painter.dart';
import 'package:fingerprint_lock/utils/service/bluetooth_service.dart';
import 'package:fingerprint_lock/utils/service/fingerprint_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final name;

  HomeScreen({@required this.name});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  Future<void> saveData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('validate', true);
  }

  FingerprintHandler fingerprintHandler = FingerprintHandler();
  BluetoothHandlers bluetoothHandlers = BluetoothHandlers();
  Timer timer;
   double lockRect = 0.0;
  Animation<double> lockRectAnimation;
  AnimationController controller;
  bool isDoorLocked = false;
  @override
  void initState() {
    fingerprintHandler.getBiometricsSupport();
    //Get current state
    FlutterBluetoothSerial.instance.state.then(
         (state) => setState(() => bluetoothHandlers.bluetoothState = state));
    bluetoothHandlers.deviceState = 0; // neutral
    // If the Bluetooth of the device is not enabled,
    bluetoothHandlers.enableBluetooth().then((_)=> setState((){}));
    FlutterBluetoothSerial.instance.onStateChanged().listen((event) {
      bluetoothHandlers.bluetoothState = event;
      bluetoothHandlers.getPairedDevices().then((_) => setState(() {}));
    });
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
     if(!isDoorLocked) lockDoor();
     super.initState();
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
                  value: bluetoothHandlers.bluetoothState.isEnabled,
                  onChanged: (bool val) async {
                    if (val) {
                      //Turn on bluetooth
                      await FlutterBluetoothSerial.instance.requestEnable();
                    } else {
                      //Turn off bluetooth
                      await FlutterBluetoothSerial.instance.requestDisable();
                    }
                    // update the devices list
                    bluetoothHandlers
                        .getPairedDevices()
                        .then((_) => setState(() {}));
                    bluetoothHandlers.isButtonUnavailable = false;
                    //disconnect from any connected device
                    if (bluetoothHandlers.connected) bluetoothHandlers.disconnect();
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
                        onChanged: (value) =>
                            setState(() => bluetoothHandlers.device = value),
                        value: bluetoothHandlers.devicesList.isNotEmpty
                            ? bluetoothHandlers.device
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 12),
                      child: RaisedButton(
                        child: bluetoothHandlers.isLoading
                            ? Center(
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              )
                            : Text(bluetoothHandlers.connected
                                ? 'Disconnect'
                                : 'Connect'),
                        color: Colors.green,
                        onPressed: () async {
                          if (bluetoothHandlers.isButtonUnavailable) {
                            return null;
                          } else {
                            if (bluetoothHandlers.isConnected)
                              bluetoothHandlers
                                  .disconnect()
                                  .then((_) => setState(() {}));
                            else {
                              Timer.periodic(Duration(milliseconds: 8000),
                                  (timer) {
                                bluetoothHandlers.isLoading = false;
                                setState(() {});
                              });
                              bluetoothHandlers
                                  .connect()
                                  .then((_) => setState(() {}));
                            }
                          }
                        },
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
                  .then((fingerMatched){
                        if(fingerMatched){
                          if (controller.isCompleted) controller.reset();
                          isDoorLocked ? unlockDoor() : lockDoor();
                        }
                      }),
              child: Container(
                height: 300,
                width: 220,
                child: CustomPaint(painter: LockCustomPaint(lockRect)),
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
    if (bluetoothHandlers.devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      bluetoothHandlers.devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }
    void lockDoor() {
    lockRectAnimation = Tween(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {
          lockRect = lockRectAnimation.value;
        });
      });
     controller.forward();
     isDoorLocked = true;
  }

  void unlockDoor() {
    lockRectAnimation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          lockRect = lockRectAnimation.value;
          print(lockRect);
        });
      });
     controller.forward();
     isDoorLocked = false;
  }
  @override
  void dispose() {
    controller.dispose();
    if (bluetoothHandlers.isConnected) {
      bluetoothHandlers.isDisconnecting = true;
      bluetoothHandlers.connection.dispose();
      bluetoothHandlers.connection = null;
    }
    timer.cancel();
    super.dispose();
  }
}
