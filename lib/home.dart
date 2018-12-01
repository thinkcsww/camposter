import 'package:camposter/model/poster.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'colors.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'detail.dart';

class HomePage extends StatefulWidget {
  final schoolName;

  HomePage({Key key, @required this.schoolName}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(schoolName: schoolName);
}

class _HomePageState extends State<HomePage> {
  String schoolName;
  _HomePageState({Key key, @required this.schoolName});

  final buttonActiveColor = CamPosterRed;
  final buttonDeactiveColor = CamPosterRed200;
  GlobalKey<AutoCompleteTextFieldState<String>> autoTextTitleFieldKey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> autoTextTagFieldKey = new GlobalKey();
  bool categoryClicked = false;
  Color categoryButtonColor,
      categoryButtonBorderColor,
      popularButtonColor,
      popularButtonBorderColor;
  Widget currentBody;
  Widget currentAutoTextField;

  int posterNumber = 0;
  String currentSearchMethod = "제목";
  String queryPosterName, queryPosterCategory, queryTagName;
  String  userId = "", userName = "";
  List<String> categoryList = ['공모전', '취업', '신앙', '동아리', '학회', '공연'];
  List<String> searchMethodList = ['제목', '태그'];
  List<Color> categoryListColor = [
    CamPosterRed,
    CamPosterRed200,
    CamPosterRed200,
    CamPosterRed200,
    CamPosterRed200,
    CamPosterRed200
  ];
  List<Color> categoryListBorderColor = [
    CamPosterRed,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white
  ];
  List<String> titleSuggestions = [];
  List<String> tagSuggestions = [];

  List<String> myTags = [];
  double spinKitState = 0.0;

