
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../core/route.dart';

class SmartHomeModel extends ChangeNotifier {
  String roomName;
  String roomImage;
  String roomTemperature;
  String roomHuminity;
  int userAccess;
  bool roomStatus;
  List<DeviceInRoom>? devices;
  SmartHomeModel({
    required this.roomName,
    required this.roomImage,
    required this.roomTemperature,
    required this.roomHuminity,
    required this.userAccess,
    this.roomStatus = false,
    this.devices,
  });

  PanelController pc = PanelController();
  bool isACon = true;
  final List<bool> isSelected = [true, false, false, false];
  double timerHours = 8;

  void acSwitch(bool value) {
    isACon = value;
    notifyListeners();
  }

  void onToggleTapped(int index) {
    for (int i = 0; i < isSelected.length; i++) {
      isSelected[i] = i == index;
    }
    notifyListeners();
  }

  void changeTimerHours(double newval) {
    timerHours = newval;
    notifyListeners();
  }
}

class DeviceInRoom {
  String deviceName;
  IconData? iconOn;
  IconData? iconOff;
  bool deviceStatus;
  
  void setDeviceStatus(bool status){
    deviceStatus = status;
  }

  String get getDeviceName => deviceName;
  DeviceInRoom({
    required this.deviceName,
     this.iconOn,
     this.iconOff,
    this.deviceStatus = false,
  });
  

  factory DeviceInRoom.fromJson(Map<String, dynamic> json) {
    return DeviceInRoom(
      deviceName: json.keys.first,
      deviceStatus: json.values.first,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceName': deviceName,
      'deviceStatus': deviceStatus,
    };
  }


}





