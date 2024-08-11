import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import 'config/mqtt_config.dart';

class LiveStreamCamera extends StatefulWidget{
  const LiveStreamCamera({super.key});

  @override
  State<LiveStreamCamera> createState() => _LiveStreamCamera();
}

class _LiveStreamCamera extends State<LiveStreamCamera>{
  bool isPlaying = false;
  MQTTManager mqttManager = MQTTManager();



  final VlcPlayerController _camera = VlcPlayerController.network(
    'rtsp://192.168.137.249:8554/stream',
    hwAcc: HwAcc.full,
    autoPlay: true,
    options: VlcPlayerOptions(
      advanced: VlcAdvancedOptions([
      VlcAdvancedOptions.networkCaching(2000), // Tăng bộ đệm mạng
    ]),
    rtp: VlcRtpOptions([
      VlcRtpOptions.rtpOverRtsp(true),
      // Sử dụng RTP qua RTSP
    ]),
    )
  );





  @override
  void initState() {
    // TODO: implement initState


    mqttManager.connect('home/camera');

    super.initState();
  }

  void _toggleStream() {

    // if (!isPlaying) {
    //   _camera.stop();
    // } else {
    //   _camera.play();
    // }

    setState(() {
      isPlaying = !isPlaying;
      if(isPlaying){
        _camera.play();
        mqttManager.publishMessage("home/camera", "{\"stream_status\": 1}");
      }
      else{
        _camera.stop();
        mqttManager.publishMessage("home/camera", "{\"stream_status\": 0}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(isPlaying)
          VlcPlayer(
            controller: _camera,
            aspectRatio: 16/9,
            placeholder: const Center(
              child: CircularProgressIndicator(),
            ),
           ),


          ElevatedButton(
            onPressed: _toggleStream,
            child: Text(isPlaying ? 'Stop Stream' : 'Start Stream'),
          ),

          ValueListenableBuilder<Map<String,dynamic>>(

            builder: (BuildContext context, Map<String,dynamic> value, Widget? child) {
              dynamic motion;
              if(value.isNotEmpty){
                value.forEach((key, value) {
                  if(key == "motion"){
                    motion = value;
                  }
                });
              }
              return SizedBox(
                height: MediaQuery.of(context).size.height*0.22,
                child: Center(
                  child: Text(
                    motion == 1 ? 'Có người trong khu vực giám sát' : 'Không có đối tượng trong khu vực giám sát',
                    style: TextStyle(fontSize: 24),
                  ),
                ),

              );


            },
            valueListenable: mqttManager.data,

          ),
        ],
      ),
    );
  }

  
}