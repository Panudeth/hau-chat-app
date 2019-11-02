import 'package:badges/badges.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
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
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => FriendsPage(firebaseUser)));
  }

  void signOut(BuildContext context) {
    firebaseAuth.signOut();
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
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
                      child: GestureDetector(
                          onTap: () {
                            print('555');
                          },
                          child: Badge(
                            badgeColor: Colors.black26,
                            position: BadgePosition.bottomRight(),
                            toAnimate: false,
                            badgeContent: Icon(Icons.camera_alt),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://image.shutterstock.com/image-vector/social-media-avatar-user-icon-260nw-1061793911.jpg'),
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
