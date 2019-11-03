import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'friends.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateUser extends StatefulWidget {
  final FirebaseUser user;
  CreateUser(this.user, {Key key}) : super(key: key);

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  File fileImage;
  String base64Image;
  TextEditingController _displayName = TextEditingController();

  void updateUserDisplay() {
    firebaseAuth.currentUser().then((val) {
      UserUpdateInfo updateUser = UserUpdateInfo();
      updateUser.displayName = _displayName.text;
      val.updateProfile(updateUser).then((user) {
        UpdateUserData();
      }).catchError((e) {
        print(e.message);
      });
    });
  }

  Future UpdateUserData() async {
    Map<String, dynamic> map = Map();
    map['uid'] = widget.user.uid;
    map['email'] = widget.user.email;
    map['displayName'] = _displayName.text;
    map['imgAvatar'] = base64Image;

    await Firestore.instance
        .collection('users')
        .document(widget.user.uid)
        .setData(map)
        .then((res) => {getDisplayUser()});
  }

  void getDisplayUser() async {
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await firebaseAuth.currentUser();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => FriendsPage(firebaseUser)));
  }

  void signOut(BuildContext context) {
    firebaseAuth.signOut();
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera_alt),
                    title: new Text('Camera'),
                    onTap: () => {Navigator.pop(context), getImage()}),
                new ListTile(
                  leading: new Icon(Icons.folder_shared),
                  title: new Text('Gallery'),
                  onTap: () => {Navigator.pop(context), getImageGallery()},
                ),
              ],
            ),
          );
        });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    List<int> imageBytes = await image.readAsBytes();
    setState(() {
      fileImage = image;
      base64Image = base64Encode(imageBytes);
    });
  }

  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    List<int> imageBytes = await image.readAsBytes();
    setState(() {
      fileImage = image;
      base64Image = base64Encode(imageBytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
      ),
      body: Container(
        child: Center(
          child: Container(
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
                      child: GestureDetector(
                          onTap: () {
                            _settingModalBottomSheet(context);
                          },
                          child: fileImage == null
                              ? Badge(
                                  badgeColor: Colors.black26,
                                  position: BadgePosition.bottomRight(),
                                  toAnimate: false,
                                  badgeContent: Icon(Icons.camera_alt),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://image.shutterstock.com/image-vector/social-media-avatar-user-icon-260nw-1061793911.jpg'),
                                    radius: 50.0,
                                  ),
                                )
                              : Badge(
                                  badgeColor: Colors.black26,
                                  position: BadgePosition.bottomRight(),
                                  toAnimate: false,
                                  badgeContent: Icon(Icons.camera_alt),
                                  child: CircleAvatar(
                                    backgroundImage: FileImage(fileImage),
                                    radius: 50.0,
                                  ),
                                )),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
                  child: TextField(
                    style: Theme.of(context).textTheme.title,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        hintText: 'Display',
                        border: OutlineInputBorder(),
                        isDense: true),
                    controller: _displayName,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
                  child: RaisedButton(
                    onPressed: () {
                      updateUserDisplay();
                    },
                    child: Text('Create User'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
                  child: RaisedButton(
                    onPressed: () {
                      signOut(context);
                    },
                    child: Text('Log Out'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
