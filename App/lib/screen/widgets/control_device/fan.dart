
import 'package:home_iot_device/constants/app_colors.dart';
import 'package:home_iot_device/core/navigator.dart';
import 'package:home_iot_device/model/smart_home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../config/mqtt_config.dart';
import '../../room_control_screen.dart';


class FanDevice extends StatefulWidget {
  const FanDevice({super.key, required this.roomData});
  final SmartHomeModel roomData;
  @override
  State<FanDevice> createState() => _FanDeviceState();
}

class _FanDeviceState extends State<FanDevice>{
  int _selectedIndex = 0;
  var status = false;
  MQTTManager client = MQTTManager();
  ValueNotifier<Map<String,dynamic>> acDevice = ValueNotifier<Map<String,dynamic>>({});

  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
      String message = "{\"Fan\":{\"Status\": true,\"Lever\": ${index+1}}}";
      client.publishMessage("home/livingroom", message);
    });
  }






  @override
  void initState() {
    // TODO: implement initState
    client.connect("");
    acDevice = client.data;
    print(acDevice);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final SmartHomeModel roomData = widget.roomData;
    final size = MediaQuery.of(context).size;
    final gradient = [AppColor.fgColor,AppColor.white];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(

          color: AppColor.white,

        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32 + MediaQuery.of(context).padding.top),
              Row(
                children: [

                  InkWell(
                    onTap: () { AppNavigator.pop("/room_control_screen");
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Fan',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fan',
                      ),
                      Text(
                        roomData.roomName,
                      ),
                    ],
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mode',
                      ),
                      Text(
                        '25°C',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),

              const SizedBox(height: 56),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColor.fg1Color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: <Widget>[

                          IconButton(
                            icon: const Icon(Icons.sunny),
                            color: _selectedIndex == 0 ? AppColor.fg1Color : AppColor.black,
                            onPressed: () =>
                                _onButtonPressed(0),
                          ),
                          const Text("->"),
                          IconButton(
                            icon: const Icon(Icons.sunny),
                            color: _selectedIndex == 1 ? AppColor.fg1Color : AppColor.black,
                            onPressed: () =>
                                _onButtonPressed(1),
                          ),
                          const Text("->"),
                          IconButton(
                            icon: const Icon(Icons.sunny),
                            color: _selectedIndex == 2 ? AppColor.fg1Color : AppColor.black,
                            onPressed: () =>
                                _onButtonPressed(2),
                          ),

                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}