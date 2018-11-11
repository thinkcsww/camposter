import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecentMessage {


  final String recentMessage;
  final String recentMessageTime;
  final String circleName;
  final String imageURL;

  RecentMessage.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot['recentMessage'] != null),
        assert(snapshot['recentMessageTime'] != null),
        assert(snapshot['circleName'] != null),
        assert(snapshot['imageURL'] != null),
        recentMessage = snapshot['recentMessage'],
        recentMessageTime = snapshot['recentMessageTime'],
        imageURL = snapshot['imageURL'],
        circleName = snapshot['circleName'];

}