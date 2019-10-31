import 'package:flutter/material.dart';
import 'package:new_flutter/pages/home.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: HomePage(),
      image: Image.asset('images/love.png'),
      backgroundColor: Colors.black38,
      styleTextUnderTheLoader: TextStyle(color: Colors.deepPurple),
      photoSize: 100.0,
    );
  }
}
