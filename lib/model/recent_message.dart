import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecentMessage {


  final String recentMessage;
  final String recentMessageTime;
  final String posterName;
  final String imageURL;
  final String roomId;

  RecentMessage.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot['recentMessage'] != null),
        assert(snapshot['recentMessageTime'] != null),
        assert(snapshot['posterName'] != null),
        assert(snapshot['imageURL'] != null),
        assert(snapshot['roomId'] != null),
        recentMessage = snapshot['recentMessage'],
        recentMessageTime = snapshot['recentMessageTime'],
        imageURL = snapshot['imageURL'],
        posterName = snapshot['posterName'],
        roomId = snapshot['roomId'];

}