class ListData{


List<SmartHomeModel> smartHomeData = [
  
  SmartHomeModel(
    roomName: "Living Room",
    roomImage: "assets/images/living_room.jpg",
    roomTemperature: "25°",
    roomHuminity: "20%",
    userAccess: 4,
    roomStatus: true,
    devices: [
      DeviceInRoom(
        deviceName: "WiFi",
        iconOn: Icons.wifi,
        iconOff: Icons.wifi_off,
      ),
      DeviceInRoom(
        deviceName: "Light",
        iconOn: Icons.lightbulb_rounded,
        iconOff: Icons.lightbulb_outline_rounded,
        
      ),
      DeviceInRoom(
        deviceName: "Fan",
        iconOn: Icons.air,
        iconOff: Icons.mode_fan_off_outlined,
        
      ),
      DeviceInRoom(
        deviceName: "TV",
        iconOn: Icons.tv,
        iconOff: Icons.tv_off,
        
      ),
      DeviceInRoom(
        deviceName: "AC",
        iconOn: Icons.ac_unit,
        iconOff: Icons.thermostat,
        
      ),
      DeviceInRoom(
        deviceName: "Door",
        iconOn: Icons.speaker_outlined,
        iconOff: Icons.volume_off_outlined,
      ),
    ],
  ),
  SmartHomeModel(
    roomName: "Bethroom",
    roomImage: "assets/images/bed_room.jpg",
    roomTemperature: "25°",
    roomHuminity: "20%",
    userAccess: 1,
    roomStatus: true,
    devices: [
      DeviceInRoom(
        deviceName: "WiFi",
        iconOn: Icons.wifi,
        iconOff: Icons.wifi_off,
        
      ),
      DeviceInRoom(
        deviceName: "Light",
        iconOn: Icons.lightbulb_rounded,
        iconOff: Icons.lightbulb_outline_rounded,
        
      ),
      DeviceInRoom(
        deviceName: "Fan",
        iconOn: Icons.air,
        iconOff: Icons.mode_fan_off_outlined,
        
      ),
      DeviceInRoom(
        deviceName: "TV",
        iconOn: Icons.tv,
        iconOff: Icons.tv_off,
        
      ),
      DeviceInRoom(
        deviceName: "Home Theater",
        iconOn: Icons.speaker_outlined,
        iconOff: Icons.volume_off_outlined,
        
      ),
      DeviceInRoom(
        deviceName: "AC",
        iconOn: Icons.ac_unit,
        iconOff: Icons.thermostat,
        
      ),
    ],
  ),
  SmartHomeModel(
    roomName: "Dining Room",
    roomImage: "assets/images/dining_room.jpg",
    roomTemperature: "25°",
    roomHuminity: "20%",
    userAccess: 4,
    roomStatus: true,
    devices: [
      DeviceInRoom(
        deviceName: "WiFi",
        iconOn: Icons.wifi,
        iconOff: Icons.wifi_off,
        
      ),
      DeviceInRoom(
        deviceName: "Light",
        iconOn: Icons.lightbulb_rounded,
        iconOff: Icons.lightbulb_outline_rounded,
        
      ),
      DeviceInRoom(
        deviceName: "Fan",
        iconOn: Icons.air,
        iconOff: Icons.mode_fan_off_outlined,
        
      ),
      DeviceInRoom(
        deviceName: "AC",
        iconOn: Icons.ac_unit,
        iconOff: Icons.thermostat,
        
      ),
    ],
  ),
  SmartHomeModel(
    roomName: "Kitchen",
    roomImage: "assets/images/kitchen.jpg",
    roomTemperature: "25°",
    roomHuminity: "20%",
    userAccess: 2,
    roomStatus: true,
    devices: [
      DeviceInRoom(
        deviceName: "WiFi",
        iconOn: Icons.wifi,
        iconOff: Icons.wifi_off,
        
      ),
      DeviceInRoom(
        deviceName: "Light",
        iconOn: Icons.lightbulb_rounded,
        iconOff: Icons.lightbulb_outline_rounded,
        
      ),
      DeviceInRoom(
        deviceName: "Chimney",
        iconOn: Icons.air,
        iconOff: Icons.power_off_outlined,
        
      ),
      DeviceInRoom(
        deviceName: "Fridge",
        iconOn: Icons.kitchen,
        iconOff: Icons.power_off_outlined,
        
      ),
      DeviceInRoom(
        deviceName: "Microwave",
        iconOn: Icons.microwave,
        iconOff: Icons.power_off_outlined,
        
      ),
      DeviceInRoom(
        deviceName: "Grinder",
        iconOn: Icons.power,
        iconOff: Icons.power_off_outlined,
        
      ),
      DeviceInRoom(
        deviceName: "Induction",
        iconOn: Icons.power,
        iconOff: Icons.power_off_outlined,
        
      ),
      DeviceInRoom(
        deviceName: "Coffee Maker",
        iconOn: Icons.coffee_maker_outlined,
        iconOff: Icons.power_off_outlined,
        
      ),
      DeviceInRoom(
        deviceName: "AC",
        iconOn: Icons.ac_unit,
        iconOff: Icons.thermostat,
        
      ),
    ],
  ),
  SmartHomeModel(
    roomName: "Kid's Bedroom",
    roomImage: "assets/images/living_room.jpg",
    roomTemperature: "25°",
    roomHuminity: "20%",
    userAccess: 2,
    roomStatus: true,
    devices: [
      DeviceInRoom(
        deviceName: "WiFi",
        iconOn: Icons.wifi,
        iconOff: Icons.wifi_off,
        
      ),
      DeviceInRoom(
        deviceName: "Light",
        iconOn: Icons.lightbulb_rounded,
        iconOff: Icons.lightbulb_outline_rounded,
        
      ),
      DeviceInRoom(
        deviceName: "Fan",
        iconOn: Icons.air,
        iconOff: Icons.mode_fan_off_outlined,
        
      ),
      DeviceInRoom(
        deviceName: "AC",
        iconOn: Icons.ac_unit,
        iconOff: Icons.thermostat,
        
      ),
    ],
  ),
  SmartHomeModel(
    roomName: "Home Office",
    roomImage: "assets/images/home_office.jpg",
    roomTemperature: "25°",
    roomHuminity: "20%",
    userAccess: 1,
    roomStatus: true,
    devices: [
      DeviceInRoom(
        deviceName: "WiFi",
        iconOn: Icons.wifi,
        iconOff: Icons.wifi_off,
        
      ),
      DeviceInRoom(
        deviceName: "Light",
        iconOn: Icons.lightbulb_rounded,
        iconOff: Icons.lightbulb_outline_rounded,
        
      ),
      DeviceInRoom(
        deviceName: "Fan",
        iconOn: Icons.air,
        iconOff: Icons.mode_fan_off_outlined,
        
      ),
      DeviceInRoom(
        deviceName: "AC",
        iconOn: Icons.ac_unit,
        iconOff: Icons.thermostat,
        
      ),
    ],
  ),
  SmartHomeModel(
    roomName: "Guest Room",
    roomImage: "assets/images/living_room.jpg",
    roomTemperature: "25°",
    roomHuminity: "20%",
    userAccess: 1,
    roomStatus: true,
    devices: [
      DeviceInRoom(
        deviceName: "Light",
        iconOn: Icons.lightbulb_rounded,
        iconOff: Icons.lightbulb_outline_rounded,
        
      ),
      DeviceInRoom(
        deviceName: "Fan",
        iconOn: Icons.air,
        iconOff: Icons.mode_fan_off_outlined,
        
      ),
      DeviceInRoom(
        deviceName: "TV",
        iconOn: Icons.tv,
        iconOff: Icons.tv_off,
        
      ),
      DeviceInRoom(
        deviceName: "AC",
        iconOn: Icons.ac_unit,
        iconOff: Icons.thermostat,
        
      ),
    ],
  ),
  SmartHomeModel(
    roomName: "Garage",
    roomImage: "assets/images/garage.jpg",
    roomTemperature: "25°",
    roomHuminity: "20%",
    userAccess: 1,
    roomStatus: true,
    devices: [
      DeviceInRoom(
        deviceName: "Light",
        iconOn: Icons.lightbulb_rounded,
        iconOff: Icons.lightbulb_outline_rounded,
        
      ),
      DeviceInRoom(
        deviceName: "Fan",
        iconOn: Icons.air,
        iconOff: Icons.mode_fan_off_outlined,
        
      ),
    ],
  ),
  SmartHomeModel(
    roomName: "Laundry Room",
    roomImage: "assets/images/living_room.jpg",
    roomTemperature: "25°",
    roomHuminity: "20%",
    userAccess: 4,
    roomStatus: true,
    devices: [
      DeviceInRoom(
        deviceName: "WiFi",
        iconOn: Icons.wifi,
        iconOff: Icons.wifi_off,
        
      ),
      DeviceInRoom(
        deviceName: "Light",
        iconOn: Icons.lightbulb_rounded,
        iconOff: Icons.lightbulb_outline_rounded,
        
      ),
      DeviceInRoom(
        deviceName: "Water Pump",
        iconOn: Icons.water_drop,
        iconOff: Icons.power_off_outlined,
        
      ),
      DeviceInRoom(
        deviceName: "Washing Machine",
        iconOn: Icons.local_laundry_service,
        iconOff: Icons.power_off_outlined,
        
      ),
    ],
  ),
  SmartHomeModel(
    roomName: "Bathroom",
    roomImage: "assets/images/living_room.jpg",
    roomTemperature: "25°",
    roomHuminity: "20%",
    userAccess: 3,
    roomStatus: true,
    devices: [
      DeviceInRoom(
        deviceName: "Light",
        iconOn: Icons.lightbulb_rounded,
        iconOff: Icons.lightbulb_outline_rounded,
        
      ),
      DeviceInRoom(
        deviceName: "Geysers",
        iconOn: Icons.water_drop,
        iconOff: Icons.power_off_outlined,
        
      ),
    ],
  ),
];

}