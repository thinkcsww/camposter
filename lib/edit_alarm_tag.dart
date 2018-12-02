import 'dart:async';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:camposter/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EditAlarmTagPage extends StatefulWidget {
  List<String> alarmTagList;

  EditAlarmTagPage({Key key, @required this.alarmTagList}) : super(key: key);

  @override
  _EditAlarmTagPageState createState() =>
      _EditAlarmTagPageState(alarmTagList: alarmTagList);
}

class _EditAlarmTagPageState extends State<EditAlarmTagPage> {
  List<String> alarmTagList;
  List<String> suggestionsFromDB = [];
  List<String> tagSuggestions = [];
  String queryTagName;
  double spinKitState = 0.0;
  GlobalKey<AutoCompleteTextFieldState<String>> autoTextTagFieldKey =
      new GlobalKey();

  String userId;
  String userName;

  _EditAlarmTagPageState({Key key, @required this.alarmTagList});

  @override
  void initState() {
    super.initState();
    _showSpinKit();
    _getCurrentUserId(context);
    _getTagSuggestionsFromDB().then((done) {
      _hideSpinKit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSearchBar(context),
              Text(
                '알림 태그',
                style: TextStyle(
                    color: CamPosterRed200, fontWeight: FontWeight.bold),
              ),
              Wrap(
                  alignment: WrapAlignment.start,
                  children: _buildAlarmTagChips(context, alarmTagList)),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: tagSuggestions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(tagSuggestions[index]),
                      onTap: () {
                        addAlertDialog(context, index);
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
        Opacity(
          opacity: spinKitState,
          child: SpinKitCircle(
            color: Theme.of(context).primaryColor,
            size: 50.0,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.grey.shade200),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Icon(
              Icons.search,
              color: Colors.grey,
              size: 18.0,
            ),
          ),
          Flexible(
            child: TextField(
              key: autoTextTagFieldKey,
              onChanged: (item) {
                queryTagName = item;
                tagSuggestions.clear();
                for (int i = 0; i < suggestionsFromDB.length; i++) {
                  if (suggestionsFromDB[i].startsWith(queryTagName) &&
                      queryTagName != "") {
                    print(queryTagName);
                    setState(() {
                      tagSuggestions.add(suggestionsFromDB[i]);
                    });
                    print(tagSuggestions);
                  }
                }
              },
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: '#태그 검색'),
            ),
          ),
        ],
      ),
    );
  }

  List<Padding> _buildAlarmTagChips(
      BuildContext context, List<String> tagList) {
    List<Padding> tagChips = [];
    if (tagList.length == 0) {
      tagChips.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('태그를 추가해주세요'),
      ));
      return tagChips;
    }

    for (var i = 0; i < tagList.length; i++) {
      tagChips.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ActionChip(
          onPressed: () {
            setState(() {
              deleteAlertDialog(context, i);
            });
          },
          backgroundColor: CamPosterRed300,
          label: Text(
            '#${tagList[i]}',
            style: TextStyle(
                color: CamPosterWhite,
                fontWeight: FontWeight.bold,
                fontSize: 12.0),
          ),
        ),
      ));
    }

    return tagChips;
  }

  void deleteAlertDialog(BuildContext context, int tagIndex) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('알림'),
            content: Text('정말 삭제하시겠습니까?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('예'),
                onPressed: () {
                  setState(() {
                    Firestore.instance
                        .collection('Users')
                        .document(userId)
                        .collection('AlarmTags')
                        .document('AlarmTags')
                        .updateData({
                      '${alarmTagList[tagIndex]}': FieldValue.delete(),
                    });
                    tagSuggestions.add(alarmTagList[tagIndex]);
                    alarmTagList.removeAt(tagIndex);
                  });
                  Navigator.pop(context);
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

  void addAlertDialog(BuildContext context, int tagIndex) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('알림'),
            content: Text('추가하시겠습니까?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('예'),
                onPressed: () {
                  setState(() {
                    Firestore.instance
                        .collection('Users')
                        .document(userId)
                        .collection('AlarmTags')
                        .document('AlarmTags')
                        .setData({
                      '${tagSuggestions[tagIndex]}': '${tagSuggestions[tagIndex]}',
                    }, merge: true);

                    alarmTagList.add(tagSuggestions[tagIndex]);
                    tagSuggestions.removeAt(tagIndex);
                  });
                  Navigator.pop(context);
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

  Future _getTagSuggestionsFromDB() async {
    await Firestore.instance
        .collection('Tags')
        .document('Tags')
        .get()
        .then((DocumentSnapshot snapshot) {
      var keys = snapshot.data.keys.toList();
      for (var i = 0; i < keys.length; i++) {
        suggestionsFromDB.add(keys[i]);
      }
    });
  }

  void _showSpinKit() {
    setState(() {
      spinKitState = 1.0;
    });
  }

  void _hideSpinKit() {
    setState(() {
      spinKitState = 0.0;
    });
  }

  Future<FirebaseUser> _getCurrentUserId(BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userId = user.uid;
      userName = user.displayName;
    });
    return user;
  }
}
//Text(
//'#나야나',
//style: TextStyle(
//color: CamPosterRed,
//fontWeight: FontWeight.bold,
//fontSize: 18.0),
//)
