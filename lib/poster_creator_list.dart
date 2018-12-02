import 'dart:async';

import 'package:camposter/chat_room.dart';
import 'package:camposter/model/chat_room_info.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/poster.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PosterCreatorListPage extends StatefulWidget {
  @override
  _PosterCreatorListPageState createState() => _PosterCreatorListPageState();
}

class _PosterCreatorListPageState extends State<PosterCreatorListPage> {
  String userId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '포스터 담당자 리스트',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Posters')
          .where('auth', isEqualTo: true)
//          .where('creatorId', isLessThan: userId)
//          .where('creatorId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error, please try again');
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        children:
            snapshot.map((data) => _buildListItem(context, data)).toList());
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final poster = Poster.forCreatorList(data);

    final targetUserId = poster.creatorId;
    final imageURL = poster.imageURL;
    final posterName = poster.posterName;
    return Padding(
      key: ValueKey(data.documentID),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            posterName,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        leading: Image.network(
          poster.imageURL,
          width: 50.0,
          height: 50.0,
          fit: BoxFit.fill,
        ),
        onTap: () {
          final roomId = '$userId$targetUserId';
          final chatRoomInfo = ChatRoomInfo(
              roomId: roomId,
              imageURL: imageURL,
              targetUserId: targetUserId,
              posterName: posterName);
          _showAlertDialog(context, chatRoomInfo)
              .then((finish) => Navigator.pop(context));
        },
      ),
    );
  }

  Future<Null> _showAlertDialog(
      BuildContext context, ChatRoomInfo chatRoomInfo) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0.0),
            actions: <Widget>[
              FlatButton(
                child: Text('확인'),
                onPressed: () {
                  var now = DateTime.now();
                  initializeDateFormatting('ko_KR');
                  var formatter = DateFormat('a h:mm', 'ko');
                  var formattedTime = formatter.format(now);
                  Firestore.instance
                      .collection('Users')
                      .document(userId)
                      .collection('ChatList')
                      .document(chatRoomInfo.roomId)
                      .setData({
                    chatRoomInfo.targetUserId: '0',
                    userId: '0',
                    'posterName': chatRoomInfo.posterName,
                    'recentMessage': '새로운 대화가 생성되었습니다.',
                    'recentMessageTime': formattedTime,
                    'imageURL': chatRoomInfo.imageURL,
                    'roomId': chatRoomInfo.roomId,
                    chatRoomInfo.roomId: true
                  }).then((finish) {
                    Firestore.instance
                        .collection('Users')
                        .document(chatRoomInfo.targetUserId)
                        .collection('ChatList')
                        .document(chatRoomInfo.roomId)
                        .setData({
                      chatRoomInfo.targetUserId: '0',
                      userId: '0',
                      'posterName': chatRoomInfo.posterName,
                      'recentMessage': '새로운 대화가 생성되었습니다.',
                      'recentMessageTime': formattedTime,
                      'imageURL': chatRoomInfo.imageURL,
                      'roomId': chatRoomInfo.roomId,
                      chatRoomInfo.roomId: true
                    });

                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChatRoomPage(chatRoomInfo: chatRoomInfo)))
                        .then((finish) {
                      Fluttertoast.showToast(msg: '새로운 채팅 생성 완료');
                      Navigator.pop(context);
                    });
                  });
                },
              ),
              FlatButton(
                child: Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor),
                            child: Text(
                              '알림',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(22.0, 25.0, 8.0, 8.0),
                        child:
                            Text('${chatRoomInfo.posterName}님과 채팅을 시작하겠습니까?'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _getCurrentUserId(BuildContext context) {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        setState(() {
          userId = user.uid;
        });
        print(userId);
      }
    });
  }
}
