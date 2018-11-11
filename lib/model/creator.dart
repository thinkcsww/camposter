import 'package:cloud_firestore/cloud_firestore.dart';

class Creator{

  final String creatorId;
  final String imageURL;

  Creator.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot['creatorId'] != null),
        assert(snapshot['imageURL'] != null),
        creatorId = snapshot['creatorId'],
        imageURL = snapshot['imageURL'];
}