import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/creator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

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
      stream: Firestore.instance.collection('Posters').where('auth', isEqualTo: true).snapshots(),
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
    final creator = Creator.fromSnapshot(data);

    final targetUserId = creator.creatorId;

    final circleName = data.documentID;
    return Padding(
      key: ValueKey(data.documentID),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            circleName,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        leading: Image.network(
          creator.imageURL,
          width: 50.0,
          height: 50.0,
          fit: BoxFit.fill,
        ),
        onTap: () {
          _showAlertDialog(context, circleName, targetUserId);
        },
      ),
    );
  }

  Future<Null> _showAlertDialog(BuildContext context, String circleName, String targetUserId) async {
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
                  Firestore.instance.collection('ChatRooms').document('${userId}${targetUserId}').setData({
                    'circleName': circleName,
                    'recentMessage': '새로운 대화가 생성되었습니다.',
                    'recentMessageTime': formattedTime,
                    'imageURL' : 'https://lh3.googleusercontent.com/proxy/SEwZekO1ysQi03SdMsOh2Ifc13Z45lUy9QamF4HHrnrlThWr0EG5IjTRCCDggA5lCcVE8CiLiVcqjtQd9V7nIq4SqFq_DRP44wulzlk7-8u7S2cur-jhjup7rHIKNNUFk3eeI2D2FWhvSKOg6BKWiZsrZiUgacc=w592-h404-n-k-no-v1'
                  });
                  Navigator.pop(context);
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
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
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
                        padding: const EdgeInsets.fromLTRB(22.0, 25.0, 8.0, 8.0),
                        child: Text('${circleName}님과 채팅을 시작하겠습니까?'),
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
        userId = user.uid;
        print(userId);
      }
    });
  }
}