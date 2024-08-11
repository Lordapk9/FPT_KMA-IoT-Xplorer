
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTManager extends ChangeNotifier {
  final ValueNotifier<Map<String,dynamic>> data = ValueNotifier<Map<String,dynamic>>({});
  final ValueNotifier<String> topics = ValueNotifier<String>("");
  late MqttServerClient client;


  Future<Object> connect(String topic) async {
    client = MqttServerClient.withPort(
        '192.168.137.249', 'mobile_client', 1883);
    client.logging(on: true);
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;
    client.logging(on: true);

    client.setProtocolV311();

    final connMessage = MqttConnectMessage()
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillRetain()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      print('Exception connection with mqtt: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT_LOGS::Mosquitto client connected');
    } else {
      print(
          'MQTT_LOGS::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      return -1;
    }

    client.subscribe(topic, MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;

      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      data.value = jsonDecode(pt);
      notifyListeners();
      print(
          'MQTT_LOGS:: New data arrived: topic is <${c[0].topic}>, payload is $pt');
      print('');
    });

    return client;
  }
  

  void disconnect(){
    client.disconnect();
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
   
  }

  void onConnected() {
    print('MQTTClient::Connected');
  }

  void onDisconnected() {
    print('MQTTClient::Disconnected');
  }

  void onSubscribed(String topic) {
    print('MQTT_LOGS:: Subscribed topic: $topic');
  }

  void pong() {
    print('MQTTClient::Ping response received');
  }

  void publishMessage(String pubTopic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(pubTopic, MqttQos.atMostOnce, builder.payload!);
    }
  }


  void sendImageToMQTT(File image) async  {
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);
    final message = MqttClientPayloadBuilder();
    message.addString(base64Image);

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      client!.publishMessage('home/camera', MqttQos.atMostOnce, message.payload!);
      print('Image sent to MQTT broker');
    } else {
      print('MQTT connection failed');
    }
  }


}
