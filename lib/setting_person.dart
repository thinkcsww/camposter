import 'dart:async';

import 'package:camposter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPersonPage extends StatefulWidget {
  @override
  _SettingPersonPageState createState() => _SettingPersonPageState();
}

class _SettingPersonPageState extends State<SettingPersonPage> {
  String userEmail = "";
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.4,
      backgroundColor: Colors.white,
      title: Text(
        '개인',
        style: TextStyle(
            color: Theme
                .of(context)
                .primaryColor,
            fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.keyboard_arrow_left,
          color: Theme
              .of(context)
              .primaryColor,
        ),
        onPressed: () {
          print('back');
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "계정",
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left:15.0, bottom: 15.0),
          child: Text(
            "내 계정",
            style: TextStyle(
              fontSize: 15.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left:15.0, bottom: 15.0),
          child: Text(
            userEmail,
          ),
        ),
        _buildDivider(),
        SizedBox(height: 250.0),
        _buildDivider(),
        ListTile(
          title: Text(
            "로그아웃",
            style: TextStyle(
              fontSize: 15.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onTap: () {
            _signOutAlertDialog(context);
          },
        ),
        _buildDivider(),
        SizedBox(height: 100.0),
        ListTile(
          title: Text(
            "회원탈퇴",
            style: TextStyle(
              fontSize: 15.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  void _signOutAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('알림'),
            content: Text('로그아웃 하시겠습니까??'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('예'),
                onPressed: () {
                  setSchoolName();
                  _signOut().then((done) {
                    GoogleSignIn _googleSignIn = GoogleSignIn();
                    _googleSignIn.signOut().then((done) {
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (Route r) => false);
                    });
                  });
                },
              ),
              CupertinoDialogAction(
                child: Text('아니오'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void setSchoolName() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(SCHOOL_NAME, "");
  }

  Future _signOut()  async{
    await FirebaseAuth.instance.signOut();
  }

  Future _getCurrentUserId(BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userEmail = user.email;
    });
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.0,
      indent: 0.0,
      color: Colors.grey,
    );
  }
}