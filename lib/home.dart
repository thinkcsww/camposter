import 'package:flutter/material.dart';
import 'colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  final buttonActiveColor = camposterRed;
  final buttonDeactiveColor = campsterRed200;
  Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildAppBar(context),
        _buildBody(context),
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

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(36.0),
          child: Row(
            children: <Widget>[
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: camposterRed, width: 3.0))),
                  child: Text('인기있는',
                      style: TextStyle(
                          color: camposterRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                ),
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: FlatButton(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
//                  decoration: BoxDecoration(
//                      border: Border(
//                          bottom: BorderSide(
//                              color: camposterRed,
//                              width: 3.0
//                          )
//                      )
//                  ),
                    child: Text('카테고리',
                        style: TextStyle(
                            color: campsterRed200,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0)),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                                  bottom: BorderSide(
                                      color: campsterRed200, width: 2.0))),
                          child: Text(
                            '모든 카테고리',
                            style: TextStyle(
                                color: campsterRed200, fontSize: 16.0),
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
                                color: campsterRed200,
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
                                fontWeight: FontWeight.bold)
                        ),
                        Text('#나의 태그',
                            style: TextStyle(
                                color: camposterRed,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
//            ListView(
//              children: <Widget>[
//                Text('hi')
//              ],
//            )
          ],
        )
      ],
    );
  }
}
