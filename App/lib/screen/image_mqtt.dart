import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MyImage {
  Uint8List bytes;
  String info;

  MyImage(this.bytes, this.info);
}

class MonitorPage extends StatefulWidget {
  const MonitorPage({Key? key}): super(key: key);

  @override
  State createState() {
    return _MonitorPageState();
  }
}

class _MonitorPageState extends State {
  bool isConnected = false;
  String topic = 'home/camera/door';
  final client = MqttServerClient.withPort(
      '192.168.137.249', 'mobile_client', 1883);
  List<MyImage> images = [];
  var imageWidgets = <Widget>[
    const Text("Nothing Received"),
  ];

  /// initState() is a method which is called once when the stateful widget is inserted in the widget tree.
  @override
  initState() {
    super.initState();

    client.setProtocolV311();

    client.logging(on: false);

    client.keepAlivePeriod = 20;
    client.port = 1883;
  }

  void _connectMqtt() async{

    // avoid reconnect
    if (isConnected == true) {
      return;
    }

    // Connect the client, any errors here are communicated by raising of the appropriate exception.
    try {
      await client.connect();
    } on NoConnectionException catch(e){
      client.disconnect();
      showAlertDialog(context, 'WARNING', e.toString());
      return;
    } on SocketException catch(e){
      // Raised by the socket layer
      client.disconnect();
      showAlertDialog(context, 'WARNING', e.toString());
      return;
    }
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      isConnected = true;
      showAlertDialog(context, 'INFO', 'Someone OutDoor');
    }

    /// Subscribe a topic
    client.subscribe(topic, MqttQos.atMostOnce);


    client.updates!.listen(_onMessage);
  }

  // a callback function for mqtt message
  void _onMessage(List<MqttReceivedMessage> event) {
    final recMess = event[0].payload as MqttPublishMessage;
    final message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    String base64 = '';
    final Map<String, dynamic> cameraImage = jsonDecode(message);

    int relay = cameraImage.containsKey('Relay') ? cameraImage['Relay'] : -1;
    if(relay == 0){
      cameraImage.forEach((key, value) {
        if(key == "image"){
          base64 = value;
        }

      });
    }


    Uint8List decodedBytes;

    decodedBytes = base64Decode(base64);
    // add an image bytes information to list
    images.add(MyImage(decodedBytes, getCurrentTime()));
    _updateImageWidgets();

    setState(() {});
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _updateImageWidgets() {
    imageWidgets = <Widget>[];
    images.map((image) {
      imageWidgets.add(
          Column(
            children: [
              Text(image.info),
              Image.memory(image.bytes),
            ],
          )
      );
    }).toList();
  }

  String getCurrentTime() {
    DateTime now = DateTime.now();
    return now.hour.toString() + ':' + now.minute.toString() + ' '
        + now.day.toString() + '/' + now.month.toString() + '/'
        + now.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cảnh báo người lạ trước cửa'),
          leading: const Icon(Icons.monitor),
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: imageWidgets,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _connectMqtt,
          child: const Icon(Icons.connect_without_contact),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat
    );
  }
}