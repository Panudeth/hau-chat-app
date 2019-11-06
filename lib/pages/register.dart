import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'createUser.dart';
import 'friends.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  bool spinner = false;
  String username;
  String password;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void uploadValueToFirebase() async {
    setState(() {
      spinner = true;
    });
    username = _usernameController.text;
    password = _passwordController.text;
    print('user = $username | pass = $password');
    await firebaseAuth
        .createUserWithEmailAndPassword(email: username, password: password)
        .then((user) {
      signIn();
    }).catchError((final error) {
      setState(() {
        spinner = false;
      });
      print('Error => $error');
    });
  }

  void signIn() {
    firebaseAuth
        .signInWithEmailAndPassword(
            email: _usernameController.text, password: _passwordController.text)
        .then((user) {
      checkAuth(context);
    }).catchError((error) {
      setState(() {
        spinner = false;
      });
      print(' Error=> $error');
    });
  }

  Future checkAuth(BuildContext context) async {
    FirebaseUser user = await firebaseAuth.currentUser();
    if (user != null) {
      if (user.displayName != null && user.displayName != "") {
        setState(() {
          spinner = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => FriendsPage()));
      } else {
        setState(() {
          spinner = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CreateUser(user)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: !spinner
            ? Container(
                child: Center(
                  child: ListView(
//        mainAxisAlignment: MainAxisAlignment.center,
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: Image.asset(
                          'images/love.png',
                          height: 150,
                          width: 150,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 5),
                        child: TextField(
                          style: Theme.of(context).textTheme.title,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              isDense: true),
                          controller: _usernameController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 5, 50, 10),
                        child: TextField(
                          style: Theme.of(context).textTheme.title,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              isDense: true),
                          controller: _passwordController,
                          obscureText: true,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                            child: ButtonTheme(
                              minWidth: double.infinity,
                              child: RaisedButton(
                                child: Text('Register'),
                                color: Color(0xffEC5569),
                                onPressed: () {
                                  uploadValueToFirebase();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(child: Text('2019\u00a9 Panudeth Jaruwong'))
                    ],
                  ),
                ),
              )
            : Center(
                child: SpinKitPumpingHeart(
                  color: Colors.white,
                  size: 50.0,
                ),
              ));
  }
}
