import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camposter',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> _gSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

    print('User name: ${user.displayName}');

    return user;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          SizedBox(height: 200.0,),
          Image.asset('images/logo.png',
            width: 100.0,
            height: 100.0,
          ),
          SizedBox(height: 300.0,),
          Container(
            child: Column(
              children: <Widget>[
                FlatButton(
                  child: Image.asset("images/google.png", fit: BoxFit.fill,),
                  onPressed: () =>_gSignIn().then((FirebaseUser user) => print(user)).catchError((e) => print(e)),
                ),
                FlatButton(
                  child: Image.asset("images/kakao.png", fit: BoxFit.cover),
                  onPressed: () {},
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
