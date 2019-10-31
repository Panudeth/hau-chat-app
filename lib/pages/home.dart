import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_flutter/pages/friends.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  String username;
  String password;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    checkAuth(context);
  }

  Future checkAuth(BuildContext context) async {
    FirebaseUser user = await firebaseAuth.currentUser();
    if (user != null) {
      print(user);
      print("Already singed-in with");
      Navigator.pushReplacementNamed(context, '/friend');
    }
  }

  void signIn() {
    firebaseAuth
        .signInWithEmailAndPassword(
            email: _usernameController.text, password: _passwordController.text)
        .then((user) {
      print(' Success=> $user');
      checkAuth(context);
    }).catchError((error) {
      print(' Error=> $error');
    });
  }

  Widget buildOtherLine() {
    return Container(
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: Row(children: <Widget>[
          Expanded(child: Divider(color: Color(0xffEC5569))),
          Padding(
              padding: EdgeInsets.all(6),
              child: Text("Don’t have an account?",
                  style: TextStyle(color: Color(0xffEC5569)))),
          Expanded(child: Divider(color: Color(0xffEC5569))),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
                      child: Text('Login'),
                      color: Color(0xffEC5569),
                      onPressed: () {
                        signIn();
                      },
                    ),
                  ),
                ),
                buildOtherLine(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: ButtonTheme(
                    minWidth: double.infinity,
                    child: RaisedButton(
                      child: Text('Register'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                        // Navigator.pushReplacementNamed(context, '/friend'); // with out back arrow
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => FriendsPage()));
                      },
                      color: Colors.black12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: ButtonTheme(
                    minWidth: double.infinity,
                    child: RaisedButton(
                      child: Text(
                        'Login With Mobile',
                        style: TextStyle(color: Color(0xffEC5569)),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/phoneregister');
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => FriendsPage()));
                      },
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Center(child: Text('2019\u00a9 Panudeth Jaruwong'))
          ],
        ),
      ),
    ));
  }
}
