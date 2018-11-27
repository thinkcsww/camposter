import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final buttonActiveColor = camposterRed;
  final buttonDeactiveColor = camposterRed200;
  Color buttonColor;

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
        '설정',
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
      child: ListView(
        children: <Widget>[
          ListTile(
//            contentPadding: 10.0,
            leading: Icon(
              Icons.speaker_notes,
              color: Theme.of(context).primaryColor,
              size: 30.0,
            ),
            title: Container(
              margin: EdgeInsets.all(15.0),
              child: Text('공지사항'),
            ),
          ),
          _buildDivider(),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Theme.of(context).primaryColor,
              size: 30.0,
            ),
            title: Container(
              margin: EdgeInsets.all(15.0),
              child: Text('버전정보'),
            ),
          ),
          _buildBoldDivider(),
          _buildDivider(),
          ListTile(
            leading: Icon(
              Icons.face,
              color: Theme.of(context).primaryColor,
              size: 30.0,
            ),
            title: Container(
              margin: EdgeInsets.all(15.0),
              child: Text('개인'),
            ),
          ),
          _buildDivider(),
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: Theme.of(context).primaryColor,
              size: 30.0,
            ),
            title: Container(
              margin: EdgeInsets.all(15.0),
              child: Text('알림'),
            ),
          ),
          _buildDivider(),
          SizedBox(height: 180.0,),
          _buildBoldDivider(),
          _buildDivider(),
          ListTile(
              leading: Icon(
                Icons.description,
                color: Theme.of(context).primaryColor,
                size: 30.0,
              ),
              title: Container(
                margin: EdgeInsets.all(15.0),
                child: Text('서비스 이용약관'),
              )
          ),
          _buildDivider(),
          ListTile(
            leading: Icon(
              Icons.help,
              color: Theme.of(context).primaryColor,
              size: 30.0,
            ),
            title: Container(
              margin: EdgeInsets.all(15.0),
              child: Text('고객센터'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.0,
      indent: 0.0,
      color: Colors.grey,
    );
  }

  Widget _buildBoldDivider() {
    return Container(
      height: 10.0,
      color: Colors.grey[300],
    );
  }
}