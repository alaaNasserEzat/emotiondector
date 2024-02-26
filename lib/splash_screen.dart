import 'package:emotion_detector/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      Navigator.push(context, MaterialPageRoute(builder:(context){
        return EmotionDetctor();
      }));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CircleAvatar(
        backgroundImage: AssetImage("assets/images/emotion.jpeg"),
        radius: 80,
      ),
      SizedBox(height: 20,),
      Text("Emotion Dectection",style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold,color: Colors.white),),
          SizedBox(height: 20,),
      CircularProgressIndicator(color: Colors.white,),
    ],
  ),
),
    );
  }
}