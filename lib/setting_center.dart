import 'package:flutter/material.dart';
import 'colors.dart';

class SettingCenterPage extends StatefulWidget {
  @override
  _SettingCenterPageState createState() => _SettingCenterPageState();
}

class _SettingCenterPageState extends State<SettingCenterPage> {
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
        '고객센터',
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

    );
  }
}