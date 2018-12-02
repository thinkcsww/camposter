import 'package:flutter/material.dart';
import 'colors.dart';

class SettingNoticePage extends StatefulWidget {
  @override
  _SettingNoticePageState createState() => _SettingNoticePageState();
}

class _SettingNoticePageState extends State<SettingNoticePage> {
  bool _isExpandedVersion = false;
  bool _isExpandedModify = false;
  bool _isExpandedLearncher = false;

  @override
  Widget build(BuildContext context) {

    Widget versionSection = ExpansionPanelList(
      expansionCallback: (int panelIndex, bool isExpanded) {
        setState(() {
          _isExpandedVersion = !isExpanded;
        });
      },
      children: <ExpansionPanel>[
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) => Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "캠포스터 버전 1.0.1 업데이트",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,
              ),
            ),
          ),
          body: Container(
            child: Text("text"),
          ),
          isExpanded: _isExpandedVersion,
        ),
      ],
    );

    Widget modifySection = ExpansionPanelList(
      expansionCallback: (int panelIndex, bool isExpanded) {
        setState(() {
          _isExpandedModify = !isExpanded;
        });
      },
      children: <ExpansionPanel>[
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) => Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "포스터게시 오류 수정 공지사항",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,
              ),
            ),
          ),
          body: Container(
            child: Text("text"),
          ),
          isExpanded: _isExpandedModify,
        ),
      ],
    );

    Widget learncherSection = ExpansionPanelList(
      expansionCallback: (int panelIndex, bool isExpanded) {
        setState(() {
          _isExpandedLearncher = !isExpanded;
        });
      },
      children: <ExpansionPanel>[
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) => Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "[CAMPOSTER] 캠포스터 정식 런칭 !!",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,),
            ),
          ),
          body: Container(
            child: Text("text"),
          ),
          isExpanded: _isExpandedLearncher,
        ),
      ],
    );
    Widget _buildBody(BuildContext context) {
      return ListView(
        children: <Widget>[
          versionSection,
          modifySection,
          learncherSection,
        ],
      );
    }

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
        '공지사항',
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
}