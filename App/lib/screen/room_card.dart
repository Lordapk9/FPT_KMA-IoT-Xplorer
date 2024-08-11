import 'package:home_iot_device/constants/app_colors.dart';
import 'package:home_iot_device/model/smart_home_model.dart';
import 'package:home_iot_device/config/mqtt_config.dart';
import 'package:home_iot_device/config/mqtt_methob.dart';
import 'package:home_iot_device/screen/room_control_screen.dart';
import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({super.key,required this.roomData});
  final SmartHomeModel roomData;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<SmartHomeModel> smarthomeList;
    MqttMethob mqtt = new MqttMethob();
    final String topic = "smarthome/${roomData.roomImage}";




    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => RoomControlScreen(roomData: roomData,),
          ));
      },
      child: SingleChildScrollView(
        child: Container(
          width: size.width*0.65,
          height: size.height*0.5,
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.fgColor,
            borderRadius: BorderRadius.circular(size.width*0.07),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(roomData.roomImage),
              colorFilter: ColorFilter.mode(AppColor.black.withOpacity(0.2), BlendMode.darken),
            ),
          ),
          child: Text(
            roomData.roomName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColor.black,
            ),
            ),
        ),
      ),
    );
  }

  
}