import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/pages/home.dart';

class PhoneRegister extends StatefulWidget {
  @override
  _PhoneRegisterState createState() => _PhoneRegisterState();
}

class _PhoneRegisterState extends State<PhoneRegister> {
  FirebaseAuth fireAuth = FirebaseAuth.instance;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  TextEditingController phoneController = TextEditingController();
  TextEditingController smsController = TextEditingController();

  String _verificationId;

  Future checkAuth(BuildContext context) async {
    FirebaseUser user = await fireAuth.currentUser();
    if (user != null) {
      print("Already singed-in with");
      Navigator.pushReplacementNamed(context, '/friend');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Phone Register", style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        body: Container(
            child: Center(
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                      colors: [Color(0xffE63950), Color(0xffEC5569)])),
              margin: EdgeInsets.all(32),
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(9),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.green[100]),
                        child: Text("+66",
                            style: TextStyle(
                                fontSize: 18, color: Colors.black54))),
                    Expanded(child: buildTextFieldPhoneNumber()),
                    buildButtonSendSms()
                  ]),
                  buildTextFieldSmsVerification(),
                  buildButtonVerify()
                ],
              )),
        )));
  }

  Widget buildButtonVerify() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ButtonTheme(
        minWidth: double.infinity,
        child: RaisedButton(
          child: Text(
            'VERIFY',
            style: TextStyle(color: Color(0xffEC5569)),
          ),
          onPressed: () {
            verifyPhone();
          },
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildButtonSendSms() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      child: ButtonTheme(
        child: RaisedButton(
          child: Text(
            'SEND',
            style: TextStyle(color: Color(0xffEC5569)),
          ),
          onPressed: () {
            requestVerifyCode();
          },
          color: Colors.white,
        ),
      ),
    );
  }

  Container buildTextFieldPhoneNumber() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: TextField(
            style: Theme.of(context).textTheme.title,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                hintText: 'xxx-xxx-xxxx',
                border: OutlineInputBorder(),
                isDense: true),
            controller: phoneController,
            keyboardType: TextInputType.numberWithOptions()),
      ),
    );
  }

  Container buildTextFieldSmsVerification() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: TextField(
            style: Theme.of(context).textTheme.title,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                hintText: 'sms verify',
                border: OutlineInputBorder(),
                isDense: true),
            controller: smsController,
            keyboardType: TextInputType.numberWithOptions()),
      ),
    );
  }

  requestVerifyCode() {
    print(phoneController.text);
    fireAuth.verifyPhoneNumber(
        phoneNumber: "+66" + phoneController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: (firebaseUser) {
          //
        },
        verificationFailed: (error) {
          print(
              'Phone number verification failed. Code: ${error.code}. Message: ${error.message}');
        },
        codeSent: (verificationId, [forceResendingToken]) {
          setState(() {
            _verificationId = verificationId;
          });
          print(verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          //
        });
  }

  verifyPhone() {
    fireAuth
        .signInWithCredential(PhoneAuthProvider.getCredential(
            verificationId: _verificationId, smsCode: smsController.text))
        .then((user) {
      print(' Success=> $user');
      checkAuth(context);
    }).catchError((error) {
      print(' Error=> $error');
    });
//    navigateToHomepage(context, user);
  }

//  verifyPhone() async {
//    FirebaseUser user = (await fireAuth.signInWithCredential(
//            PhoneAuthProvider.getCredential(
//                verificationId: _verificationId, smsCode: smsController.text)))
//        .user;
//    checkAuth(context);
////    navigateToHomepage(context, user);
//  }

//  void navigateToHomepage(BuildContext context, FirebaseUser user) {
//    Navigator.pushAndRemoveUntil(
//        context,
//        MaterialPageRoute(builder: (context) => HomePage(user)),
//        ModalRoute.withName('/'));
//    print(user);
//  }
}
