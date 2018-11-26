import 'package:cloud_firestore/cloud_firestore.dart';

class Poster{

  final String creatorId;
  final String imageURL;
  final String posterName;
  final String organizer;
  final String category;

  Poster.forSearchPosterList(DocumentSnapshot snapshot, {this.category, this.organizer, this.imageURL, this.creatorId})
      : assert(snapshot['posterName'] != null),
        posterName = snapshot['posterName'];

  Poster.forCreatorList(DocumentSnapshot snapshot, {this.category, this.organizer})
      : assert(snapshot['creatorId'] != null),
        assert(snapshot['imageURL'] != null),
        assert(snapshot['posterName'] != null),
        creatorId = snapshot['creatorId'],
        imageURL = snapshot['imageURL'],
        posterName = snapshot['posterName'];

  Poster.forHomePosterList(DocumentSnapshot snapshot)
      : assert(snapshot['creatorId'] != null),
        assert(snapshot['imageURL'] != null),
        assert(snapshot['posterName'] != null),
        assert(snapshot['organizer'] != null),
        assert(snapshot['category'] != null),
        creatorId = snapshot['creatorId'],
        imageURL = snapshot['imageURL'],
        organizer = snapshot['organizer'],
        category = snapshot['category'],
        posterName = snapshot['posterName'];

  Poster.forPosterIPosted(DocumentSnapshot snapshot, {this.category, this.creatorId})
      : assert(snapshot['organizer'] != null),
        assert(snapshot['imageURL'] != null),
        assert(snapshot['posterName'] != null),
        imageURL = snapshot['imageURL'],
        organizer = snapshot['organizer'],
        posterName = snapshot['posterName'];


}