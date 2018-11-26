import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart';
import 'model/recent_message.dart';
import 'chat_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/chat_room_info.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int _messageNum;
  String userId, userName;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
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
        ),
        _buildBody(context),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('ChatRooms').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
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
    final imageURL = recentMessage.imageURL;
    final roomId = recentMessage.roomId;
    final posterName = recentMessage.posterName;
    final targetUserId = _getTargetUserId(roomId);

    final chatRoomInfo = ChatRoomInfo(
        roomId: roomId, imageURL: imageURL, targetUserId: targetUserId, posterName: posterName);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messageNum = int.parse(data[userId]);
      });
    });
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
                      itemCount: _messageNum,
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

  void _getCurrentUserId(BuildContext context) {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        userId = user.uid;
        userName = user.displayName;
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
