import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/model/login.dart';
import 'package:new_flutter/pages/home.dart';

class FriendsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FriendsState();
  }
}

class _FriendsState extends State<FriendsPage> {
  List<String> list = ['xxx', 'yyy', 'zzz'];
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void signOut(BuildContext context) {
    firebaseAuth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments;
    print(user);
    return Scaffold(
        appBar: AppBar(
          title: Text('Friend'),
        ),
        body: RaisedButton(
            child: Text('OK'),
            onPressed: () {
              signOut(context);
            })
//      Column(
//        children: list
//            .map((item) => item != 'yyy' ? Text(item) : Container())
//            .toList(),
//      ),
        );
  }
}
