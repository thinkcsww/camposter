import 'package:flutter/material.dart';

class SettingNoticePage extends StatefulWidget {
  @override
  _SettingNoticePageState createState() => _SettingNoticePageState();
}

class _SettingNoticePageState extends State<SettingNoticePage> {
  bool _isExpandedVersion = false;
  bool _isExpandedModify = false;
  bool _isExpandedBeta = false;

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
              "캠포스터 버전 1.0.0 오픈베타",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              "현재 사용하고 계신 캠포스터는 오픈베타 서비스 입니다.\n"
                  "더 편리한 기능으로 찾아뵙겠습니다. 감사합니다.",
              style: TextStyle(
                fontSize: 13.0,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
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
              "포스터게시 오류",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              "ios상 이미지 업로드 오류에 대해 개선 중 입니다.",
              style: TextStyle(
                fontSize: 13.0,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          isExpanded: _isExpandedModify,
        ),
      ],
    );

    Widget betaSection = ExpansionPanelList(
      expansionCallback: (int panelIndex, bool isExpanded) {
        setState(() {
          _isExpandedBeta = !isExpanded;
        });
      },
      children: <ExpansionPanel>[
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) => Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "[CAMPOSTER] 캠포스터 정식 런칭",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15.0,),
            ),
          ),
          body: Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              "서비스 준비중 입니다. \n"
                  "이용에 불편을 드려 죄송합니다.",
              style: TextStyle(
                fontSize: 13.0,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          isExpanded: _isExpandedBeta,
        ),
      ],
    );

    Widget _buildBody(BuildContext context) {
      return ListView(
        children: <Widget>[
          versionSection,

          modifySection,
          betaSection,
        ],
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
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }
}