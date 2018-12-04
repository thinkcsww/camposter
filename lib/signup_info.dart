import 'package:camposter/bottom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class SignUpInfoPage extends StatefulWidget {
  @override
  _SignUpInfoPageState createState() => _SignUpInfoPageState();
}

class _SignUpInfoPageState extends State<SignUpInfoPage> {
  final TextEditingController _schoolNameTextFieldController =
      TextEditingController();

  String userId;
  String schoolName;
  double spinKitState = 0.0;
  SharedPreferences prefs;

  void getSchoolName() async {
    prefs = await SharedPreferences.getInstance();
    var schoolName = prefs.getString(SCHOOL_NAME);
    print('debug get: $schoolName');
    if (schoolName != null && schoolName != "") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => NavigatorPage(
            schoolName: schoolName,
          )));
    }
  }

  void setSchoolName(String schoolName) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(SCHOOL_NAME, schoolName);
    print('debug $schoolName');
  }

  @override
  void initState() {
    super.initState();
    getSchoolName();
    _getCurrentUserId(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          padding: EdgeInsets.symmetric(horizontal: 48.0),
          children: <Widget>[
            SizedBox(
              height: 25.0,
            ),
            Image.asset(
              'images/logo.png',
              width: 300.0,
              height: 250.0,
            ),
            SizedBox(
              height: 25.0,
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
                    top: BorderSide(color: Theme.of(context).primaryColor),
                    right: BorderSide(color: Theme.of(context).primaryColor),
                    bottom: BorderSide(color: Theme.of(context).primaryColor),
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      autofocus: true,
                      controller: _schoolNameTextFieldController,
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                      decoration: InputDecoration(
                        hintText: '학교를 입력해주세요. ex: 한동대학교',
                        focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 50.0),
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
        ),
        Opacity(
          opacity: spinKitState,
          child: SpinKitCircle(
            color: Theme.of(context).primaryColor,
            size: 50.0,
          ),
        ),
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
    _showSpinKit();
    if (schoolName != "") {
      setSchoolName(schoolName);
      Firestore.instance
          .collection('Users')
          .document(userId)
          .setData({'school': schoolName}).then((finish) {
        _hideSpinKit();
        Fluttertoast.showToast(msg: '완료되었습니다.');
//        Navigator.pushAndRemoveUntil(
//            context,
//            MaterialPageRoute(
//                builder: (context) => NavigatorPage(
//                      schoolName: schoolName,
//                    )),
//            (Route r) =>  false);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => NavigatorPage(
                schoolName: schoolName,
              )));
//        Navigator.popAndPushNamed(context, '/screen4');
      });
    } else {
      _hideSpinKit();
      Fluttertoast.showToast(msg: '학교명을 입력해주세요.');
    }
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
