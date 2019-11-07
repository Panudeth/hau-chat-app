import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/pages/home.dart';
import 'package:new_flutter/pages/search_friend_page.dart';

class FriendList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FriendListState();
  }
}

class _FriendListState extends State<FriendList> {
  FirebaseUser userAuth;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  Map<String, dynamic> dataUser;
  List friendData = [];
  Uint8List bytesImg;

  void initState() {
    super.initState();
    checkAuth(context);
  }

  Future checkAuth(BuildContext context) async {
    FirebaseUser user = await firebaseAuth.currentUser();
    if (user != null) {
      setState(() {
        userAuth = user;
      });
      getUserData();
      getFriends();
    }
  }

  Future getUserData() async {
    var document = Firestore.instance.document('users/${userAuth.uid}');
    document.snapshots().listen((snapShotData) {
      setState(() {
        dataUser = snapShotData.data;
        if (dataUser['imgAvatar'] != null && dataUser['imgAvatar'] != '') {
          bytesImg = base64.decode(dataUser['imgAvatar']);
        }
      });
    });
  }

  void getFriends() async {
    await _firestore
        .collection('users')
        .document(userAuth.uid)
        .collection('friends')
        .snapshots()
        .listen((data) {
      setState(() {
        friendData = [];
      });
      setState(() {
        data.documents.forEach((doc) {
          friendData.add(doc);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: friendData.length,
            itemBuilder: (context, index) {
              return ButtonTheme(
                child: RaisedButton(
                  onPressed: () {},
                  color: Colors.black45,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25.0,
                        backgroundImage: bytesImg != null
                            ? MemoryImage(
                                base64.decode(friendData[index]['imgAvatar']))
                            : NetworkImage(
                                'https://image.shutterstock.com/image-vector/social-media-avatar-user-icon-260nw-1061793911.jpg'),
                      ),
                      title: Text(
                        friendData[index]['displayName'],
                        style: TextStyle(fontSize: 16.0),
                      ),
                      subtitle: Text(friendData[index]['email']),
                    ),
                  ),
                ),
              );
            }),
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
