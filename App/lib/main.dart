
import 'package:camera/camera.dart';
import 'package:face_camera/face_camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_iot_device/config/firebase_api.dart';
import 'package:home_iot_device/constants/app_colors.dart';
import 'package:home_iot_device/firebase_options.dart';
import 'package:home_iot_device/live_stream_camera.dart';
import 'package:home_iot_device/screen/camera_monitor.dart';
import 'package:home_iot_device/screen/image_mqtt.dart';
import 'package:home_iot_device/screen/smart_home.dart';
import 'package:home_iot_device/screen/widgets/camera_view.dart';
import 'package:home_iot_device/screen/widgets/voice_screen.dart';
import 'package:provider/provider.dart';

import 'camera_mlkit.dart';
import 'core/navigator.dart';
import 'core/router.dart';


List<CameraDescription> cameras = [];
final navigatorKey = GlobalKey<NavigatorState>();
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();

  await FaceCamera.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColor.bgColor,
        fontFamily: "Popppins",

      ),

      home: const Dashboard(),
      onGenerateRoute: AppRouter.generateRoutes,
      navigatorKey: AppNavigator.key,

    );
  }

}


class Dashboard extends StatefulWidget {
  final int initialTab;
  const Dashboard({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _children = const [
    SmartHomeScreen(),
    VoiceHomeScreen(),
    LiveStreamCamera(),
    MonitorPage(),

  ];

  @override
  void initState() {
    _tabController = TabController(length: _children.length, vsync: this);
    _tabController.index = widget.initialTab;
    super.initState();
  }

  void onTabTapped(int index) {
    _tabController.index = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.bgColor,

      body: SafeArea(

        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: _children,
          controller: _tabController,
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(

        backgroundColor: AppColor.bgColor,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _tabController.index,
        unselectedFontSize: 14,
        elevation: 2.0,
        selectedIconTheme: const IconThemeData(color: AppColor.fg1Color),



        items: const [
          BottomNavigationBarItem(

              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_outlined),
              label: "Home"),

          BottomNavigationBarItem(
              icon: Icon(Icons.keyboard_voice_outlined),
              activeIcon: Icon(Icons.keyboard_voice_outlined),
              label: "Voice"),

          BottomNavigationBarItem(
              icon: Icon(Icons.phone_iphone_rounded),
              activeIcon: Icon(Icons.phone_iphone_rounded),
              label: "Camera"),


          // BottomNavigationBarItem(
          //     icon: Icon(Icons.replay_rounded),
          //     activeIcon: Icon(Icons.replay_rounded),
          //     label: "Routine"),

          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              activeIcon: Icon(Icons.bar_chart_rounded),
              label: "Stats"),

        ],
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _theme = ThemeMode.dark;
  ThemeMode get theme => _theme;
  bool get isDark => _theme == ThemeMode.dark;

  void changeMode() {
    _theme = !isDark ? ThemeMode.dark : ThemeMode.light;
    SystemChrome.setSystemUIOverlayStyle(
        isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    notifyListeners();
  }
}




