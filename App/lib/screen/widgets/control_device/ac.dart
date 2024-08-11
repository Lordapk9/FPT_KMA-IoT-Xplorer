
import 'package:home_iot_device/constants/app_colors.dart';
import 'package:home_iot_device/core/navigator.dart';
import 'package:home_iot_device/model/smart_home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../config/mqtt_config.dart';
import '../../room_control_screen.dart';


class ControlDevice extends StatefulWidget {
  const ControlDevice({super.key, required this.roomData});
  final SmartHomeModel roomData;
  @override
  State<ControlDevice> createState() => _ControlDeviceState();
}

class _ControlDeviceState extends State<ControlDevice>{
  int _selectedIndex = 0;
  double temp = 16.0;
  MQTTManager client = MQTTManager();
  ValueNotifier<Map<String,dynamic>> acDevice = ValueNotifier<Map<String,dynamic>>({});

  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
      String message = "{\"AC\":{\"Mode\": ${index+1}}}";
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
                        'Air Conditioner',
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
                        'AC',
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
                        'Temperature',
                      ),
                      Text(
                        '25°C',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Center(
                child: SleekCircularSlider(
                  min: 16,
                  max: 31,
                  initialValue: temp,
                  appearance: CircularSliderAppearance(
                    size: 300,
                    customColors: CustomSliderColors(
                      progressBarColor: AppColor.fg1Color,
                      trackColor: AppColor.fg1Color.withOpacity(0.3),
                      dotColor: AppColor.fg1Color,
                    ),
                    customWidths: CustomSliderWidths(
                      progressBarWidth: 8,
                      trackWidth: 8,
                      handlerSize: 16,
                    ),
                  ),
                  onChange: (double value) {
                    setState(() {
                      temp = double.parse(value.toStringAsFixed(1));
                      String message = "{\"AC\":{\"Temp\": $temp}}";
                      client.publishMessage("home/livingroom", message);
                      print(temp);
                    });
                  },
                  onChangeStart: (double startValue) {
                    // callback providing a starting value (when a pan gesture starts)
                  },
                  onChangeEnd: (double endValue) {
                    // callback providing an ending value (when a pan gesture ends)
                  },
                  innerWidget: (double value) {
                    //This the widget that will show current value
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "COOL",
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: temp.floor() <= 16
                                    ? AppColor.fg1Color.withOpacity(0.3)
                                    : AppColor.fg1Color,
                                child: IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: temp.floor() <= 16
                                      ? null
                                      : () {
                                    setState(() {
                                      temp--;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 26),
                              Text(
                                "${value.toStringAsFixed(1)}°C",
                              ),
                              const SizedBox(width: 26),
                              CircleAvatar(
                                backgroundColor: temp.round() == 31
                                    ? AppColor.fg1Color.withOpacity(0.3)
                                    : AppColor.fg1Color,
                                child: IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: temp.round() == 31
                                      ? null
                                      : () {
                                    setState(() {
                                      temp++;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 56),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 27.5, vertical: 6.5),
                            decoration: BoxDecoration(
                              color: AppColor.fg1Color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text(
                              "Auto Adjust",
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                ),
              ),
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
                          IconButton(
                            icon: const Icon(Icons.sunny),
                            color: _selectedIndex == 1 ? AppColor.fg1Color : AppColor.black,
                            onPressed: () =>
                                _onButtonPressed(1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.sunny),
                            color: _selectedIndex == 2 ? AppColor.fg1Color : AppColor.black,
                            onPressed: () =>
                                _onButtonPressed(2),
                          ),
                          IconButton(
                            icon: const Icon(Icons.sunny),
                            color: _selectedIndex == 3 ? AppColor.fg1Color : AppColor.black,
                            onPressed: () =>
                                _onButtonPressed(3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                  ],
                ),
              ),
              const SizedBox(height: 40),
                  Center(
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}