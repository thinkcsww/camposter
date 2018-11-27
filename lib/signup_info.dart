import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpInfoPage extends StatefulWidget {
  @override
  _SignUpInfoPageState createState() => _SignUpInfoPageState();
}

class _SignUpInfoPageState extends State<SignUpInfoPage> {
  final TextEditingController _schoolNameTextFieldController =
      TextEditingController();
  String userId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }
  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 48.0),
      children: <Widget>[
        SizedBox(
          height: 50.0,
        ),
        Image.asset(
          'images/camposter.png',
          width: 50.0,
          height: 50.0,
        ),
        SizedBox(
          height: 75.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                '가입 세부 정보 입력',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        color: Theme.of(context).primaryColor, width: 5.0),
                    top:
                    BorderSide(color: Theme.of(context).primaryColor),
                    right: BorderSide(color: Theme.of(context).primaryColor),
                    bottom: BorderSide(color: Theme.of(context).primaryColor),
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: TextField(
                  autofocus: true,
                  controller: _schoolNameTextFieldController,
                  style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 15.0),
                  decoration: InputDecoration(
                    hintText: '학교를 입력해주세요. ex: 한동대학교',
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            )
          ],
        ),
        Container(
          child: Column(
            children: <Widget>[
              Container(
                width: 200.0,
                child: FlatButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      '시작하기',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _handleSubmitted(_schoolNameTextFieldController.text);
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0))),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _getCurrentUserId(BuildContext context) {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        userId = user.uid;
      }
    });
  }

  void _handleSubmitted(String schoolName) {
    if (schoolName != "") {
      Firestore.instance.collection('Users').document(userId).setData({
        'school': schoolName
      }).then((finish) {
        Fluttertoast.showToast(msg: '완료되었습니다.');
        Navigator.pushNamed(context, '/home');
      });
    } else {
      Fluttertoast.showToast(msg: '학교명을 입력해주세요.');
    }
  }
}