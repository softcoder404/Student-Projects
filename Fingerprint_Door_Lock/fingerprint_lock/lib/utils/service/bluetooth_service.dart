import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothHandlers {
  //Initializing the bluetooth connection state to be unknow
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  // Track the bluetooth connection with the remote device
  BluetoothConnection connection;
  // To track weather the device is staill connected to bluetooth.
  bool get isConnected => connection != null && connection.isConnected;
  // we first have to get the current bluetooth state. if the state indicate that bluetooth is not turned on, request that the user give bluetooth permission
  int deviceState; // the bluetooth device connection state
  // create an instance of bluetooth device
  BluetoothDevice device;
  bool isDisconnecting = false;
  bool connected = false;
  bool isButtonUnavailable = false;
  bool isLoading = false;
  List<BluetoothDevice> devicesList = [];

  //get all bonded devices
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    } on PlatformException {
      print('errror');
    }
    // It is an error to call [setState] unless [mounted] is true.
    //if (!mounted) return;
    devicesList = devices;
  }

  Future<void> enableBluetooth() async {
    //Retriving the current state of the bluetooth
    bluetoothState = await FlutterBluetoothSerial.instance.state;
    //if the bluetooth is off, then turn it on first and then retrieve the devices that are paired.
    if (bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> connect() async {
    if (device == null)
      print('No device selected');
    else {
      if (!isConnected) {
        isLoading = true;
        //try to connect to the device using its address
        await BluetoothConnection.toAddress(device.address).then((_connect) {
          connection = _connect;
          connected = true;
          isLoading = false;
          connection.input.listen(null).onDone(() {
            if (isDisconnecting)
              print('Disconnecting locally!');
            else
              print('Disconnected remotely!');
          });
        }).catchError((err) => print('cannot connect'));
      }
    }
  }

  //Listen to further changes
  Future<void> disconnect() async {
    //colsing the bluetooth connection
    await connection.close();
    print('Device disconnected');
    if (!connection.isConnected) connected = false;
  }

  // for turning the Bluetooth device on
  Future<void> sendMessageToBluetooth(String msg) async {
    connection.output.add(utf8.encode(msg + "\r\n"));
    await connection.output.allSent;
    deviceState = 1; // device on
  }
  //Listen
}
