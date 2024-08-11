import 'package:flutter/material.dart';

class CameraMonitor extends StatefulWidget {
  const CameraMonitor({super.key});

  @override
  State<CameraMonitor> createState() => _CameraMonitorState();

 
}

class _CameraMonitorState extends State<CameraMonitor> {
  void _onButtonPressed(String direction) {
    print('Button $direction pressed');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cameras Monitor'),
      ),
      body: Container(
        child: SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 50,
                left: 120,
                child: ElevatedButton(
                  onPressed: () => _onButtonPressed('Up'),
                  child: const Icon(Icons.arrow_upward),
                ),
              ),
              Positioned(
                bottom: 60,
                left: 120,
                child: ElevatedButton(
                  onPressed: () => _onButtonPressed('Down'),
                  child: const Icon(Icons.arrow_downward),
                ),
              ),
              Positioned(
                top: 120,
                left: 40,
                child: ElevatedButton(
                  onPressed: () => _onButtonPressed('Left'),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              Positioned(
                top: 120,
                right: 27,
                child: ElevatedButton(
                  onPressed: () => _onButtonPressed('Right'),
                  child: const Icon(Icons.arrow_forward),
                ),
              ),

              Positioned(
                top: 120,
                left: 120,
                child: ElevatedButton(
                  onPressed: () => _onButtonPressed('Center'),
                  child: const Icon(Icons.circle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}