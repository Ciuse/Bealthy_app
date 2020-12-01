import 'package:Bealthy_app/Models/date_model.dart';
import 'package:Bealthy_app/Models/foodStore.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'calendarWidget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'addMeal.dart';
import 'ListDishesOfDay.dart';


class HomePageWidget extends StatelessWidget {
  final Color color;
  List<String> dishesOfDay = new List<String>();
  Future a;
  HomePageWidget(this.color);




  @override
  Widget build(BuildContext context) {
    final dateModel = Provider.of<DateModel>(context);
    return Scaffold(
      body: Column(children: [
        CalendarHomePage(),
        Observer(
            builder: (_) => ListDishesOfDay(day: dateModel.date.toString()),
        ),

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
