import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'colors.dart';



class PosterDetailPage extends StatefulWidget {
  final poster;
  PosterDetailPage({Key key, this.poster}) : super(key: key);
  @override
  _PosterDetailPageState createState() => _PosterDetailPageState(poster: this.poster);
}



class _PosterDetailPageState extends State<PosterDetailPage> {
  final poster;
  _PosterDetailPageState({Key key, this.poster});
  final GlobalKey<ScaffoldState> _scaffoldKey = new
  GlobalKey<ScaffoldState>();
  String userId = '';

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if(user != null) {
        setState(() {
          userId = user.uid;
        });
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
//        appBar: AppBar(
//          centerTitle: true,
//          leading: IconButton(
//            icon: Icon(
//              Icons.arrow_back,
//              semanticLabel: 'back',
//            ),
//            onPressed: () => Navigator.pop(context),
//          ),
//          //title: Text('세부 정보'),
//        ),
      persistentFooterButtons:

      <Widget>[
        Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[200],
              width: 1.0,
            ),
          ),

          child: Row(
            children: <Widget>[
              SizedBox(width: 10.0,),
              new IconButton(icon: new Icon(Icons.chat), onPressed: null ),
              SizedBox(width: 40.0,),
              Builder(
                builder: (context) => (
                    IconButton(icon: new Icon(Icons.star,color: camposterRed,), onPressed: (){

                      Firestore.instance.collection('Users').document(userId).collection('liked_list').document(poster.posterId).setData({
                        'posterName' : poster.posterName,
                      });
                      final snackBar = SnackBar(content: Text('포스터가 리스트에 추가되었습니다!'));
                      Scaffold.of(context).showSnackBar(snackBar);




                    } )),
              ),
              SizedBox(width: 40.0,),
              new IconButton(icon: new Icon(Icons.share), onPressed:null),
              SizedBox(width: 10.0,),
            ],
          ),
        ),

        SizedBox(width: 40.0,),

      ],
      body: _buildBody(context),

    );

  }

  Widget _buildBody(BuildContext context) {
    return  ListView(
      children: [

        Image.network( poster.imageURL,
          fit: BoxFit.fill,
          height: 400.0,
          width: 600.0,
        ),

      ],

    );



  }


}