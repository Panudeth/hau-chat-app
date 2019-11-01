import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'friends.dart';

class CreateUser extends StatefulWidget {
  final FirebaseUser user;
  CreateUser(this.user, {Key key}) : super(key: key);

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController _displayName = TextEditingController();

  void updateUserDisplay() {
    firebaseAuth.currentUser().then((val) {
      UserUpdateInfo updateUser = UserUpdateInfo();
      updateUser.displayName = _displayName.text;
      val.updateProfile(updateUser).then((user) {
        print('success');
        getDisplayUser();
      }).catchError((e) {
        print(e.message);
      });
    });
  }

  void getDisplayUser() async {
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await firebaseAuth.currentUser();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => FriendsPage(firebaseUser)));
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
      ),
      body: Container(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _displayName,
                ),
                RaisedButton(
                  onPressed: () {
                    updateUserDisplay();
                  },
                  child: Text('Create User'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
