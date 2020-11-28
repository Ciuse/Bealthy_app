import 'package:Bealthy_app/Models/date_model.dart';
import 'package:Bealthy_app/Models/foodStore.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'calendarWidget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'addMeal.dart';
import 'addDishToADay.dart';


class HomePageWidget extends StatelessWidget {
  final Color color;
  Future a;
  HomePageWidget(this.color);

  @override
  Widget build(BuildContext context) {
    final foodStore = Provider.of<FoodStore>(context);
    return Scaffold(
      body: Center (
          child: FutureBuilder(
              future: foodStore.getYourDishes(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  print("ENTRATO");
                  return CircularProgressIndicator();
                } else {
                  return Column(children: [
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
                            )]);
                }
              })
      ),



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
