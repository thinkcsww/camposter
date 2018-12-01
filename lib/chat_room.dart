import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'model/chat_room_info.dart';

class ChatRoomPage extends StatefulWidget {
  final ChatRoomInfo chatRoomInfo;

  ChatRoomPage({Key key, @required this.chatRoomInfo}) : super(key: key);

  @override
  _ChatRoomPageState createState() =>
      _ChatRoomPageState(chatRoomInfo: chatRoomInfo);
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final ChatRoomInfo chatRoomInfo;
  final TextEditingController _messageTextController = TextEditingController();
  ScrollController _messageListViewScrollController = ScrollController();
  bool _isComposing = false;
  String userId, userName;
  int _targetMessageNum;

  _ChatRoomPageState({Key key, @required this.chatRoomInfo});

  @override
  void initState() {
    super.initState();
    _getCurrentUserId(context);
    print(chatRoomInfo.targetUserId);
    print(chatRoomInfo.posterName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          chatRoomInfo.posterName,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
        elevation: 1.0,
        actions: _buildAppbarActions(context),
      ),
      body: _buildBody(context),
    );
  }

  List<IconButton> _buildAppbarActions(BuildContext context) {
    List<IconButton> iconButtons = [
      IconButton(
        icon: Icon(
          Icons.search,
          semanticLabel: 'search',
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(
          Icons.delete,
          semanticLabel: 'delete',
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () async {
          QuerySnapshot querySnapshot = await Firestore.instance
              .collection('ChatRooms')
              .document(chatRoomInfo.roomId)
              .collection('Message')
              .getDocuments();
          List list = querySnapshot.documents;
          leaveAlertDialog(context, list);
        },
      )
    ];

    return iconButtons;
  }

  Future _leaveRoom(List messages) async {
    messages.forEach((snapshot) {
      Firestore.instance
          .collection('ChatRooms')
          .document(chatRoomInfo.roomId)
          .collection('Message')
          .document(snapshot.documentID)
          .delete();
    });
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: _buildStreamBuilderForListView(context),
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }


  void leaveAlertDialog(BuildContext context, List list) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('알림'),
            content: Text('정말 나가시겠습니까?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('예'),
                onPressed: () {
                  //메시지 지우고
                  _leaveRoom(list).then((done) {
                    //내 채팅방 지우고
                    Firestore.instance
                        .collection('Users')
                        .document(userId)
                        .collection('ChatList')
                        .document(chatRoomInfo.roomId)
                        .delete()
                        .then((done) {
                          // 상대방에게 방 없어졌다는 것을 알리
                      Firestore.instance
                          .collection('Users')
                          .document(chatRoomInfo.targetUserId)
                          .collection('ChatList')
                          .document(chatRoomInfo.roomId).updateData({
                        chatRoomInfo.roomId : false
                      })
                          .then((done) {
                        Navigator.pop(context);
                      });
                    });
                  });

                  Navigator.pop(context);
                  // 상대에게 있는 채팅방 정보 지우고

                  Navigator.pop(context);
                  // 나에게 있는 채팅방 정보 지우기
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

  Widget _buildStreamBuilderForListView(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('ChatRooms')
          .document(chatRoomInfo.roomId)
          .collection('Message')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        _targetMessageNum = 0;
        for (var message in snapshot.data.documents) {
          if (message['flag'] == 'false' && message['userId'] != userId) {
            message.reference.updateData({'flag': 'true'});
          } else if (message['flag'] == 'false' &&
              message['userId'] == userId) {
            _targetMessageNum++;
          }
        }

        print(chatRoomInfo.targetUserId);
        Firestore.instance
            .collection('Users')
            .document(userId)
            .collection('ChatList')
            .document(chatRoomInfo.roomId)
            .updateData({userId: '0'});
        Firestore.instance
            .collection('Users')
            .document(chatRoomInfo.targetUserId)
            .collection('ChatList')
            .document(chatRoomInfo.roomId)
            .updateData(
                {chatRoomInfo.targetUserId: _targetMessageNum.toString()});

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: ListView(
        controller: _messageListViewScrollController,
        children:
            snapshot.map((data) => _buildListItem(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _messageListViewScrollController
          .jumpTo(_messageListViewScrollController.position.maxScrollExtent);
    });
    //상대방 메시지
    final message = Message.fromSnapshot(data);

    if (userId != message.userId) {
      return Padding(
        key: ValueKey(message.messageId),
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 6.0, 10.0, 0.0),
                child: Image.network(
                  chatRoomInfo.imageURL,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.fill,
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //유저 이름
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            message.userName,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 메시지 내용
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            width: 170.0,
                            padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                            child: Text(
                              message.message,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                          Container(
                            height: 10.0,
                            padding: EdgeInsets.only(left: 4.0),
                            child: Text(
                              message.messageTime,
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.grey.shade600),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // 내 메시지
      return Padding(
        key: ValueKey(message.messageId),
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 10.0,
                    padding: EdgeInsets.only(right: 5.0),
                    child: Text(
                      message.messageTime,
                      style: TextStyle(
                          fontSize: 12.0, color: Colors.grey.shade600),
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.only(top: 10.0),
                      width: 170.0,
                      padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                      child: Text(
                        message.message,
                        style: TextStyle(color: Colors.grey.shade600),
                      )),
                ],
              ),
//              Padding(
//                padding: const EdgeInsets.only(left: 8.0),
//                child: CircleAvatar(
//                  child: Text(
//                    message.userName[0],
//                    style: TextStyle(color: Colors.white),
//                  ),
//                  backgroundColor: Theme.of(context).primaryColor,
//                ),
//              )
            ],
          ),
        ),
      );
    }
  }

  void _getCurrentUserId(BuildContext context) {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        userId = user.uid;
        userName = user.displayName;
      }
    });
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _messageTextController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a Message'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: _isComposing
                    ? Icon(Icons.directions_run)
                    : Icon(Icons.directions_walk),
                onPressed: _isComposing
                    ? () => _handleSubmitted(_messageTextController.text)
                    : null,
              ),
              decoration: null,
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _messageTextController.clear();
    setState(() {
      _isComposing = false;
    });

    var now = DateTime.now();
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    initializeDateFormatting('ko_KR');
    var formatter = DateFormat('a h:mm', 'ko');
    var formattedTime = formatter.format(now);
    Message message = new Message(
        message: text,
        messageTime: formattedTime,
        userName: userName,
        userId: userId,
        flag: 'false',
        messageId: timeStamp);
    Map<String, String> messageMap = {
      'message': message.message,
      'messageTime': message.messageTime,
      'messageId': message.messageId,
      'userId': message.userId,
      'userName': message.userName,
      'flag': message.flag,
    };

    //채팅방 안을 보여주기 위해 쓰는 것
    Firestore.instance
        .collection("ChatRooms")
        .document(chatRoomInfo.roomId)
        .collection("Message")
        .document(timeStamp)
        .setData(messageMap);

    //나의 채팅방 리스트에 보여주기 위해 쓰는 것
    Firestore.instance
        .collection('Users')
        .document(userId)
        .collection('ChatList')
        .document(chatRoomInfo.roomId)
        .updateData({
      'recentMessage': message.message,
      'recentMessageTime': message.messageTime,
    });

    //상대방 채팅방 리스트에 보여주기 위해 쓰는 것
    Firestore.instance
        .collection('Users')
        .document(chatRoomInfo.targetUserId)
        .collection('ChatList')
        .document(chatRoomInfo.roomId)
        .updateData({
      'recentMessage': message.message,
      'recentMessageTime': message.messageTime,
    });
  }
}
