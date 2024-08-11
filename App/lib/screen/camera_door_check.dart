import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraDoorCheck extends StatelessWidget {
  const CameraDoorCheck({super.key});

  static const route = '/camera-door-check';

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Push Notification"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("PushNotifiation Gate")
          ],
        ),
      ),
    );
  }
}
