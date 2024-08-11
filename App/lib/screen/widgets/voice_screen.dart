
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:home_iot_device/constants/app_colors.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../config/mqtt_config.dart';

class VoiceHomeScreen extends StatefulWidget {
  const VoiceHomeScreen({super.key});

  @override
  State<VoiceHomeScreen> createState() => _VoiceHomeScreenState();
}

class _VoiceHomeScreenState extends State<VoiceHomeScreen>
    with SingleTickerProviderStateMixin {

  SpeechToText speechToText  = SpeechToText();
  MQTTManager mqttManager = MQTTManager();
  late final AnimationController _controller;
  dynamic text = '';
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    _startAnimation();
    speechToText.listen(
      onResult: (result)  {
        setState(() {
          text = result.recognizedWords;
          if(text == "on"){
            mqttManager.publishMessage("home/livingroom","{\"Light\":true}");
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller
      ..stop()
      ..reset()
      ..repeat(period: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    bool v = false;
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 32 + MediaQuery.of(context).padding.top),
          const Text(
            'Voice Control',

          ),
          const SizedBox(height: 32),
          VoiceTile(
            name: 'Google Alexa',
            onChanged: (v) {
              v = !v;
            },
            value: v,
          ),


          const SizedBox(height: 200),
          CustomPaint(
            painter: SpritePainter(_controller, AppColor.fgColor),
            child:const Icon(Icons.keyboard_voice_rounded,
                color: AppColor.white, size: 76),
          ),
          const Spacer(),
          Text(
            "Listening${_controller.value > 2 / 3 ? '...' : _controller.value > 1 / 3 ? '..' : '.'}",
          ),
        ],
      ),
    );
  }
}



class SpritePainter extends CustomPainter {
  final Animation<double> _animation;
  final Color _color;

  SpritePainter(this._animation, this._color) : super(repaint: _animation);

  void circle(Canvas canvas, Rect rect, double value) {
    double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    Color color = _color.withOpacity(opacity);

    double size = rect.width;
    double area = size * size;
    double radius = sqrt(area * value);

    final Paint paint = Paint()..color = color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(SpritePainter oldDelegate) {
    return true;
  }
}


class VoiceTile extends StatelessWidget {
  final String name;
  final Function(bool)? onChanged;
  final bool value;
  const VoiceTile({
    super.key,
    required this.name,
    required this.onChanged,
    required this.value,
  });
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style:const  TextStyle(
              color: AppColor.grey
            )
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}
