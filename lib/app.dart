import 'package:flutter/material.dart';
import 'login.dart';
import 'bottom_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CamposterApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camposter',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: LoginPage(),
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => NavigatorPage()
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

