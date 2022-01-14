import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:helmetdetection/Screen/homepage.dart';

List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
    runApp(MyApp());
  } catch (e) {}
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(
        cameras: cameras,
      ),
    );
  }
}
