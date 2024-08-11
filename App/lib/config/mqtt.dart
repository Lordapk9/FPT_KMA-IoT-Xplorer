import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_iot_device/constants/app_colors.dart';
import 'package:home_iot_device/config/mqtt_methob.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MyPageMqtt extends StatefulWidget {
  const MyPageMqtt({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyPageMqtt> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyPageMqtt> {
  void _onButtonPressed(String direction) {
    print('Button $direction pressed');
  }
  MqttMethob mqttClientManager = MqttMethob();
  final String pubTopic = "smarthome/livingroom";
  Map<String, dynamic> data = {};

  @override
  void initState() {
    setupMqttClient();
    setupUpdatesListener();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(widget.title),
    //   ),
    //   body: Center(
    //     child: Column(
    //       children: [
    //         Flexible(
    //           flex: 3,
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: <Widget>[
    //               const Text(
    //                 'You have pushed the button this many times:',
    //               ),
    //               Text(
    //                 '$_counter',
    //                 style: Theme.of(context).textTheme.headline4,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _incrementCounter,
    //     tooltip: 'Increment',
    //     child: const Icon(Icons.add),
    //   ), 
    // );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.3,
              decoration: BoxDecoration(
                color: AppColor.fgColor,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            SizedBox(height: 100,),
            Container(
              
              child: SizedBox(
                width: 300,
                height: 300,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 50,
                      left: 120,
                      child: ElevatedButton(
                        onPressed: () => _onButtonPressed('Up'),
                        child: const Icon(Icons.arrow_upward),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 120,
                      child: ElevatedButton(
                        onPressed: () => _onButtonPressed('Down'),
                        child: const Icon(Icons.arrow_downward),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      left: 40,
                      child: ElevatedButton(
                        onPressed: () => _onButtonPressed('Left'),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      right: 27,
                      child: ElevatedButton(
                        onPressed: () => _onButtonPressed('Right'),
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ),

                    Positioned(
                      top: 120,
                      left: 120,
                      child: ElevatedButton(
                        onPressed: () => _onButtonPressed('Center'),
                        child: const Icon(Icons.circle),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setupMqttClient() async {
    await mqttClientManager.connect(pubTopic);
    mqttClientManager.subscribe(pubTopic);
  }

  void setupUpdatesListener() {
    mqttClientManager
        .getMessagesStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      
      data = jsonDecode(pt);
      
      print(data['led']);
      print('MQTTClient::Message received on topic: <${c[0].topic}> is $pt');
    });
  }

  @override
  void dispose() {
    mqttClientManager.disconnect();
    super.dispose();
  }
}






// final VlcPlayercontroller = VlcPlacontrooler.network('url',
// hwAcc full  autoplay true option VlcPlayerOption)
//Vlc(controller: vlcplayercontroller,
//asspectratio: 16/9)