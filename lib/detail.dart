import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'colors.dart';

class PosterDetailPage extends StatefulWidget {
  final poster;

  PosterDetailPage({Key key, this.poster}) : super(key: key);

  @override
  _PosterDetailPageState createState() =>
      _PosterDetailPageState(poster: this.poster);
}

class _PosterDetailPageState extends State<PosterDetailPage> {
  final poster;

  _PosterDetailPageState({Key key, this.poster});

  String userId = '';
  bool _isLiked = false;

  Future<void> getLiked(String userId) async {
    print('before');
    DocumentSnapshot value = await Firestore.instance
        .collection('Users')
        .document(userId)
        .collection('liked_list')
        .document(poster.posterId)
        .get();
    if (value.exists) {
      setState(() {
        _isLiked = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _getCurrentUserId(context).then((FirebaseUser user) {
      getLiked(user.uid);
    });
  }

  Future<FirebaseUser> _getCurrentUserId(BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userId = user.uid;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 70.0, left: 20.0, right: 20.0, bottom: 30.0),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
          ),
          elevation: 5.0,
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: new ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                      child: Hero(
                        tag: poster.posterName,
                        child: Image.network(
                          poster.imageURL,
                          height: 450.0,
                          width: 800.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            poster.posterName,
                            style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            poster.organizer,
                          ),
                          Row(
                            children: <Widget>[


                            ],
                          )
                        ],
                      ),
                    ),
                  )

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(icon: _isLiked? new Icon(Icons.star,color: CamPosterRed,): new Icon(Icons.star_border, color: CamPosterRed,), onPressed: (){
                    Firestore.instance.collection('Users').document(userId).collection('liked_list').document(poster.posterId).get().then((value){

                      if(value.exists){
                        Firestore.instance.collection('Users').document(userId).collection('liked_list').document(poster.posterId).delete();
                        setState(() {
                          _isLiked = false;
                        });

                      }

                      else if(!value.exists){
                        Firestore.instance.collection('Users').document(userId).collection('liked_list').document(poster.posterId).setData({
                          'posterName' : poster.posterName,
                          'imageURL'   : poster.imageURL,
                          'organizer'  : poster.organizer,
                          'posterId'   : poster.posterId,
                          'creatorId'  : poster.creatorId,
                        });
                        setState(() {
                          _isLiked = true;
                        });
                      }
                    });
                  } ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
