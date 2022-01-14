import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomePage({Key key, this.cameras}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController controller;

  Future loadmodel() async {
    String result = await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
    print("model is loaded $result");
  }

  @override
  void initState() {
    super.initState();
    loadmodel();
    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    controller.initialize().then(
      (_) {
        if (!mounted) {
          return;
        }
        setState(() {
          controller.startImageStream((image) {
            detectImage(image);
          });
        });
      },
    );
  }

  Future detectImage(CameraImage images) async {
    try {
      var res = await Tflite.detectObjectOnFrame(
        bytesList: images.planes.map((e) {
          return e.bytes;
        }).toList(),
        imageHeight: images.height,
        imageWidth: images.width,
        model: "SSDMobileNet",
      ).then((value) {
        print("object is detected $value");
      }).catchError(() {
        print("error occurn");
      });
      print("$res");
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() async {
    controller.dispose();
    await Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Helmet Detection"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: CameraPreview(controller),
      ),
    );
  }
}
