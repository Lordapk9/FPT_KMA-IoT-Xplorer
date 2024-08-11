import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_iot_device/screen/widgets/control_device/fan.dart';

import '../model/smart_home_model.dart';
import '../screen/widgets/control_device/ac.dart';
import 'route.dart';

abstract class AppRouter {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case ac:
        return getPageRoute(
          settings: settings,
          view: ControlDevice(roomData: settings.arguments as SmartHomeModel),
        );

      case fan:
        return getPageRoute(
          settings: settings,
          view: FanDevice(roomData: settings.arguments as SmartHomeModel),
        );


      default:
        return getPageRoute(
          settings: settings,
          view: Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static PageRoute<dynamic> getPageRoute({
    required RouteSettings settings,
    required Widget view,
  }) {
    return Platform.isAndroid
        ? CupertinoPageRoute(settings: settings, builder: (_) => view)
        : MaterialPageRoute(settings: settings, builder: (_) => view);
  }
}
