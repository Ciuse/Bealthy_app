import 'package:Bealthy_app/Models/date_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'calendarHomePage.dart';
import 'package:flutter/material.dart';
class HomePageWidget extends StatelessWidget {
  final Color color;
  final DateModel calendar_date= DateModel(date:DateTime.now());
  HomePageWidget(this.color);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(children: [
        CalendarHomePage(calendar_date: calendar_date),
        Observer(
            builder: (_) => Text(
                calendar_date.date.toString()+calendar_date.weekDay.toString()
            )
        ),]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.navigation),
        backgroundColor: color,
      ),
    );
  }
}