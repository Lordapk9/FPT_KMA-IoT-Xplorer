import 'package:home_iot_device/constants/app_colors.dart';
import 'package:home_iot_device/model/smart_home_model.dart';
import 'package:home_iot_device/config/mqtt_config.dart';

import 'package:home_iot_device/screen/widgets/control_device/ac.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../core/navigator.dart';


class DeviceSwitch extends StatefulWidget{
  const DeviceSwitch({super.key, required this.data, required this.roomData, required this.mqttManager});
  final DeviceInRoom data;
  final SmartHomeModel roomData;
  final MQTTManager mqttManager;
  @override
  State<DeviceSwitch> createState() => _DeviceSwitchSate();
}
class _DeviceSwitchSate extends State<DeviceSwitch> {
  MQTTManager mqttManager = MQTTManager();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    }

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    final DeviceInRoom data = widget.data;
    final SmartHomeModel roomData = widget.roomData;

    final Duration _duration = Duration(milliseconds: 300);
    

    return GestureDetector(
      onTap: () {
        setState(() {

          data.deviceStatus = !data.deviceStatus;

          if(data.deviceName == "Fan"){
            widget.mqttManager.publishMessage("home/${widget.roomData.roomName.toLowerCase().replaceAll(' ','')}", "{\"${data.deviceName}\": { \"Status\": ${data.deviceStatus},\"Lever\":1}}");
          }else if(data.deviceName == "AC"){
            widget.mqttManager.publishMessage("home/${widget.roomData.roomName.toLowerCase().replaceAll(' ','')}", "{\"${data.deviceName}\": { \"Status\": ${data.deviceStatus}}}");
          }
          else if(data.deviceName == "Door"){
            widget.mqttManager.publishMessage("home/camera/door",
                "{\"stream_status\":${data.deviceStatus?1:0}}");
          }
          else {
            widget.mqttManager.publishMessage("home/${widget.roomData.roomName.toLowerCase().replaceAll(' ','')}",
                "{\"${data.deviceName}\":${data.deviceStatus}}");
          }

        });
      },
      child: Container(
        width: size.width*0.42,
        margin:const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.black.withOpacity(.4),
          borderRadius: BorderRadius.circular(30),
        ),
        
        child: Row(
          children: [
            Expanded(

              child:
                   Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      AnimatedPositioned(
                        top: !data.deviceStatus ? 0 : -size.height*0.22/2,
                        duration: _duration,
                        child: Column(
                          children: [
                            _deviceStatus(data),
                            _deviceName(size, data),
                          ],
                        ),
                      ),

                      AnimatedPositioned(
                        bottom: data.deviceStatus ? 0 : -size.height*0.22/2,
                        duration: _duration,
                        child: Column(
                          children: [
                            _deviceStatus(data),
                            _deviceName(size, data),

                          ],
                        ),
                      ),

                      AnimatedPositioned(
                        top: data.deviceStatus ? 0 : (size.height*0.22/2)-10,
                        duration: _duration,
                        child: Container(
                          padding:const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: data.deviceStatus ? AppColor.white:AppColor.black,
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.black.withOpacity(.2),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Icon(
                            data.deviceStatus ? data.iconOn : data.iconOff,
                            color: AppColor.fgColor,

                          ),
                        ),
                      ),

                    ],
                  ),


              ),




            Expanded(
              
              child: Container(
                
                decoration: BoxDecoration(
                  color: AppColor.black.withOpacity(.4),
                  borderRadius: BorderRadius.circular(30),
                ),

                child: IconButton(

                    onPressed: () {
                      var device = '/${data.deviceName.toLowerCase()}';
                      AppNavigator.pushNamed(device, arguments: roomData);
                    },
                    icon:const Icon(Icons.arrow_forward_ios),
                    color: AppColor.fgColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _deviceName(Size size, DeviceInRoom data) {
    
    return Container(
          margin:const EdgeInsets.all(8.0),
          width: size.width*0.22-16,
          child: Text(
            
            data.deviceName,
            textAlign: TextAlign.left,
            maxLines: 2,
            style:const TextStyle(
              color: AppColor.white,
              overflow: TextOverflow.ellipsis,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        );
  }

  Padding _deviceStatus(DeviceInRoom data) {
    return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            data.deviceStatus?"On":"Off",
            textAlign: TextAlign.left,
            style:const TextStyle(
              color: AppColor.white,              
              fontWeight: FontWeight.w300,
            ),
            ),
        );
    }
  }
