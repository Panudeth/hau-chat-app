import 'package:flutter/material.dart';
import 'package:new_flutter/pages/home.dart';
import 'package:new_flutter/pages/phoneRegister.dart';
import 'package:new_flutter/pages/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: HomePage(),
      title: 'Sanook',
      routes: {
        '/register': (context) => Register(),
        '/phoneregister': (context) =>PhoneRegister()
      },
    );
  }
}
