import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_picker/flutter_picker.dart';

class AddPosterPage extends StatefulWidget {
  String category;

  AddPosterPage({Key key, @required this.category}) : super(key: key);

  @override
  _AddPosterPageState createState() => _AddPosterPageState(category: category);
}

class _AddPosterPageState extends State<AddPosterPage> {
  final _posterNameController = TextEditingController();
  final _posterOrganizerController = TextEditingController();
  final _timeLocationController = TextEditingController();

  _AddPosterPageState({Key key, @required this.category});

  String category;
  String schoolName;
  String userId;
  File _imageFile;
  String imageURL;
  FirebaseStorage storage = FirebaseStorage.instance;
  double spinKitState = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId(context).then((FirebaseUser user) {
      _getSchoolNameFromDB(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add'),
        centerTitle: true,
        actions: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 70.0,
                child: FlatButton(
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    alertDialog(context);
                  },
                ),
              )
            ],
          )
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            _buildImageView(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 40.0),
                      child: GestureDetector(
                        onTap: () => showPickerDialog(context),
                        child: Text(
                  '#$category',
                  style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                          color: Theme.of(context).primaryColor),
                ),
                      ),
                    )),
                IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      imagePicker();
                    })
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        hintText: '포스터 제목',
                        hintStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ))),
                    controller: _posterNameController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: '게시자 : 단체명을 정확히 기입해주세요.',
                        hintStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor))),
                    controller: _posterOrganizerController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: '시간/장소',
                        hintStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor))),
                    controller: _timeLocationController,
                  ),
                ],
              ),
            )
          ],
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

  Future imagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  Widget _buildImageView() {
    if (_imageFile != null) {
      return Image.file(
        _imageFile,
        width: 800.0,
        height: 300.0,
        fit: BoxFit.fill,
      );
    } else {
      return Image.asset('images/posterdefault.png');
    }
  }

  Future<Null> _uploadFile(String uuid) async {
    StorageReference storageReference = storage.ref();
    final StorageReference imagesRef = storageReference.child('posters/$uuid');

    StorageUploadTask uploadTask = imagesRef.putFile(_imageFile);

    imageURL = await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  void _handleSubmitted(
      String name, String organizer, String timeLocation) {
    _showSpinKit();
    if (name.isNotEmpty &&
        organizer.isNotEmpty &&
        _imageFile != null) {
      String uuid = Uuid().v1();
      var now = DateTime.now();
      var formatter = DateFormat.yMd().add_jm();
      var formattedTime = formatter.format(now).toString();
      _uploadFile(uuid).then((f) {}).then((f) {
        Firestore.instance.collection('Posters').document(uuid).setData({
          'school': schoolName,
          'posterName': name,
          'organizer': organizer,
          'creatorId': userId,
          'created': formattedTime,
          'modified': formattedTime,
          'imageURL': imageURL,
          'imagePath': 'images/$uuid',
          'category': category,
          'auth': false,
        }).then((f) {
          Firestore.instance
              .collection('Users')
              .document(userId)
              .collection('MyPosters')
              .document(uuid)
              .setData({
            'posterName': name,
            'organizer': organizer,
            'imageURL': imageURL,
            'imagePath': 'images/$uuid',
            'category': category,
          }).then((f) {
            _hideSpinKit();
            Fluttertoast.showToast(msg: '업로드 완료');
            Navigator.pop(context);
          });
        });
      });
    } else {
      _hideSpinKit();
      Fluttertoast.showToast(msg: '빈칸을 채워주세요.');
    }
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
          setState(() {
            category = picker.getSelectedValues()[0];
          });
          print(picker.getSelectedValues());
          print(category);
        }).showDialog(context);
  }

  void alertDialog(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('알림'),
        content: Text('정말 등록하시겠습니까?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('예'),
            onPressed: () {
              _handleSubmitted(
                _posterNameController.text,
                _posterOrganizerController.text,
                _timeLocationController.text,
              );
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

  Future _getSchoolNameFromDB(FirebaseUser user) async {
    var result =
    await Firestore.instance.collection('Users').document(user.uid).get();
    setState(() {
      schoolName = result.data['school'];
      print(schoolName);
    });
  }

  Future<FirebaseUser> _getCurrentUserId(BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }


}
