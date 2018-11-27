import 'package:flutter/material.dart';
import 'chat_list.dart';
import 'like.dart';
import 'mypage.dart';
import 'calendar.dart';
import 'home.dart';

class NavigatorPage extends StatefulWidget {
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
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
    homePage = HomePage();
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
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("")),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text("")),
          BottomNavigationBarItem(icon: Icon(Icons.star), title: Text("")),
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text("")),
          BottomNavigationBarItem(
              icon: Icon(Icons.accessibility), title: Text("")),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
