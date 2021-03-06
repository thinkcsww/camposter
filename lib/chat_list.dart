import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart';
import 'model/recent_message.dart';
import 'chat_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/chat_room_info.dart';
import 'colors.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String userId = "", userName = "";

  @override
  void initState() {
    super.initState();
    _getCurrentUserId(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildAppBar(context),
        _buildBody(context),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(30.0, 50.0, 0.0, 20.0),
          child: Text(
            "채팅",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 28.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 50.0, 10.0, 20.0),
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/poster_creator_list');
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    if (userId == "") {
      return LinearProgressIndicator();
    }
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Users')
            .document(userId)
            .collection('ChatList')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          if (snapshot.data.documents.length == 0)
            return emptyListTile;
          return _buildList(context, snapshot.data.documents);
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final recentMessage = RecentMessage.fromSnapshot(data);
    final targetUserId = _getTargetUserId(recentMessage.roomId);
    final chatRoomInfo = ChatRoomInfo(
        roomId: recentMessage.roomId,
        imageURL: recentMessage.imageURL,
        targetUserId: targetUserId,
        posterName: recentMessage.posterName);
    if (data[recentMessage.roomId] == false) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              recentMessage.posterName,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
            child: Text('상대방이 퇴장하였습니다.'),
          ),
          leading: Image.network(
            recentMessage.imageURL,
            width: 50.0,
            height: 50.0,
            fit: BoxFit.fill,
          ),
          trailing: Column(
            children: <Widget>[
              Text(recentMessage.recentMessageTime),
              Padding(
                child: SizedBox(
                    height: 30.0,
                    child: BadgeIconButton(
                        itemCount: int.parse(data[userId]),
                        icon: Icon(
                          Icons.transit_enterexit,
                          color: Colors.transparent,
                        ))),
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              ),
            ],
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatRoomPage(

                        chatRoomInfo: chatRoomInfo,
                      ))),

        ),
      );
    }

    return Padding(
      key: ValueKey(recentMessage.posterName),
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            recentMessage.posterName,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
          child: Text(recentMessage.recentMessage),
        ),
        leading: Image.network(
          recentMessage.imageURL,
          width: 50.0,
          height: 50.0,
          fit: BoxFit.fill,
        ),
        trailing: Column(
          children: <Widget>[
            Text(recentMessage.recentMessageTime),
            Padding(
              child: SizedBox(
                  height: 30.0,
                  child: BadgeIconButton(
                      itemCount: int.parse(data[userId]),
                      icon: Icon(
                        Icons.transit_enterexit,
                        color: Colors.transparent,
                      ))),
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            ),
          ],
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatRoomPage(
                      chatRoomInfo: chatRoomInfo,
                    ))),
      ),
    );
  }

  var emptyListTile = Container(
    decoration:
    BoxDecoration(border: Border(top: BorderSide(width: 0.1))),
    child: Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            '진행중인 문의 채팅이 없습니다',
            style: TextStyle(
                color: CamPosterRed,
                fontWeight: FontWeight.bold),
          ),
        ),
        leading: Image.asset(
          'images/logo.png',
          width: 50.0,
          height: 50.0,
          fit: BoxFit.fill,
        ),
        trailing: Column(
          children: <Widget>[
            Text("00"),
            Padding(
              child: SizedBox(
                  height: 30.0,
                  child: BadgeIconButton(
                      itemCount: 0,
                      icon: Icon(
                        Icons.transit_enterexit,
                        color: Colors.transparent,
                      ))),
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            ),
          ],
        ),
      ),
    ),
  );

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

  String _getTargetUserId(String roomId) {
    if (userId == roomId.substring(0, 28)) {
      return roomId.substring(28);
    } else {
      return roomId.substring(0, 28);
    }
  }
}
