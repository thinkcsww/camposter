import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Message {
  const Message({
    @required this.message,
    @required this.messageTime,
    @required this.userName,
    @required this.userId,
    @required this.messageId,
    @required this.flag,
  })  : assert(message != null),
        assert(messageId != null),
        assert(messageTime != null),
        assert(userName != null),
        assert(flag != null),
        assert(userId != null);

  final String message;
  final String messageTime;
  final String userName;
  final String userId;
  final String messageId;
  final String flag;

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot['message'] != null),
        assert(snapshot['messageTime'] != null),
        assert(snapshot['userName'] != null),
        assert(snapshot['userId'] != null),
        assert(snapshot['messageId'] != null),
        assert(snapshot['flag'] != null),
        flag = snapshot['flag'],
        message = snapshot['message'],
        messageTime = snapshot['messageTime'],
        userName = snapshot['userName'],
        userId = snapshot['userId'],
        messageId = snapshot['messageId'];

}
