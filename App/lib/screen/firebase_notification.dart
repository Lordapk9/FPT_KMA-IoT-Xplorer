import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseNotification extends StatefulWidget {
  const FirebaseNotification({super.key});
  
  @override
  State<FirebaseNotification> createState() => _FirebaseNotificationState();
}

class _FirebaseNotificationState extends State<FirebaseNotification>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),

    );
  }
  
}