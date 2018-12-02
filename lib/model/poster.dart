import 'package:cloud_firestore/cloud_firestore.dart';

class Poster{

  final String creatorId;
  final String imageURL;
  final String posterName;
  final String organizer;
  final String category;
  final String posterId;
  final String school;

  Poster.forSearchPosterList(DocumentSnapshot snapshot, { this.school, this.posterId, this.category, this.organizer, this.imageURL, this.creatorId})
      : assert(snapshot['posterName'] != null),
        posterName = snapshot['posterName'];

  Poster.forCreatorList(DocumentSnapshot snapshot, { this.school, this.posterId, this.category})
      : assert(snapshot['creatorId'] != null),
        assert(snapshot['imageURL'] != null),
        assert(snapshot['posterName'] != null),
        assert(snapshot['organizer'] != null),
        organizer = snapshot['organizer'],
        creatorId = snapshot['creatorId'],
        imageURL = snapshot['imageURL'],
        posterName = snapshot['posterName'];

  Poster.forDetailPoster(DocumentSnapshot snapshot, {this.school, this.category})
      : assert(snapshot['organizer'] != null),
        assert(snapshot['imageURL'] != null),
        assert(snapshot['posterName'] != null),
        assert(snapshot['creatorId'] != null),
        imageURL = snapshot['imageURL'],
        organizer = snapshot['organizer'],
        posterName = snapshot['posterName'],
        creatorId = snapshot['creatorId'],
        posterId = snapshot.documentID;

  Poster.forHomePosterList(DocumentSnapshot snapshot, {this.posterId})
      : assert(snapshot['creatorId'] != null),
        assert(snapshot['imageURL'] != null),
        assert(snapshot['posterName'] != null),
        assert(snapshot['organizer'] != null),
        assert(snapshot['school'] != null),
        assert(snapshot['category'] != null),
        creatorId = snapshot['creatorId'],
        school = snapshot['school'],
        imageURL = snapshot['imageURL'],
        organizer = snapshot['organizer'],
        category = snapshot['category'],
        posterName = snapshot['posterName'];

  Poster.forPosterIPosted(DocumentSnapshot snapshot, {this.school, this.posterId, this.category, this.creatorId})
      : assert(snapshot['organizer'] != null),
        assert(snapshot['imageURL'] != null),
        assert(snapshot['posterName'] != null),
        imageURL = snapshot['imageURL'],
        organizer = snapshot['organizer'],
        posterName = snapshot['posterName'];


}