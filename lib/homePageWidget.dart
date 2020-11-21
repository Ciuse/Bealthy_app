import 'package:Bealthy_app/Models/date_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'calendarWidget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'createNewDishWidget.dart';


class HomePageWidget extends StatelessWidget {
  final Color color;

  HomePageWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        CalendarHomePage(),
        Observer(
            builder: (_) => Text(context.read<DateModel>().date.toString() +
                context.read<DateModel>().weekDay.toString())),

      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDishForm()),
          );
        },
        child: Icon(Icons.navigation),
        backgroundColor: color,
      ),
    );
  }
}




