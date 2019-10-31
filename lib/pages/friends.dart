import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/pages/home.dart';

class FriendsPage extends StatefulWidget {
  final FirebaseUser user;
  FriendsPage(this.user, {Key key}) : super(key: key);

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
    print({'555': 555, "user": widget.user.email});
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Home')),
          leading: IconButton(icon: Icon(Icons.settings), onPressed: () {}),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add), onPressed: () {})
          ],
        ),
        body: Column(
          children: <Widget>[
            ButtonTheme(
              child: RaisedButton(
                onPressed: () {},
                color: Colors.black45,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 35,
                        child: Text(
                          widget.user.email.substring(0, 1).toUpperCase(),
                          style: TextStyle(fontSize: 30.0),
                        ),
                      ),
                      title: Text(
                        widget.user.email,
                        style: TextStyle(fontSize: 20.0),
                      ),
                      subtitle: Text(
                        widget.user.uid,
                      ),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              ),
            ),
            RaisedButton(
                child: Text('LOGOUT'),
                onPressed: () {
                  signOut(context);
                }),
          ],
        )
//      Column(
//        children: list
//            .map((item) => item != 'yyy' ? Text(item) : Container())
//            .toList(),
//      ),
        );
  }
}
