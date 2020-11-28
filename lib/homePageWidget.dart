import 'package:Bealthy_app/Models/date_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'calendarWidget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'addMeal.dart';
import 'addDishToADay.dart';


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
        FlatButton(
          onPressed: () {
            // Add your onPressed code here!
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => addDishToADay()),
            );
          },
          color: Colors.orange,
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.add),
              Text("Add dish")
            ],
          ),
        )


      ]),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMeal()),
          );
        },
        child: Icon(Icons.navigation),
        backgroundColor: color,
      ),
    );
  }
}




