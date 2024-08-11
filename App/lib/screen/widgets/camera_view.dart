//
// import 'dart:io';
//
// import 'package:camera/camera.dart';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../constants/screen_mode.dart';
// import '../../main.dart';
//
// class BottomCamera extends StatefulWidget{
//   final String title;
//   final CustomPaint? customPaint;
//   final String? text;
//   final Function(InputImage inputImage) onImage;
//   final CameraLensDirection initialDirection;
//   const BottomCamera({super.key, required this.title, this.customPaint, this.text, required this.onImage, required this.initialDirection});
//
//   @override
//   State<BottomCamera> createState() => _BottomCamera();
// }
//
// class _BottomCamera extends State<BottomCamera> {
//   ScreenMode _mode = ScreenMode.live;
//   CameraController? _controller;
//   File? _image;
//   String? _path;
//   ImagePicker? _imagePicker;
//   int _cameraIndex = 0;
//   double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
//   final bool _allowPicker = true;
//   bool _changingCameraLens = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//
//     super.initState();
//     _imagePicker = ImagePicker();
//     if(cameras.any(
//             (element) =>
//                 element.lensDirection == widget.initialDirection &&
//                 element.sensorOrientation == 90,
//     )) {
//       _cameraIndex = cameras.indexOf(
//         cameras.firstWhere(
//                 (element) =>
//                   element.lensDirection == widget.initialDirection &&
//                   element.sensorOrientation == 90
//         ),
//       );
//     } else {
//       _cameraIndex = cameras.indexOf(
//         cameras.firstWhere(
//                 (element) => element.lensDirection == widget.initialDirection
//         ),
//       );
//     }
//
//     _startLive();
//   }
//
//   Future _startLive() async {
//     final camera = cameras[_cameraIndex];
//     _controller = CameraController(
//         camera,
//       ResolutionPreset.high,
//       enableAudio: false,
//     );
//
//     _controller?.initialize().then(
//             (_) {
//               if (!mounted) {
//                 return;
//               }
//
//               _controller?.getMaxZoomLevel().then((value) {
//                 maxZoomLevel = value;
//
//               });
//
//               _controller?.getMaxZoomLevel().then((value) {
//                 zoomLevel = value;
//                 minZoomLevel = value;
//               });
//
//               _controller?.startImageStream(_processCameraImage);
//               setState(() {});
//             }
//     );
//   }
//
//   Future _processCameraImage(final CameraImage image) async {
//     final WriteBuffer allBytes = WriteBuffer();
//     for(final Plane plane in image.planes){
//       allBytes.putUint8List(plane.bytes);
//     }
//     final bytes = allBytes.done().buffer.asUint8List();
//     final Size imageSize = Size(
//       image.width.toDouble(),
//       image.height.toDouble(),
//     );
//
//     final camera = cameras[_cameraIndex];
//     final imageRotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
//                             InputImageRotation.rotation0deg;
//     final inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw) ??
//                                 InputImageFormat.nv21;
//
//     final planeData = image.planes.map((final Plane plane) {
//       return InputImagePlaneMetadata(
//         bytesPerRow: plane.bytesPerRow,
//         height: plane.height,
//         width: plane.width
//       );
//     }).toList();
//
//     final inputImageData = InputImageData(
//       size: imageSize,
//       imageRotation: imageRotation,
//       inputImageFormat: inputImageFormat,
//       planeData: planeData,
//     );
//     final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
//     widget.onImage(inputImage);
//   }
//
//
//   @override
//   Widget build(BuildContext context)
//     => Scaffold(
//       appBar: AppBar(title: Text(widget.title),
//         actions: [
//           if(_allowPicker)
//             Padding(padding: const EdgeInsets.only(right: 20.0),
//             child: GestureDetector(
//               onTap: () {},
//               child: Icon(_mode == ScreenMode.live
//                           ? Icons.photo_library_rounded
//                           : (Platform.isAndroid?Icons.camera_alt_outlined : Icons.camera),
//               ),
//             ),
//             ),
//         ],
//       ),
//       body: _body(),
//       floatingActionButton: _floatingActionButton(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   Widget? _floatingActionButton() {
//     if(_mode == ScreenMode.gallery)
//       return null;
//     if(cameras.length==1)return null;
//     return SizedBox(
//       height: 70,
//       width: 70,
//       child: FloatingActionButton(
//         onPressed: _switcherCamera,
//         child: Icon(
//           Platform.isAndroid
//               ? Icons.flip_camera_android_outlined
//               : Icons.flip_camera_android_outlined,
//           size: 40,
//         ),
//       ),
//     );
//   }
//
//   Future _switcherCamera()async{
//     setState(() {
//       _changingCameraLens=true;
//     });
//     _cameraIndex=(_cameraIndex+1)%cameras.length;
//     await _stopLive();
//     await _startLive();
//     setState(() {
//       _changingCameraLens=false;
//     });
//   }
//
//   Widget _galleryBody() => ListView(
//     shrinkWrap: true,
//     children: [
//       _image!=null?SizedBox(
//         height: 400,
//         width: 400,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.file(_image!),
//           if(widget.customPaint!=null)widget.customPaint!,
//         ],
//       )
//
//     ): const Icon(
//         Icons.image,
//         size: 200,
//       ),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0,),
//         child: ElevatedButton(
//           onPressed: () => _getImage(ImageSource.gallery),
//           child: const Text('From Galeery'),
//         ),
//       ),
//       Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0,),
//         child: ElevatedButton(
//           onPressed: () => _getImage(ImageSource.camera),
//           child: const Text("Take a picture"),
//         ),
//       ),
//
//       Padding(
//         padding: EdgeInsets.all(16),
//         child: Text(
//           '${_path == null ? '': 'image path: $_path'}\n\n${widget.text ?? ''}'
//         ),
//       ),
//     ],
//   );
//
//   Future _getImage(ImageSource source) async{
//     setState(() {
//       _image=null;
//       _path=null;
//     });
//     final pickedFile = await _imagePicker?.pickImage(source: source);
//     if(pickedFile!=null){
//       _processPickedFile(pickedFile);
//     }
//   }
//
//   Future _processPickedFile(XFile? pickedFile) async{
//     final path = pickedFile?.path;
//     if(path == null){
//       return;
//     }
//     setState(() {
//       _image=File(path);
//     });
//     _path=path;
//     final inputImage = InputImage.fromFilePath(path);
//     widget.onImage(inputImage);
//   }
//   Widget _body() {
//     Widget body;
//     if(_mode == ScreenMode.live){
//       body = _liveBody();
//     }else{
//       body = _galleryBody();
//     }
//     return body;
//   }
//
//   Widget _liveBody() {
//     if(_controller?.value.isInitialized==false){
//       return Container();
//     }
//     final size = MediaQuery.of(context).size;
//     //
//     //
//     //
//     var scale = size.aspectRatio*_controller!.value.aspectRatio;
//     if(scale<1)scale = 1/scale;
//     return Container(
//       color: Colors.black,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           Transform.scale(
//             scale: scale,
//             child: Center(
//               child: _changingCameraLens ? const Center(
//                 child: Text("Changing camera len"),
//               ) : CameraPreview(_controller!),
//             ),
//           ),
//           if(widget.customPaint!=null)widget.customPaint!,
//           Positioned(
//
//             bottom: 100,
//             left: 50,
//             right: 50,
//             child: Slider(
//               value: zoomLevel,
//               min: minZoomLevel,
//               max: maxZoomLevel,
//               onChanged: (final newSliderValue){
//                 setState(() {
//                   zoomLevel=newSliderValue;
//                   _controller!.setZoomLevel(zoomLevel);
//                 });
//               },
//               divisions: (maxZoomLevel-1).toInt()<1?null:(maxZoomLevel - 1).toInt(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//   void _switchScreenMode(){
//     _image = null;
//     if (_mode == ScreenMode.live) {
//       _mode = ScreenMode.gallery;
//       _stopLive();
//     }else{
//       _mode = ScreenMode.live;
//       _startLive();
//     }
//     setState(() {
//
//     });
//   }
//
//   Future _stopLive() async {
//     await _controller?.stopImageStream();
//     await _controller?.dispose();
//     _controller = null;
//   }
// }


