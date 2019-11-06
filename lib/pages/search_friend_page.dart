import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class SearchFriend extends StatefulWidget {
  @override
  _SearchFriendState createState() => _SearchFriendState();
}

class _SearchFriendState extends State<SearchFriend> {
  TextEditingController _usernameController = TextEditingController();
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Uint8List bytesImg;
  String username = '';
  DocumentSnapshot dataUser;
  FirebaseUser userAuth;
  bool addFriend = false;
  bool hasFriend = false;
  bool firstSearch = false;

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
    }
  }

  getUserData() {
    _firestore
        .collection('users')
        .where("displayName", isEqualTo: _usernameController.text)
        .snapshots()
        .listen((data) => {
              if (data.documents.length == 0)
                {
                  setState(() {
                    hasFriend = false;
                    firstSearch = true;
                  })
                }
              else
                {
                  setState(() {
                    hasFriend = true;
                  })
                },
              data.documents.forEach((doc) {
                setState(() {
                  dataUser = doc;
                  username = doc["displayName"];
                  if (doc['imgAvatar'] != null && doc['imgAvatar'] != '') {
                    bytesImg = base64.decode(doc['imgAvatar']);
                  }
                });
                if (doc["displayName"] != null && doc["displayName"] != '') {
                  checkFriend();
                }
              })
            });
  }

  void checkFriend() {
    Map<String, dynamic> map = Map();
    map = dataUser.data;
    _firestore
        .collection('users')
        .document(userAuth.uid)
        .collection('friends')
        .document(map['uid'])
        .snapshots()
        .listen((data) {
      if (data.data != null) {
        setState(() {
          addFriend = true;
        });
      } else {
        setState(() {
          addFriend = false;
        });
      }
    });
  }

  Future upDAteFriend() async {
    Map<String, dynamic> map = Map();
    map = dataUser.data;
    await Firestore.instance
        .collection('users')
        .document(userAuth.uid)
        .collection('friends')
        .document(map['uid'])
        .setData(map)
        .then((res) => {
              Toast.show('Add Friend Success', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.TOP),
            })
        .catchError((error) {
      Toast.show(error.message, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    });
  }

  Future deleteFriend() async {
    Map<String, dynamic> map = Map();
    map = dataUser.data;
    await Firestore.instance
        .collection('users')
        .document(userAuth.uid)
        .collection('friends')
        .document(map['uid'])
        .delete()
        .then((res) => {
              setState(() {
                addFriend = false;
              }),
              Toast.show('Deleted', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.TOP),
            })
        .catchError((error) {
      Toast.show(error.message, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: TextField(
              decoration: InputDecoration(
                  hintText: 'Search ID',
                  isDense: true,
                  border: OutlineInputBorder(),
                  suffixIcon: ButtonTheme(
                    buttonColor: Color(0xff0000),
                    minWidth: 60.0,
                    child: RaisedButton(
                      onPressed: () {
                        getUserData();
                      },
                      child: Icon(Icons.search),
                    ),
                  )),
              textInputAction: TextInputAction.search,
              controller: _usernameController,
            )),
          ),
          hasFriend == true
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundImage: bytesImg != null
                            ? MemoryImage(bytesImg)
                            : NetworkImage(
                                'https://image.shutterstock.com/image-vector/social-media-avatar-user-icon-260nw-1061793911.jpg'),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          username,
                          style: TextStyle(fontSize: 20.0),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: ButtonTheme(
                          buttonColor: addFriend != true
                              ? Color(0xffEC5569)
                              : Colors.black26,
                          minWidth: 100.0,
                          child: RaisedButton(
                            onPressed: () {
                              addFriend != true
                                  ? upDAteFriend()
                                  : deleteFriend();
                            },
                            child: Text(addFriend != true
                                ? 'Add Friend'
                                : 'Delete Friend'),
                          ),
                        ))
                  ],
                )
              : Container(
                  child: firstSearch
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text('No Friend'),
                        ))
                      : Container(),
                )
        ],
      ),
    );
  }
}
