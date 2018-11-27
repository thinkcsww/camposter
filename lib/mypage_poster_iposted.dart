import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/poster.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'add_poster.dart';

class MyPagePosterIPostedPage extends StatefulWidget {
  @override
  _MyPagePosterIPostedPageState createState() =>
      _MyPagePosterIPostedPageState();
}

class _MyPagePosterIPostedPageState extends State<MyPagePosterIPostedPage> {
  String userId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.4,
      backgroundColor: Colors.white,
      title: Text(
        '내가 게시한 포스터',
        style: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {},
        )
      ],
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildListView(context),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return Flexible(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .document(userId)
            .collection('MyPosters')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildGridList(context, snapshot.data.documents);
        },
      ),
    );
  }

  Widget _buildGridList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(16.0),
      childAspectRatio: 10.0 / 12.4,
      children: snapshot.map((data) => _buildGridItem(context, data)).toList(),
    );
  }

  Widget _buildGridItem(BuildContext context, DocumentSnapshot data) {
    Poster poster = Poster.forPosterIPosted(data);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 12 / 11,
            child: Image.network(
              poster.imageURL,
              width: 800.0,
              height: 300.0,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          poster.posterName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    poster.organizer,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      height: 75.0,
      child: Center(
        child: FlatButton(
            onPressed: () {},
            child: IconButton(
              icon: Icon(Icons.border_color),
              onPressed: () {
                showPickerDialog(context);
              },
              color: Theme.of(context).primaryColor,
            )),
      ),
    );
  }

  void _getCurrentUserId(BuildContext context) {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        setState(() {
          userId = user.uid;
        });
      }
    });
  }

  showPickerDialog(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: ['공모전', '취업', '신앙', '동아리', '학회', '공연']),
        hideHeader: true,
        title: new Text(
          "카테고리",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
        onConfirm: (Picker picker, List value) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPosterPage(category: picker.getSelectedValues()[0])));
          print(picker.getSelectedValues());
        }).showDialog(context);
  }
}
