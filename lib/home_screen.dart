import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';

class EmotionDetctor extends StatefulWidget {
  const EmotionDetctor({super.key});

  @override
  State<EmotionDetctor> createState() => _EmotionDetctorState();
}

class _EmotionDetctorState extends State<EmotionDetctor> {
  CameraController? cameraController;
  String output = '';
  double percent = 0;
  loadCamera() {
    cameraController = CameraController(cameres![0], ResolutionPreset.max);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((image) {
            runModel(image);
          });
        });
      }
    });
  }

  runModel(CameraImage? img) async {
    if (img != null) {
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: img.planes.map((plane) {
            return plane.bytes;
          }).toList(), // required
          imageHeight: img.height,
          imageWidth: img.width,
          imageMean: 127.5, // defaults to 127.5
          imageStd: 127.5, // defaults to 127.5
          rotation: 90, // defaults to 90, Android only
          numResults: 2, // defaults to 5
          threshold: 0.1, // defaults to 0.1
          asynch: true // defaults to true
          );
      for (var element in recognitions!) {
        setState(() {
          output = element['label'];
          percent = element['confidence'];
          percent *= 100;
        });
      }
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      labels: 'assets/model/labels.txt',
      model: 'assets/model/model_unquant.tflite',
    );
  }

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: Text(
          'Emotion Detctor',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            width: double.infinity,
            height: 400,
            child: !cameraController!.value.isInitialized
                ? Container()
                : CameraPreview(cameraController!),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            '$output %${(percent).toInt()}',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          Text(
            'Don\'t forget to contact me on social media',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20,left: 20),
            child: Center(
              
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  contacts(
                    url: "https://www.linkedin.com/in/alaa-nasser-4765a2266",
                    image: "assets/images/linkedin.png",
                  ),
                   contacts(
                    url: " https://wa.me/qr/PH3PQN3OEEMAN1",
                    image: "assets/images/whatsapp.png",
                  ),
                   contacts(
                    url: "https://www.facebook.com/koko.jj.547?mibextid=rS40aB7S9Ucbxw6v",
                    image: "assets/images/facebook.png",
                  ),
                  
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class contacts extends StatelessWidget {
  contacts({
    this.image,
    this.url,
    super.key,
  });
  String? image;
  String? url;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // launchUrl(Uri.parse("https://www.linkedin.com/in/alaa-nasser-4765a2266"));
        launch(url!);
        //launchUrl(Uri(scheme: url));
      },
      child: CircleAvatar(
        backgroundImage: AssetImage(image!),
      ),
    );
  }
}