import 'dart:convert';
import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../config/mqtt_config.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _MyAppState();
}

class _MyAppState extends State<CameraView> {
  File? _capturedImage;

  late FaceCameraController controller;
  MQTTManager client = MQTTManager();



  @override
  void initState() {
    client.connect("");
    controller = FaceCameraController(
      autoCapture: false,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) {
        setState(() => _capturedImage = image);
        if (image != null) {
          client.sendImageToMQTT(image);
        }
      },
      onFaceDetected: (Face? face) {
        //Do something
        if(face != null) {
          Future.delayed(const Duration(seconds: 2), () {
            controller?.captureImage();
          });
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('FaceCamera example app'),
          ),
          body: Builder(builder: (context) {
            if (_capturedImage != null) {
              return Center(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.file(
                      _capturedImage!,
                      width: double.maxFinite,
                      fit: BoxFit.fitWidth,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await controller.startImageStream();
                          setState(() => _capturedImage = null);
                        },
                        child: const Text(
                          'Capture Again',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ))
                  ],
                ),
              );
            }

            return SmartFaceCamera(
                controller: controller,
                messageBuilder: (context, face) {
                  if (face == null) {
                    return _message('Place your face in the camera');
                  }
                  if (!face.wellPositioned) {
                    return _message('Center your face in the square');
                  }
                  return const SizedBox.shrink();
                });
          })),
    );
  }

  Widget _message(String msg) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
    child: Text(msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)),
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}