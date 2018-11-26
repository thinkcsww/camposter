import 'package:camposter/model/poster.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  final buttonActiveColor = camposterRed;
  final buttonDeactiveColor = camposterRed200;
  bool categoryClicked = false;
  Color categoryButtonColor,
      categoryButtonBorderColor,
      popularButtonColor,
      popularButtonBorderColor;
  Widget currentBody;
  List<String> categoryList = ['#공모전', '#취업', '#신앙', '#동아리', '#학회', '#공연'];
  List<Color> categoryListColor = [camposterRed, camposterRed200, camposterRed200, camposterRed200, camposterRed200, camposterRed200];
  List<Color> categoryListBorderColor = [camposterRed, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];

  @override
  void initState() {
    super.initState();
    categoryButtonColor = buttonDeactiveColor;
    categoryButtonBorderColor = Colors.white;
    popularButtonColor = buttonActiveColor;
    popularButtonBorderColor = buttonActiveColor;
    currentBody = _buildPopularBody(context);

  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildAppBar(context),
        _buildButtonRow(context),
        currentBody,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: Theme.of(context).primaryColor))),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Icon(
                            Icons.search,
                            color: Theme.of(context).primaryColor,
                            size: 23.0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          controller: _searchController,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {},
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
                          color: popularButtonBorderColor, width: 3.0)
                  )
              ),
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
            _buildPopularHomeLeftView(context),
            _buildPopularPosterListView(context),
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
                      color: camposterRed,
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
                            bottom:
                                BorderSide(color: camposterRed200, width: 2.0))),
                    child: Text(
                      '모든 카테고리',
                      style: TextStyle(color: camposterRed200, fontSize: 16.0),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Text('나의 태그',
                      style: TextStyle(
                          color: camposterRed200,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('#리눅스해커스',
                      style: TextStyle(
                          color: camposterRed,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                  Text('#나의 태그',
                      style: TextStyle(
                          color: camposterRed,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularPosterListView(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Posters')
              .where('auth', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error, please try again');
            if (!snapshot.hasData) return LinearProgressIndicator();
            return _buildPopularList(context, snapshot.data.documents);
          },
        ),
      ),
    );
  }

  Widget _buildPopularList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
      height: 350.0,
      width: 300.0,
      child: ListView(
          scrollDirection: Axis.horizontal,
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
          print('hi');
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

  Widget _buildCategoryBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildCategoryHomeLeftView(context),
            _buildCategoryPosterListView(context),
          ],
        )
      ],
    );
  }

  List<Widget> _buildCategoryHomeLeftViewCategories(
      BuildContext context, List<String> categoryList, List<Color> categoryListColor) {
    List<Container> categories = [];
    for (var i = 0; i < categoryList.length; i++) {
      categories.add(
        Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          width: 100.0,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: categoryListBorderColor[i],
                width: 2.0
              )
            )
          ),
          child: GestureDetector(
            onTap: () {
              categoryToggle(i, categoryList.length);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(categoryList[i],
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
                      bottom: BorderSide(color: camposterRed200, width: 2.0))),
              child: Row(
                children: <Widget>[
                  Text(
                    '카테고리\n포스터',
                    style: TextStyle(
                        color: camposterRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildCategoryHomeLeftViewCategories(context, categoryList, categoryListColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPosterListView(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Posters')
              .where('auth', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error, please try again');
            if (!snapshot.hasData) return LinearProgressIndicator();
            return _buildCategoryList(context, snapshot.data.documents);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
      height: 350.0,
      width: 300.0,
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
          print('hi');
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
      });
    }
  }

  ///
  /// 카테고리 탭에서 좌측의 공모전, 취업 같은 카테고리를 눌렀을 때 해당하는 포스터를 볼 수 있게 토글해준다.
  ///
  void categoryToggle(int clickedCategory, int length) {
    setState(() {
      categoryListColor[clickedCategory] = camposterRed;
      categoryListBorderColor[clickedCategory] = camposterRed;
      for (var i = 0; i < length; i ++) {
        if (clickedCategory != i) {
          categoryListColor[i] = camposterRed200;
          categoryListBorderColor[i] = Colors.white;
        }
      }
      currentBody = _buildCategoryBody(context);
    });
  }


}
