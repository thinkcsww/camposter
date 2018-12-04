import 'dart:async';
import 'package:camposter/chat_room.dart';
import 'package:camposter/model/chat_room_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'colors.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:photo_view/photo_view.dart';

class PosterDetailPage extends StatefulWidget {
  final poster;

  PosterDetailPage({Key key, this.poster}) : super(key: key);

  @override
  _PosterDetailPageState createState() =>
      _PosterDetailPageState(poster: this.poster);
}

class _PosterDetailPageState extends State<PosterDetailPage> {
  final poster;

  _PosterDetailPageState({Key key, this.poster});

  String userId = '';
  bool _isLiked = false;

  Future<void> getLiked(String userId) async {
    print('before');
    DocumentSnapshot value = await Firestore.instance
        .collection('Users')
        .document(userId)
        .collection('liked_list')
        .document(poster.posterId)
        .get();
    if (value.exists) {
      setState(() {
        _isLiked = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _getCurrentUserId(context).then((FirebaseUser user) {
      getLiked(user.uid);
    });
  }

  Future<FirebaseUser> _getCurrentUserId(BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userId = user.uid;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: PhotoView.customChild(
        childSize: const Size(370.0, 550.0),
        backgroundDecoration: BoxDecoration(color: CamPosterBackgroundWhite),
        minScale: PhotoViewComputedScale.contained * 1.0,
        maxScale: PhotoViewComputedScale.covered * 2.0,
        initialScale: 1.0,
        customSize: MediaQuery.of(context).size,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            elevation: 5.0,
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: Hero(
                          tag: poster.posterName,
                          child: Image.network(
                            poster.imageURL,
                            height: 520.0,
                            width: 800.0,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        final targetUserId = poster.creatorId;
                        final imageURL = poster.imageURL;
                        final posterName = poster.posterName;
                        final roomId = '$userId$targetUserId';
                        final chatRoomInfo = ChatRoomInfo(
                            roomId: roomId,
                            imageURL: imageURL,
                            targetUserId: targetUserId,
                            posterName: posterName);
                        chatAlertDialog(context, chatRoomInfo);
                      },
                      icon: _isLiked? Icon(
                        Icons.chat_bubble,
                        size: 20.0,
                        color: CamPosterRed,
                      ): Icon(
                        Icons.chat_bubble_outline,
                        size: 20.0,
                        color: CamPosterRed,
                      ),
                    ),
                    IconButton(
                        icon: _isLiked
                            ? new Icon(
                                Icons.star,
                                color: CamPosterRed,
                              )
                            : new Icon(
                                Icons.star_border,
                                color: CamPosterRed,
                              ),
                        onPressed: () {
                          Firestore.instance
                              .collection('Users')
                              .document(userId)
                              .collection('liked_list')
                              .document(poster.posterId)
                              .get()
                              .then((value) {
                            if (value.exists) {
                              Firestore.instance
                                  .collection('Users')
                                  .document(userId)
                                  .collection('liked_list')
                                  .document(poster.posterId)
                                  .delete();
                              setState(() {
                                _isLiked = false;
                              });
                            } else if (!value.exists) {
                              Firestore.instance
                                  .collection('Users')
                                  .document(userId)
                                  .collection('liked_list')
                                  .document(poster.posterId)
                                  .setData({
                                'posterName': poster.posterName,
                                'imageURL': poster.imageURL,
                                'organizer': poster.organizer,
                                'posterId': poster.posterId,
                                'creatorId': poster.creatorId,
                              });
                              setState(() {
                                _isLiked = true;
                              });
                            }
                          });
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void chatAlertDialog(BuildContext context, ChatRoomInfo chatRoomInfo) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('알림'),
            content: Text('문의하시겠습니까?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('예'),
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
}
