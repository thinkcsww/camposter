import 'package:flutter/material.dart';
import 'colors.dart';

class SettingVersionPage extends StatefulWidget {
  @override
  _SettingVersionPageState createState() => _SettingVersionPageState();
}

class _SettingVersionPageState extends State<SettingVersionPage> {
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
        '버전정보',
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.keyboard_arrow_left,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          print('back');
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50.0),
            Container(
              constraints: BoxConstraints.expand(
                height: 200.0,
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/logo.png'),
                  )
              ),
            ),
            Text(
              "현재 버전  v1.0.0",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "최신 버전  v1.0.0",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 50.0),
            ButtonTheme(
              minWidth: 200.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              child: RaisedButton(
                elevation: 1.0,
                child: Text(
                  "최신 버전 입니다",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  print("업데이트");
                },
                color: Colors.grey[200],
              ),
            ),
            SizedBox(height: 100.0,),
            Text(
              "www.camposter.io",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        )
    );
  }
}