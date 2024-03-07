import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Twow GT SE Unofficial App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'E-Twow GT SE Unofficial App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _ble = FlutterReactiveBle();

  // final _serviceId = Uuid.parse("0000ff00-0000-1000-8000-00805f9b34fb");
  // final _serviceIdRead = Uuid.parse("0000ff01-0000-1000-8000-00805f9b34fb");
  // final _characteristicId = Uuid.parse("0000ff02-0000-1000-8000-00805f9b34fb");

  //Works
  //final _serviceId = Uuid.parse("0000ff00-0000-1000-8000-00805f9b34fb");
  final _serviceId = Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e");

  //works
  //final _serviceIdRead = Uuid.parse("0000ff01-0000-1000-8000-00805f9b34fb");

  //testinng
  final _serviceIdRead = Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e");

  //no errors
  //final _characteristicId = Uuid.parse("0000ff01-0000-1000-8000-00805f9b34fb");

  final _characteristicId = Uuid.parse("00001801-0000-1000-8000-00805f9b34fb");
  final _characteristicIdRead =
      Uuid.parse("0000fff1-0000-1000-8000-00805f9b34fb");

  //not found
  //final _characteristicId = Uuid.parse("0000ffe1-0000-1000-8000-00805f9b34fb");
  //final _characteristicId = Uuid.parse("0000ae02-0000-1000-8000-00805f9b34fb");
  //final _characteristicId = Uuid.parse("0000ae01-0000-1000-8000-00805f9b34fb");

  //testing
  List<Uuid> chars = [
    Uuid.parse('6E400002-B5A3-F393-E0A9-E50E24DCCA9E'),
    Uuid.parse('6E400001-B5A3-F393-E0A9-E50E24DCCA9E'),
    Uuid.parse('6E400003-B5A3-F393-E0A9-E50E24DCCA9E'),
    Uuid.parse('0000ae02-0000-1000-8000-00805f9b34fb'),
    Uuid.parse('0000ae00-0000-1000-8000-00805f9b34fb'),
    Uuid.parse('0000ae01-0000-1000-8000-00805f9b34fb'),
    Uuid.parse('0000fff2-0000-1000-8000-00805f9b34fb'),
    Uuid.parse('0000fff3-0000-1000-8000-00805f9b34fb'),
    Uuid.parse('0000fff4-0000-1000-8000-00805f9b34fb'),
    Uuid.parse('0000fff7-0000-1000-8000-00805f9b34fb'),
    Uuid.parse('0000fff1-0000-1000-8000-00805f9b34fb'),
    Uuid.parse('0000fff0-0000-1000-8000-00805f9b34fb'),
    Uuid.parse('0000ffe0-0000-1000-8000-00805f9b34fb'),
  ];

  late StreamSubscription<DiscoveredDevice> listener;
  bool? _locked;
  bool? _zeroStart;
  bool? _lights;
  int? _mode;
  int? _odo;
  int? _trip;
  int? _battery;
  int? _speed;
  String? _id;
  ConnectionStateUpdate? _connectionState;

  bool found = false;

  bool get _connected =>
      _connectionState?.connectionState == DeviceConnectionState.connected;

  bool get _disconnected =>
      _connectionState?.connectionState == DeviceConnectionState.disconnected;

  void _connect() async {
    final granted = await Permission.location.request().isGranted &&
        await Permission.bluetooth.request().isGranted;
    if (!granted) {
      return;
    }
    if (_id != null) {
      return listenToDevice(_id!);
    }

    listener = _ble.scanForDevices(withServices: []).listen((device) async {
      //if (device.name.contains("GTSport")) {
      if (device.name.contains("M0Robot272757")) {
        //print('----------------- Device' + device.toString());
        //final services = _ble.discoverServices(device.id);

        //print('------------------ Services' + services.toString());
        setState(() {
          _id = device.id;
        });
        await _ble.requestConnectionPriority(
            deviceId: device.id, priority: ConnectionPriority.highPerformance);
        listenToDevice(device.id);
        listener.cancel();
      }
    });
  }

  void initState() {
    super.initState();
    _connect();
  }

  void listenToDevice(String id) {
    _ble.connectToDevice(id: id).listen((connectionState) async {
      setState(() {
        _connectionState = connectionState;
      });
      if (_connected) {
        print('Vlads::Connected');

        final characteristic = QualifiedCharacteristic(
            serviceId: _serviceId,
            characteristicId: _serviceIdRead,
            deviceId: _id!);

        var resop = _ble.readCharacteristic(characteristic);

        print(resop);

        /*

        

        _ble.subscribeToCharacteristic(characteristic).listen((data) {
          print("Vlads::success" + data.toString());
        }, onError: (dynamic error) {
          print("Vlads::error" + error.toString());
        });

        _ble.readCharacteristic(characteristic);*/

        return;

        // print('loop');
        // chars.forEach((item) {
        //   if (found) {
        //     return;
        //   }

        //   print('Trying:' + item.toString());

        //   var char = QualifiedCharacteristic(
        //       serviceId: _serviceId, characteristicId: item, deviceId: _id!);

        //   trySub(char);
        //   _ble.readCharacteristic(char);
        // });

        // return;

        // print('Vlads::listen');

        // final characteristic = QualifiedCharacteristic(
        //     serviceId: _serviceId,
        //     // serviceId: _serviceId,
        //     // characteristicId: _characteristicId,
        //     // characteristicId: _serviceIdRead,
        //     characteristicId: _characteristicId,
        //     deviceId: _id!);

        // _ble.subscribeToCharacteristic(characteristic).listen((data) {
        //   print("Vlads::success" + data.toString());
        // }, onError: (dynamic error) {
        //   print("Vlads::error" + error.toString());
        // });

        // _ble.readCharacteristic(characteristic);

        // _ble
        //     .subscribeToCharacteristic(characteristic)
        //     .listen((values) => _ventiveProcess(values));

        //enable notify charactaristics
        //_ble.writeCharacteristicWithResponse(characteristic, value: [0x01,0x01,]);

      } else if (_disconnected) {
        setState(() {
          _locked = null;
          _lights = null;
          _mode = null;
          _odo = null;
          _battery = null;
          _speed = null;
          _trip = null;
          _zeroStart = null;
        });
      }
    });
  }

  void trySub(char) {
    _ble.subscribeToCharacteristic(char).listen((data) {
      print("Vlads::success" + data.toString());

      _ble.subscribeToCharacteristic(char).listen((data) {
        print("Vlads::success" + data.toString());
      }, onError: (dynamic error) {
        print("Vlads::error" + error.toString());
      });

      found = true;
    }, onError: (dynamic error) {
      print("Vlads::error" + error.toString());
      found = false;
    });
  }

  void _ventiveProcess(List<int> values) {
    print('Vlads::Current' + values.toString());

    //_updateReadCharacteristics(values);
    return;
  }

  void _updateReadCharacteristics(List<int> values) {
    final value = values[1];
    //print('------------------ VALUES' + value.toString());
    //print('---------- TEST ------------');

    switch (values[0]) {
      case 1:
        setState(() {
          _speed = value + (values[2] == 1 ? 0xff : 0);
        });
        break;
      case 2:
        setState(() {
          _battery = value;
        });
        break;
      case 3:
        final first = value ~/ 0x10;
        setState(() {
          _lights = [5, 7, 0xd, 0xf].contains(first);
          _locked = [6, 7, 0xe, 0xf].contains(first);
          _zeroStart = [0xc, 0xd, 0xe, 0xf].contains(first);
          _mode = value % 0x10;
        });
        break;
      case 4:
        setState(() {
          _trip = values[1] + values[2];
        });
        break;
      case 5:
        setState(() {
          _odo = values[3] + values[4] + values[5];
          // print(values[3].toString() +
          //     '     ' +
          //     values[4].toString() +
          //     '     ' +
          //     values[5].toString());
        });
        break;
      default:
        break;
    }
  }

  void _send(List<int> values) {
    if (_id != null && _connected) {
      final characteristic = QualifiedCharacteristic(
          serviceId: _serviceId,
          characteristicId: _characteristicId,
          deviceId: _id!);

      //final allValues = [0x55];
      //allValues.addAll(values);
      //allValues.add(allValues.reduce((p, c) => p + c));

      values.add(values.reduce((p, c) => p + c));

      print('Vlads::Updated' + values.toString());

      _ble.writeCharacteristicWithResponse(characteristic, value: values);
    }
  }

  void _lockOn() {
    _send([0x05, 0x05, 0x01]);
  }

  void _lockOff() {
    _send([0x05, 0x05, 0x00]);
  }

  void _lightOn() {
    _send([0x55, 0x06, 0x00, 0x01]);
    //sleep(Duration(seconds: 2));
    //_send([0x55, 0x06, 0x01, 0x01]);

    _lights = true;
  }

  void _lightOff() {
    _send([0x55, 0x06, 0x00, 0x00]);
    _lights = false;
  }

  void _setSpeed(int mode) {
    _send([0x02, 0x05, mode]);
  }

  void _zeroOn() {
    _send([0x55, 0x03, 0x00, 0x00]);
  }

  void _zeroOff() {
    _send([0x55, 0x03, 0x00, 0x01]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.lock_open),
                color: Colors.green,
                tooltip: 'Lock',
                onPressed: _locked ?? false ? _lockOff : null,
                iconSize: 120,
              ),
              IconButton(
                icon: const Icon(Icons.lock),
                color: Colors.red,
                tooltip: 'Lock',
                onPressed: _locked ?? true ? null : _lockOn,
                iconSize: 120,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.lightbulb),
                tooltip: 'Light',
                color: Colors.yellow,
                onPressed: _lightOn,
                iconSize: 80,
              ),
              IconButton(
                icon: const Icon(Icons.lightbulb),
                tooltip: 'Light',
                onPressed: _lightOff,
                iconSize: 80,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.double_arrow),
                tooltip: 'On',
                color: Colors.yellow,
                onPressed: _zeroOn,
                iconSize: 80,
              ),
              IconButton(
                icon: const Icon(Icons.double_arrow_outlined),
                tooltip: 'Off',
                onPressed: _zeroOff,
                iconSize: 80,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.speed),
                tooltip: '6km/h',
                color: Colors.green,
                onPressed:
                    _mode != null && _mode != 1 ? () => _setSpeed(1) : null,
                iconSize: 70,
              ),
              IconButton(
                icon: const Icon(Icons.speed),
                tooltip: '20km/h',
                color: Colors.blue,
                onPressed:
                    _mode != null && _mode != 2 ? () => _setSpeed(2) : null,
                iconSize: 70,
              ),
              IconButton(
                icon: const Icon(Icons.speed),
                tooltip: '25km/h',
                color: Colors.yellow,
                onPressed:
                    _mode != null && _mode != 3 ? () => _setSpeed(3) : null,
                iconSize: 70,
              ),
              IconButton(
                icon: const Icon(Icons.speed),
                tooltip: '35km/h',
                color: Colors.red,
                onPressed:
                    _mode != null && _mode != 0 ? () => _setSpeed(0) : null,
                iconSize: 70,
              ),
            ],
          ),
          Text(
            'MAC: ${_disconnected ? "lost connection" : (_id ?? "searching")}',
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            '${_speed != null ? "Speed: ${_speed! / 10}" : ""}',
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            '${_trip != null ? "Trip: ${_trip! / 10}" : ""}',
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            '${_odo != null ? "Odometer: $_odo" : ""}',
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            '${_zeroStart != null ? "Zero Start: $_zeroStart" : ""}',
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            '${_battery != null ? "Battery: $_battery %" : ""}',
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            '${_lights != null ? "Lights: $_lights" : ""}',
            style: TextStyle(fontSize: 20.0),
          )
        ],
      ),
      floatingActionButton: _disconnected
          ? FloatingActionButton.extended(
              onPressed: _connect,
              icon: Icon(Icons.bluetooth),
              backgroundColor: Colors.blue,
              label: Text("Reconnect"))
          : null,
    );
  }
}
