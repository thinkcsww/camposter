import 'package:flutter/material.dart';
import 'colors.dart';

class SettingPersonPage extends StatefulWidget {
  @override
  _SettingPersonPageState createState() => _SettingPersonPageState();
}

class _SettingPersonPageState extends State<SettingPersonPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
        '개인',
        style: TextStyle(
            color: Theme
                .of(context)
                .primaryColor,
            fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.keyboard_arrow_left,
          color: Theme
              .of(context)
              .primaryColor,
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
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "계정",
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left:15.0, bottom: 15.0),
          child: Text(
            "내 계정",
            style: TextStyle(
              fontSize: 15.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left:15.0, bottom: 15.0),
          child: Text(
            "21300013@handong.edu",
          ),
        ),
        _buildDivider(),
        SizedBox(height: 250.0),
        _buildDivider(),
        ListTile(
          title: Text(
            "로그아웃",
            style: TextStyle(
              fontSize: 15.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        _buildDivider(),
        SizedBox(height: 100.0),
        ListTile(
          title: Text(
            "회원탈퇴",
            style: TextStyle(
              fontSize: 15.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.0,
      indent: 0.0,
      color: Colors.grey,
    );
  }
}