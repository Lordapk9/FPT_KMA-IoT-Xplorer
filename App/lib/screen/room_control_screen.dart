
import 'package:flutter_animate/flutter_animate.dart';
import 'package:home_iot_device/constants/app_colors.dart';
import 'package:home_iot_device/model/smart_home_model.dart';
import 'package:home_iot_device/config/mqtt_config.dart';
import 'package:home_iot_device/screen/widgets/device_switch.dart';
import 'package:home_iot_device/screen/widgets/glass_morphism.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';

class RoomControlScreen extends StatefulWidget {
  const RoomControlScreen({super.key,  required this.roomData});
  final SmartHomeModel roomData;

  @override
  State<RoomControlScreen> createState() => _RoomControlScreenState();
}

class _RoomControlScreenState extends State<RoomControlScreen> {

  MQTTManager mqttManager = MQTTManager();

  @override
  void initState() {
    mqttManager.connect("home/${widget.roomData.roomName.toLowerCase().replaceAll(' ','')}");
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
  final SmartHomeModel roomData = widget.roomData;
  final size = MediaQuery.of(context).size;
  
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(roomData.roomImage),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding:const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColor.fgColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColor.white,
                          ),
                      ),
                    ),
                    Container(
                      padding:const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColor.fgColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:const Icon(
                        Icons.settings,
                        color: AppColor.white,
                        ),
                    ),
                  ],
                ),
              ),
            ),
            bottomCard(size,roomData),

          ],
        ),
      ),
    );
  }

// thiết lập một khối widget ở dưới  
  Widget bottomCard(Size size, SmartHomeModel roomData) {
    //widget tạo hiệu ứng mờ 
    return GlassMorphism(
      child: SizedBox(
        width: double.infinity,
        height: size.height*0.53,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    roomData.roomName,
                    style:const TextStyle(
                      color: AppColor.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    SizedBox(
                      height: 30,
                      child: FittedBox(
                        child: CupertinoSwitch(
                          value: roomData.roomStatus,
                          activeColor: AppColor.white,
                          trackColor: AppColor.black,
                          thumbColor: AppColor.fgColor,
                          onChanged: (value) {
                            setState(() {
                              roomData.roomStatus = value;
                            });
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Padding(
              padding:  EdgeInsets.only(left: 20,right: 60),
              child: Text.rich(TextSpan(
                text: "Your Room Status",
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 16,
                ),
                children: [
                ],
              )),
            ),
            // ValueListenableBuilder<Map<String,dynamic>>(
            //   builder: (BuildContext context, Map<String,dynamic> value, Widget? child) {
            //     return SizedBox(
            //       height: size.height*0.22,
            //       child: ListView.builder(
            //         itemCount: roomData.devices!.length+2,
            //         scrollDirection: Axis.horizontal,
            //         itemBuilder: (context,index){
            //           final data = roomData.devices![index - 1];
            //           if (value.isNotEmpty) {
            //             value.forEach((key, value) {
            //                 if (key == "Temperature" && value['Status'] != null) {
            //                   data.setDeviceStatus(value['Status']);
            //                 }
            //             });
            //
            //
            //           }
            //           return DeviceSwitch(
            //             data: data, roomData: roomData, mqttManager: mqttManager,);
            //         },
            //       ),
            //     );
            //   },
            //   valueListenable: mqttManager.data,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    roomData.roomTemperature,
                    style:const TextStyle(
                      fontSize: 30,
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.wb_cloudy),
                  const SizedBox(width: 20,),

                  Text(
                    roomData.roomHuminity,
                    style:const TextStyle(
                      fontSize: 30,
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.wb_sunny),
                ],
              ),
            ),
            Divider(
              color: AppColor.white.withOpacity(0.5),
              thickness: 1,
              endIndent: 20,
              indent: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                  'Devices : 4 devices is on',
                  style:TextStyle(
                    fontSize: 25,
                    color: AppColor.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ],
              ),

            ),
            const SizedBox(height: 15,),

            // hiển thị danh sách thiết bị trong phòng, lắng nghe chủ đề sub để cập nhật trạng thái từ mqtt
            ValueListenableBuilder<Map<String,dynamic>>(

              builder: (BuildContext context, Map<String,dynamic> value, Widget? child) {
              return SizedBox(
                height: size.height*0.22,
                child: ListView.builder(
                  itemCount: roomData.devices!.length+2,
                  scrollDirection: Axis.horizontal,

                  itemBuilder: (context,index){

                    if (index == 0 || roomData.devices!.length + 1 == index) {
                      return const SizedBox(
                        width: 10,
                      );
                    }

                    final data = roomData.devices![index - 1];
                    if (value.isNotEmpty) {
                      value.forEach((key, value) {
                        if (data.deviceName == "Fan") {
                          if (key == "Fan" && value['Status'] != null) {
                            data.setDeviceStatus(value['Status']);
                          }
                        }
                        else if (data.deviceName == "AC") {
                          if (key == "AC" && value['Status'] != null) {
                            data.setDeviceStatus(value['Status']);
                          }
                        }

                        else
                        if (data.deviceName == key && data.deviceName != "Fan" &&
                            data.deviceName != "AC") {
                          data.setDeviceStatus(value);
                        }
                      });


                    }
                    return DeviceSwitch(
                      data: data, roomData: roomData, mqttManager: mqttManager,);
                },

              ),

                );


              },
              valueListenable: mqttManager.data,

            ),
          ],

      ),)
    );
  }



}