  @override
  void initState() {
    super.initState();
    print('debug $schoolName');
    _showSpinKit();
    queryPosterName = null;
    queryPosterCategory = null;
    categoryButtonColor = buttonDeactiveColor;
    categoryButtonBorderColor = Colors.white;
    popularButtonColor = buttonActiveColor;
    popularButtonBorderColor = buttonActiveColor;
    currentBody = _buildPopularBody(context);


    _getCurrentUserId(context).then((FirebaseUser user) {
        _getPosterListFromDB().then((done) {
          _getTagSuggestionsFromDB().then((done) {
            _hideSpinKit();
            setState(() {
              currentAutoTextField = _buildTitleAutoCompleteTextField(context);
            });
          });
        });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            _buildAppBar(context),
            _buildButtonRow(context),
            currentBody,
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      child: Row(
        children: <Widget>[
          Image.asset(
            'images/homelogo.png',
            height: 35.0,
          ),
          Flexible(
            child: Container(
              height: 50.0,
              margin: const EdgeInsets.only(left: 15.0),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        onTap: (){
                          _showPickerDialog(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      color: Theme.of(context).primaryColor))),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Text(
                              currentSearchMethod,
                              style: TextStyle(
                                fontSize: 16.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: currentAutoTextField,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.autorenew,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              setState(() {
                myTags.clear();
                currentBody = _buildPopularBody(context);
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: Row(
        children: <Widget>[
          FlatButton(
            child: Container(
              padding: const EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: popularButtonBorderColor, width: 3.0))),
              child: Text('인기있는',
                  style: TextStyle(
                      color: popularButtonColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            onPressed: () {
              popularButtonClicked();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FlatButton(
              child: Container(
                padding: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: categoryButtonBorderColor, width: 3.0))),
                child: Text('카테고리',
                    style: TextStyle(
                        color: categoryButtonColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0)),
              ),
              onPressed: () {
                categoryButtonClicked();
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPopularBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    _buildPopularHomeLeftView(context),
                    _buildPopularPosterListView(context),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildPopularHomeLeftView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Container(
        height: 300.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '인기있는\n포스터',
                  style: TextStyle(
                      color: CamPosterRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: CamPosterRed200, width: 2.0))),
                    child: Text(
                      '모든 카테고리',
                      style: TextStyle(color: CamPosterRed200, fontSize: 16.0),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Text('나의 학교',
                      style: TextStyle(
                          color: CamPosterRed200,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildMyTagList(myTags),
              ),
            ),
            Text('검색된 포스터 : $posterNumber', style: TextStyle(color: Colors.grey, fontSize: 12.0),),

          ],
        ),
      ),
    );
  }

  Widget _buildPopularPosterListView(BuildContext context) {
    if (currentSearchMethod == "제목") {
      return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Posters')
            .where('auth', isEqualTo: true)
            .where('school', isEqualTo: schoolName)
            .where('posterName', isEqualTo: queryPosterName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error, please try again');
          if (!snapshot.hasData) return LinearProgressIndicator();
          if (snapshot.data.documents.length == 0) return emptyCard;
          posterNumber = snapshot.data.documents.length;
          currentBody = _buildPopularBody(context);
          print(posterNumber);
          return _buildPopularList(context, snapshot.data.documents);
        },
      );
    } else {
      return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Posters')
            .where('auth', isEqualTo: true)
            .where('school', isEqualTo: schoolName)
            .where('tags', arrayContains: queryTagName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error, please try again');
          if (!snapshot.hasData) return LinearProgressIndicator();
          if (snapshot.data.documents.length == 0) return emptyCard;
          posterNumber = snapshot.data.documents.length;
          print(posterNumber);
          return _buildPopularList(context, snapshot.data.documents);
        },
      );
    }
  }

  Widget _buildPopularList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
      height: 350.0,
      width: snapshot.length * 300.0,
      child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          children: snapshot
              .map((data) => _buildPopularListItem(context, data))
              .toList()),
    );
  }

  Widget _buildPopularListItem(BuildContext context, DocumentSnapshot data) {
    final poster = Poster.forHomePosterList(data);

    return Container(
      width: 300.0,
      height: 370.0,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PosterDetailPage(
                    poster: Poster.forDetailPoster(data),
                  ),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 13 / 11,
                child: Hero(
                  tag: poster.posterName,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                    child: Image.network(
                      poster.imageURL,
                      width: 500.0,
                      height: 300.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.0, 20.0, 0.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        poster.posterName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        poster.organizer,
                      ),
                      Row(
                        children: <Widget>[],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    _buildCategoryHomeLeftView(context),
                    _buildCategoryPosterListView(context),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  List<Widget> _buildCategoryHomeLeftViewCategories(BuildContext context,
      List<String> categoryList, List<Color> categoryListColor) {
    List<Container> categories = [];
    for (var i = 0; i < categoryList.length; i++) {
      categories.add(
        Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          width: 100.0,
          decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(
                      color: categoryListBorderColor[i], width: 2.0))),
          child: GestureDetector(
            onTap: () {
              categoryToggle(i, categoryList.length);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('#${categoryList[i]}',
                    style: TextStyle(
                        color: categoryListColor[i],
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      );
    }

    return categories;
  }

  Widget _buildCategoryHomeLeftView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Container(
        height: 350.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 20.0),
              margin: const EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: CamPosterRed200, width: 2.0))),
              child: Row(
                children: <Widget>[
                  Text(
                    '카테고리\n포스터',
                    style: TextStyle(
                        color: CamPosterRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildCategoryHomeLeftViewCategories(
                  context, categoryList, categoryListColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPosterListView(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Posters')
            .where('auth', isEqualTo: true)
            .where('category', isEqualTo: queryPosterCategory)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error, please try again');
          if (!snapshot.hasData) return LinearProgressIndicator();
          if (snapshot.data.documents.length == 0) return emptyCard;
          return _buildCategoryList(context, snapshot.data.documents);
        },
      );
  }

  var emptyCard = Container(
    width: 300.0,
    height: 350.0,
    child: Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 13 / 11,
            child: Image.asset(
              'images/logo.png',
              width: 500.0,
              height: 300.0,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.0, 20.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '해당 카테고리에 게시된 포스터가 없습니다.',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: <Widget>[],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );

  Widget _buildCategoryList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
      height: 350.0,
      width: snapshot.length * 300.0,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: snapshot
              .map((data) => _buildCategoryListItem(context, data))
              .toList()),
    );
  }

  Widget _buildCategoryListItem(BuildContext context, DocumentSnapshot data) {
    final poster = Poster.forHomePosterList(data);
    return Container(
      width: 300.0,
      height: 370.0,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PosterDetailPage(
                poster: Poster.forDetailPoster(data),
              ),
            ),
          );
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 13 / 11,
                child: Image.network(
                  poster.imageURL,
                  width: 500.0,
                  height: 300.0,
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.0, 20.0, 0.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        poster.posterName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        poster.organizer,
                      ),
                      Row(
                        children: <Widget>[],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAutoCompleteTextField(BuildContext context) {
    return AutoCompleteTextField<String>(
      key: autoTextTitleFieldKey,
      submitOnSuggestionTap: true,
      suggestions: titleSuggestions,
      textChanged: (item) {
        queryPosterName = item;
      },
      itemSubmitted: (item) {
        setState(() {

          queryPosterName = item;
          currentBody = _buildPopularBody(context);
        });
      },
      textInputAction: TextInputAction.go,
      textSubmitted: (item) {
        setState(() {

          queryPosterName = item;
          currentBody = _buildPopularBody(context);
        });
      },
      itemBuilder: (context, item) {
        return new Padding(
            padding: EdgeInsets.all(8.0),
            child: new Text(
              item,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            ));
      },
      itemSorter: (a, b) {
        return a.compareTo(b);
      },
      itemFilter: (item, query) {
        return item
            .toLowerCase()
            .startsWith(query.toLowerCase());
      },
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildTagAutoCompleteTextField(BuildContext context) {
    return AutoCompleteTextField<String>(
      key: autoTextTagFieldKey,
      submitOnSuggestionTap: true,
      suggestions: tagSuggestions,
      textChanged: (item) {
        queryTagName = item;
      },
      itemSubmitted: (item) {
        setState(() {
          queryTagName = item;
          if (myTags.length == 0) {
            myTags.add(item);
          } else {
            myTags.removeAt(0);
            myTags.add(item);
          }
          currentBody = _buildPopularBody(context);
        });
      },
      textInputAction: TextInputAction.go,
      textSubmitted: (item) {
        setState(() {
          queryTagName = item;
          if (myTags.length == 0) {
            myTags.add(item);
          } else {
            myTags.removeAt(0);
            myTags.add(item);
          }
          currentBody = _buildPopularBody(context);
        });
      },
      itemBuilder: (context, item) {
        return new Padding(
            padding: EdgeInsets.all(8.0),
            child: new Text(
              item,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            ));
      },
      itemSorter: (a, b) {
        return a.compareTo(b);
      },
      itemFilter: (item, query) {
        return item
            .toLowerCase()
            .startsWith(query.toLowerCase());
      },
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
    );
  }

  ///
  /// 인기있는 탭을 눌렀을 때
  ///

  void popularButtonClicked() {
    categoryClicked = false;
    if (!categoryClicked) {
      setState(() {
        popularButtonColor = buttonActiveColor;
        popularButtonBorderColor = buttonActiveColor;
        categoryButtonColor = buttonDeactiveColor;
        categoryButtonBorderColor = Colors.white;
        currentBody = _buildPopularBody(context);
        queryPosterName = null;
      });
    }
  }

  ///
  /// 카테고리 탭 버튼을 눌렀을 때
  ///

  void categoryButtonClicked() {
    categoryClicked = true;
    if (categoryClicked) {
      setState(() {
        categoryButtonColor = buttonActiveColor;
        categoryButtonBorderColor = buttonActiveColor;
        popularButtonColor = buttonDeactiveColor;
        popularButtonBorderColor = Colors.white;
        currentBody = _buildCategoryBody(context);
        queryPosterName = null;
      });
    }
  }

  ///
  /// 카테고리 탭에서 좌측의 공모전, 취업 같은 카테고리를 눌렀을 때 해당하는 포스터를 볼 수 있게 토글해준다.
  ///
  void categoryToggle(int clickedCategory, int length) {
    setState(() {
      queryPosterCategory = categoryList[clickedCategory];
      categoryListColor[clickedCategory] = CamPosterRed;
      categoryListBorderColor[clickedCategory] = CamPosterRed;
      for (var i = 0; i < length; i++) {
        if (clickedCategory != i) {
          categoryListColor[i] = CamPosterRed200;
          categoryListBorderColor[i] = Colors.white;
        }
      }
      currentBody = _buildCategoryBody(context);
    });
  }

  ///
  /// 나의 태그 리스트 ex) 한동대학교 만들어줌
  ///

  List<Text> _buildMyTagList(List<String> myTagList) {
    List<Text> tagList = [
      Text('#$schoolName',
          style: TextStyle(
              color: CamPosterRed,
              fontSize: 16.0,
              fontWeight: FontWeight.bold)),
    ];
    for (var i = 1; i < myTagList.length + 1; i++) {
      tagList.add(Text('#${myTagList[i - 1]}',
          style: TextStyle(
              color: CamPosterRed,
              fontSize: 16.0,
              fontWeight: FontWeight.bold)));
    }
    return tagList;
  }

  ///
  /// Search에 보여줄 Suggestion을 위해 모든 포스터 리스트를 DB에서 받아온다.
  ///
  Future _getPosterListFromDB() async {
    await Firestore.instance
        .collection('Posters')
        .where('school', isEqualTo: schoolName)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      for (var i = 0; i < snapshot.documents.length; i++) {
        titleSuggestions.add(snapshot.documents[i].data['posterName']);
      }
    });
  }

  Future _getTagSuggestionsFromDB() async {
    await Firestore.instance
        .collection('Tags').document('Tags').get().then((DocumentSnapshot snapshot) {
      var keys = snapshot.data.keys.toList();
      for (var i = 0; i < keys.length; i++) {
        tagSuggestions.add(keys[i]);
      }
    });
  }


  Future<FirebaseUser> _getCurrentUserId(BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  _showPickerDialog(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: ['제목', '태그']),
        hideHeader: true,
        title: new Text(
          "검색 방법",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
        onConfirm: (Picker picker, List value) {
          setState(() {
            currentSearchMethod = picker.getSelectedValues()[0];
            if (currentSearchMethod == "태그") {

              currentAutoTextField = _buildTagAutoCompleteTextField(context);
            } else if (currentSearchMethod == "제목"){
              print(currentSearchMethod);
              currentAutoTextField = _buildTitleAutoCompleteTextField(context);
            }

          });

          print(picker.getSelectedValues());
        }).showDialog(context);
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
