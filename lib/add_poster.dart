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

class AddPosterPage extends StatefulWidget {
  @override
  _AddPosterPageState createState() => _AddPosterPageState();
}

class _AddPosterPageState extends State<AddPosterPage> {
  final _posterNameController = TextEditingController();
  final _posterOrganizerController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _timeLocationController = TextEditingController();

  String userId;
  File _imageFile;
  String imageURL;
  FirebaseStorage storage = FirebaseStorage.instance;
  double spinKitState = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId(context);
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
                    _handleSubmitted(
                      _posterNameController.text,
                      _posterOrganizerController.text,
                      _productDescriptionController.text,
                      _timeLocationController.text,
                    );
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
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
                        hintStyle: TextStyle(color: Colors.blue),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.blue,
                        ))),
                    controller: _posterNameController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: '주최',
                        hintStyle: TextStyle(color: Colors.blue.shade100),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.blue,
                        ))),
                    controller: _posterOrganizerController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: '내용',
                        hintStyle: TextStyle(color: Colors.blue.shade100),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.blue,
                        ))),
                    controller: _productDescriptionController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: '시간/장소',
                        hintStyle: TextStyle(color: Colors.blue.shade100),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.blue,
                        ))),
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

  void _getCurrentUserId(BuildContext context) {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        setState(() {
          userId = user.uid;
        });
      }
    });
  }

  void _handleSubmitted(
      String name, String organizer, String description, String timeLocation) {
    _showSpinKit();
    if (name.isNotEmpty &&
        organizer.isNotEmpty &&
        description.isNotEmpty &&
        _imageFile != null) {
      String uuid = Uuid().v1();
      var now = DateTime.now();
      var formatter = DateFormat.yMd().add_jm();
      var formattedTime = formatter.format(now).toString();
      _uploadFile(uuid).then((f) {

      }).then((f) {
        Firestore.instance.collection('Posters').document(uuid).setData({
          'posterName': name,
          'organizer': organizer,
          'description': description,
          'creatorId': userId,
          'created': formattedTime,
          'modified': formattedTime,
          'imageURL': imageURL,
          'imagePath': 'images/$uuid',
          'auth' : false,
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
}
