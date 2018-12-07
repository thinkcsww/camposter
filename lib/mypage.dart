import 'dart:async';
import 'package:camposter/constants.dart';
import 'package:camposter/edit_alarm_tag.dart';
import 'package:camposter/model/poster.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  SharedPreferences prefs;

  String userId = "";
  String userEmail = "";
  String userName = "";
  String userProfileImage = "";
  String schoolName = "";
  List<String> alarmTagList = [];
  double spinKitState = 0.0;

  @override
  void initState() {
    super.initState();
    _showSpinKit();
    _getCurrentUserId(context).then((FirebaseUser user) {
      _getAlarmTagsFromDB(user);
    });
    _getSchoolName();
  }

  void _getAlarmTagsFromDB(FirebaseUser user) {
    Firestore.instance
        .collection('Users')
        .document(user.uid)
        .collection('AlarmTags')
        .document('AlarmTags')
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        alarmTagList = snapshot.data.keys.toList();
      });
      _hideSpinKit();
    });
  }

  void _getSchoolName() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      schoolName = prefs.getString(SCHOOL_NAME);
    });
    print('debug get: $schoolName');
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
      elevation: 0.0,
      backgroundColor: CamPosterRed,
      leading: Container(),
      title: Text(
        "마이 페이지",
        style: TextStyle(
          color: CamPosterWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            })
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(children: [
          _buildTopContainer(),
          _buildBottomContainer(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 1000),
                        child: _buildMyPosterListView(context)),
                  ),
                ),
              ],
            ),
          )
        ]),
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

  Widget _buildTopContainer() {
    return Container(
      padding: const EdgeInsets.only(
          top: 20.0, left: 20.0, right: 20.0, bottom: 40.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        userProfileImage,
                      ),
                    ),
                    color: CamPosterBackgroundWhite,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, bottom: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          userName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          schoolName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      color: CamPosterRed,
    );
  }

  Widget _buildBottomContainer() {
    return Container(
      padding: const EdgeInsets.only(left: 30.0, right: 20.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '알림 태그',
                    style: TextStyle(
                        color: CamPosterRed200, fontWeight: FontWeight.bold),
                  ),
                ),
                InkWell(
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.grey, fontSize: 10.0),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditAlarmTagPage(
                                  alarmTagList: alarmTagList,
                                )));
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.0, left: 10.0, bottom: 0.0),
            child: Row(
              children: _buildAlarmTagChips(context, alarmTagList),
            ),
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '내 포스터',
                    style: TextStyle(
                        color: CamPosterRed200, fontWeight: FontWeight.bold),
                  ),
                ),
                InkWell(
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.grey, fontSize: 10.0),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/mypage_poster_iposted');
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Padding> _buildAlarmTagChips(
      BuildContext context, List<String> tagList) {
    List<Padding> tagChips = [];

    for (var i = 0; i < tagList.length; i++) {
      if (i == 4) break;
      tagChips.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Chip(
          backgroundColor: CamPosterRed300,
          label: Text(
            tagList[i],
            style: TextStyle(
                color: CamPosterWhite,
                fontWeight: FontWeight.bold,
                fontSize: 12.0),
          ),
        ),
      ));
    }

    return tagChips;
  }

  Widget _buildMyPosterListView(BuildContext context) {
    if (userId == "") {
      return LinearProgressIndicator();
    }
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Users')
          .document(userId)
          .collection('MyPosters')
          .limit(4)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        if (snapshot.data.documents.length == 0) return emptyCard;

        return ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: 180.0 * snapshot.data.documents.length),
            child: _buildMyPosterList(context, snapshot.data.documents));
      },
    );
  }

  Widget _buildMyPosterList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return Row(
      children:
          snapshot.map((data) => _buildMyPosterItem(context, data)).toList(),
    );
  }

  Widget _buildMyPosterItem(BuildContext context, DocumentSnapshot data) {
    Poster poster = Poster.forPosterIPosted(data);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      width: 170.0,
      height: 220.0,
      child: Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 10 / 13,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  poster.imageURL,
                  width: 800.0,
                  height: 300.0,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> _getCurrentUserId(BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userId = user.uid;
      userName = user.displayName;
      userProfileImage = user.photoUrl;
    });
    return user;
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

  Container emptyCard = Container(
    margin: const EdgeInsets.symmetric(horizontal: 20.0),
    width: 330.0,
    child: Stack(children: <Widget>[
      Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 15 / 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'images/posterdefault.png',
                  width: 800.0,
                  height: 300.0,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 180.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '게시된 포스터가 없습니다',
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      )
    ]),
  );
}
