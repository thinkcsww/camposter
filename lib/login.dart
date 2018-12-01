import 'package:camposter/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferences prefs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  double spinKitState = 0.0;

  Future<FirebaseUser> _gSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    print('User name: ${user.displayName}');

    return user;
  }

  Future setUserId(FirebaseUser user) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_ID, user.uid);
    print('debug ${user.uid}');
  }

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        setUserId(user).then((done) {
          Navigator.popAndPushNamed(context, '/sign_up_info');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildBody(context)
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            Image.asset(
              'images/logo.png',
              width: 300.0,
              height: 150.0,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 100.0,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  FlatButton(
                      child: Image.asset(
                        "images/google.png",
                        fit: BoxFit.fill,
                      ),
                      onPressed: () {
                        _showSpinKit();
                        _gSignIn().then((FirebaseUser user) {}).then((f) {
                          _hideSpinKit();
                          Navigator.popAndPushNamed(context, '/sign_up_info');

                        });
                      }
                  ),
                  Opacity(
                    opacity: spinKitState,
                    child: SpinKitCircle(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),

      ],
    );
  }

  void _showSpinKit() {
    setState(() {
      spinKitState = 1.0;
    });
  }
  void _hideSpinKit() {
    setState(() {
      spinKitState = 0.0;
    });
  }
}
