import 'package:flutter/material.dart';
import 'colors.dart';

class SettingPushPage extends StatefulWidget {
  @override
  _SettingPushPageState createState() => _SettingPushPageState();
}

class _SettingPushPageState extends State<SettingPushPage> {
  bool _isNewSwitch = false;
  bool _isChatSwitch = false;
  bool _isNoticeSwitch = false;
  bool _isLikeSwitch = false;

  void onChangedNew(bool value) {
    setState(() {
      _isNewSwitch = value;
    });
  }
  void onChangedChat(bool value) {
    setState(() {
      _isChatSwitch = value;
    });
  }
  void onChangedNotice(bool value) {
    setState(() {
      _isNoticeSwitch = value;
    });
  }
  void onChangedLike(bool value) {
    setState(() {
      _isLikeSwitch = value;
    });
  }

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
        '알림',
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
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      children: <Widget>[
        _buildTopDivider(),
        newSection(),
        _buildDivider(),
        chatSection(),
        _buildDivider(),
        noticeSection(),
        _buildDivider(),
        likeSection(),
        _buildDivider(),
      ],
    );
  }

  Widget newSection() {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "새로운 포스터 알림",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,
              ),
            ),
          ),
          Switch(
            value: _isNewSwitch, onChanged: (bool value) {
            onChangedNew(value);
          },
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget chatSection() {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "채팅 알림",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,
              ),
            ),
          ),
          Switch(
            value: _isChatSwitch, onChanged: (bool value) {
            onChangedChat(value);
          },
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget noticeSection() {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "공지 / 이벤트 알림",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,
              ),
            ),
          ),
          Switch(
            value: _isNoticeSwitch, onChanged: (bool value) {
            onChangedNotice(value);
          },
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget likeSection() {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "포스터 좋아요 알림",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,
              ),
            ),
          ),
          Switch(
            value: _isLikeSwitch, onChanged: (bool value) {
            onChangedLike(value);
          },
            activeColor: Theme.of(context).primaryColor,
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

  Widget _buildTopDivider() {
    return Divider(
      height: 1.0,
      indent: 0.0,
      color: Colors.grey[200],
    );
  }
}