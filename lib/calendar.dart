import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

class CalendarPage extends StatelessWidget {

  void handleNewDate(date) {
    print("handleNewDate ${date}");
  }

  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: new Text('캘린더',
          style: TextStyle(
              color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
      ),
      body: new Container(
        margin: new EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 10.0,
        ),
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            new Calendar(
              onSelectedRangeChange: (range) =>
                  print("Range is ${range.item1}, ${range.item2}"),
              isExpandable: true,
              onDateSelected: (date) => handleNewDate(date),
            ),
            new Divider(
              height: 50.0,
            ),

          ],
        ),
      ),
    );
  }
}