import 'package:camposter/setting_center.dart';
import 'package:camposter/setting_notice.dart';
import 'package:camposter/setting_person.dart';
import 'package:camposter/setting_push.dart';
import 'package:camposter/setting_service.dart';
import 'package:camposter/setting_version.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'bottom_navigator.dart';
import 'chat_room.dart';
import 'colors.dart';
import 'poster_creator_list.dart';
import 'signup_info.dart';
import 'mypage_poster_iposted.dart';
import 'add_poster.dart';
import 'setting.dart';
import 'edit_alarm_tag.dart';

class CamposterApp extends StatelessWidget {

  final primarySwatchColor = const Color(0xFFB52F28);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camposter',
      theme: _buildCamposterTheme(),
      home: LoginPage(),
//      initialRoute: '/login',
      onGenerateRoute: _getRoute,
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => NavigatorPage(),
        '/chat_room': (context) => ChatRoomPage(),
        '/poster_creator_list': (context) => PosterCreatorListPage(),
        '/sign_up_info' : (context) => SignUpInfoPage(),
        '/mypage_poster_iposted' : (context) => MyPagePosterIPostedPage(),
        '/add_poster' : (context) => AddPosterPage(),
        '/setting' : (context) => SettingPage(),
        '/navigator' : (context) => NavigatorPage(),
        '/notice': (context) => SettingNoticePage(),
        '/version': (context) => SettingVersionPage(),
        '/person': (context) => SettingPersonPage(),
        '/push': (context) => SettingPushPage(),
        '/service': (context) => SettingServicePage(),
        '/center': (context) => SettingCenterPage(),
        '/edit_tag' : (context) => EditAlarmTagPage(),

      },
    );
  }

  Route<dynamic> _getRoute(RouteSettings setting) {
    if (setting.name != 'login') { return null;}
    return MaterialPageRoute<void> (
      settings: setting,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}

ThemeData _buildCamposterTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: CamPosterRed,
    primaryColor: CamPosterRed,
    scaffoldBackgroundColor: CamPosterBackgroundWhite,
  );
}

