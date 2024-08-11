import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class Device {
  String deviceName;
  bool deviceStatus;

  Device({required this.deviceName, required this.deviceStatus});
}

class DeviceListScreen extends StatefulWidget {
  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    _fetchDeviceStatus();
  }

  void _fetchDeviceStatus() async {
    final client = mqtt.MqttClient('192.168.56.101', '1883');
    try {
      await client.connect('phong', 'Zodiac2752003.');
       client.subscribe('smarthome/livingroom', mqtt.MqttQos.atMostOnce);

      client.updates!.listen((List<mqtt.MqttReceivedMessage> messages) {
        for (var message in messages) {
          final payload =
              mqtt.MqttPublishPayload.bytesToStringAsString(message.payload.message);
          _updateDeviceList(payload);
        }
      });
    } catch (e) {
      print('Exception: $e');
      _useDefaultDeviceList();
    }
  }

  void _updateDeviceList(String payload) {
    final Map<String, dynamic> json = jsonDecode(payload);
    setState(() {
      devices.clear();
      json.forEach((key, value) {
        devices.add(Device(deviceName: key, deviceStatus: value));
      });
    });
  }

  void _useDefaultDeviceList() {
    setState(() {
      devices = [
        Device(deviceName: "WiFi", deviceStatus: true),
        Device(deviceName: "Light", deviceStatus: true),
        Device(deviceName: "Fan", deviceStatus: true),
        Device(deviceName: "TV", deviceStatus: true),
        Device(deviceName: "AC", deviceStatus: true),
        Device(deviceName: "Home Theater", deviceStatus: true),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device List'),
      ),
      body: devices.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text(device.deviceName),
                  subtitle: Text(device.deviceStatus ? 'On' : 'Off'),
                );
              },
            ),
    );
  }
}
