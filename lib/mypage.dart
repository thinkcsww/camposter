import 'package:camposter/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'colors.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String userId = "";
  String userEmail = "";
  String userName = "";

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
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: myPageBackground
            ),
            child: Column(
              children: <Widget>[
                _buildAppBar(context),
                _buildTopContainer(context),
              ],
            ),
          ),
          _buildBottomContainer(context),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40.0, left: 30.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "마이 페이지",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
//              _signOut();
            },
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Future <Null> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Widget _buildTopContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
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
                          'https://lh4.googleusercontent.com/proxy/Y1FiJAZaEMP3rEwGgYl0UbqSFJiHPA2NtBWa6Xh0nanjXqzKJD2KagdLX5D6WelXuVpBbDX2b5f7UIEivP06SfhANyt8gy0L5AGGC4pG4zvo_wVmYcPt3JCnAueqJfBwadgvm3GliCWsT9u1cuu-sPit1B31KD4=w592-h404-n-k-no-v1',
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        userName,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0, bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          userName,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '21300765',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          '기본정보변경',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: Text(
                          '내가 게시한 포스터',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/mypage_poster_iposted');
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left:30.0, right: 20.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                    ),
                  ),
                  child: Text(
                    "태그 수정",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 10.0),
            child: Row(
              children: <Widget>[
                Text(
                  '나의 태그',
                  style: TextStyle(
                      color: camposterRed200, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 140.0),
                  child: Text(
                    '알림 태그',
                    style: TextStyle(
                        color: camposterRed200, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 170.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 30.0,
                        child: Text(
                          '#나의 태그ㅇㅇㅇ',
                          style: TextStyle(
                              color: camposterRed, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 30.0,
                        child: Text(
                          '#나의 태그ㅇㅇㅇ',
                          style: TextStyle(
                              color: camposterRed, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 30.0,
                        child: Text(
                          '#나의 태그ㅇㅇㅇ',
                          style: TextStyle(
                              color: camposterRed, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 26.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 30.0,
                        child: Text(
                          '#나의 태그ㅇㅇㅇ',
                          style: TextStyle(
                              color: camposterRed, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 30.0,
                        child: Text(
                          '#나의 태그ㅇㅇㅇ',
                          style: TextStyle(
                              color: camposterRed, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 30.0,
                        child: Text(
                          '#나의 태그ㅇㅇㅇ',
                          style: TextStyle(
                              color: camposterRed, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _getCurrentUserId(BuildContext context) {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        setState(() {
          userId = user.uid;
          userName = user.displayName;
        });
      }
    });
  }
}
