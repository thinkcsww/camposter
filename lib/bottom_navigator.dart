import 'package:flutter/material.dart';
import 'chat_list.dart';
import 'like.dart';
import 'mypage.dart';
import 'calendar.dart';
import 'home.dart';

class NavigatorPage extends StatefulWidget {
  String schoolName;
  NavigatorPage({Key key, @required this.schoolName}) : super(key: key);
  @override
  _NavigatorPageState createState() => _NavigatorPageState(schoolName: schoolName);
}

class _NavigatorPageState extends State<NavigatorPage> {

  _NavigatorPageState({Key key, @required this.schoolName});

  String schoolName;
  int currentTab = 0;
  ChatPage chatPage;
  LikePage likePage;
  CalendarPage calendarPage;
  MyPage myPage;
  HomePage homePage;

  Widget currentPage;

  List<Widget> pages;
  List<String> pageTitles;

  @override
  void initState() {
    super.initState();

    chatPage = ChatPage();
    likePage = LikePage();
    homePage = HomePage(schoolName: schoolName,);
    myPage = MyPage();
    calendarPage = CalendarPage();

    pages = [homePage, calendarPage, likePage, chatPage, myPage];
    pageTitles = ["Home", "Calendar", "Like", "Chat", "MyPage"];
    currentPage = homePage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("홈", style: TextStyle(fontSize: 12.0))),
          BottomNavigationBarItem(
              icon: Icon(Icons.date_range), title: Text("캘린더", style: TextStyle(fontSize: 12.0))),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), title: Text("좋아요", style: TextStyle(fontSize: 12.0))),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), title: Text("문의", style: TextStyle(fontSize: 12.0))),
          BottomNavigationBarItem(
              icon: Icon(Icons.face), title: Text("내 정보", style: TextStyle(fontSize: 12.0))),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
