import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  Map<String, dynamic> dataUser;
  Uint8List bytesImg;
//  List<DocumentSnapshot> dataUser;

  void initState() {
    super.initState();
    GetUserData();
  }

  Image imm;
  Future GetUserData() async {
    var document =
        await Firestore.instance.document('users/${widget.user.uid}');
    document.snapshots().listen((snapShotData) {
//      print(snapShotData.data);
      setState(() {
        dataUser = snapShotData.data;
        bytesImg = base64.decode(dataUser['imgAvatar']);
        imm = Image.memory(bytesImg);
        print(imm);
      });
    });
  }

  void signOut(BuildContext context) {
    firebaseAuth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Home')),
          leading: IconButton(icon: Icon(Icons.settings), onPressed: () {}),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add), onPressed: () {})
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        size: 15.0,
                      ),
                      hintText: 'Search',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(6.0)),
                ),
              ),
            ),
            ButtonTheme(
              child: RaisedButton(
                onPressed: () {},
                color: Colors.black45,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 28.0,
                      backgroundImage: MemoryImage(bytesImg),
//                      child: Text(
//                        widget.user.email.substring(0, 1).toUpperCase(),
//                        style: TextStyle(fontSize: 30.0),
//                      ),
                    ),
                    title: Text(
                      dataUser['displayName'],
                      style: TextStyle(fontSize: 20.0),
                    ),
                    subtitle: Text(
                      widget.user.email,
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            ButtonTheme(
              child: RaisedButton(
                onPressed: () {},
                color: Colors.black45,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
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
                  ),
                ),
              ),
            ),
            RaisedButton(child: Text('USER'), onPressed: () {}),
            RaisedButton(
                child: Text('LOGOUT'),
                onPressed: () {
                  signOut(context);
                }),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                title: Text('friend'),
                activeIcon: Icon(
                  Icons.people,
                  size: 45,
                )),
            BottomNavigationBarItem(
              backgroundColor: Colors.black87,
              icon: Icon(Icons.chat_bubble_outline),
              title: Text('chat room'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chrome_reader_mode),
              title: Text('timeline'),
            ),
          ],
          selectedItemColor: Colors.blue,
        ));
  }
}

Widget btnBar = BottomNavigationBar(items: [
  BottomNavigationBarItem(icon: Icon(Icons.people)),
  BottomNavigationBarItem(icon: Icon(Icons.people)),
  BottomNavigationBarItem(icon: Icon(Icons.people))
]);
