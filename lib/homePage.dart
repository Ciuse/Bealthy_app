import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/mealTimeStore.dart';

import 'symptomsBar.dart';
import 'calendar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'addMeal.dart';
import 'listDishesOfDay.dart';


class HomePageWidget extends StatelessWidget {
  final Color color;
  HomePageWidget(this.color);

  @override
  Widget build(BuildContext context) {
    final mealTimeStore = Provider.of<MealTimeStore>(context);
    final dateModel = Provider.of<DateStore>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Bealthy', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: Column(children: [
        CalendarHomePage(),
        Divider(
          height: 2.5,
          thickness: 2.5,
          color: Colors.black87,
        ),
        SymptomsBar(day: dateModel.selectedDate),
        Divider(
          height: 2.5,
          thickness: 2.5,
          color: Colors.black87,
        ),
        ListDishesOfDay(day: dateModel.selectedDate),

      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierColor: Colors.white10.withOpacity(0.85), // background color
            barrierDismissible: false, // should dialog be dismissed when tapped outside
            child: SizedBox.expand( // makes widget fullscreen
                  child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  RawMaterialButton(

                                    onPressed: () {
                                      mealTimeStore.changeCurrentMealTime(0);
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AddMeal()),
                                      );
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    child: Icon(
                                      Icons.breakfast_dining,
                                      size: 35.0,
                                    ),
                                    padding: EdgeInsets.all(15.0),
                                    shape: CircleBorder(),
                                  ),
                                  Text("Breakfast",style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Open Sans',
                                    decoration: TextDecoration.none,
                                    letterSpacing: 1.0,
                                    wordSpacing: 5.0,
                                    color: Colors.black,
                                  ),)
                                ],
                              ),

                              Padding(padding: EdgeInsets.all(15)),

                              Column(
                                children: [
                                  RawMaterialButton(

                                    onPressed: () {
                                      mealTimeStore.changeCurrentMealTime(1);
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AddMeal()),
                                      );
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.white,

                                    child: Icon(
                                      Icons.lunch_dining,
                                      size: 35.0,
                                    ),
                                    padding: EdgeInsets.all(15.0),
                                    shape: CircleBorder(),
                                  ),
                                  Text("Lunch",style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Open Sans',
                                    decoration: TextDecoration.none,
                                    letterSpacing: 1.0,
                                    wordSpacing: 5.0,
                                    color: Colors.black,
                                  ),)
                                ],
                              )],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  RawMaterialButton(

                                    onPressed: () {
                                      mealTimeStore.changeCurrentMealTime(2);
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AddMeal()),
                                      );
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    child: Icon(
                                      Icons.fastfood_rounded,
                                      size: 35.0,
                                    ),
                                    padding: EdgeInsets.all(15.0),
                                    shape: CircleBorder(),
                                  ),
                                  Text("Snack",style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Open Sans',
                                    decoration: TextDecoration.none,
                                    letterSpacing: 1.0,
                                    wordSpacing: 5.0,
                                    color: Colors.black,
                                  ),)
                                ],
                              ),

                              Padding(padding: EdgeInsets.all(15)),

                              Column(
                                children: [
                                  RawMaterialButton(

                                    onPressed: () {
                                      mealTimeStore.changeCurrentMealTime(3);
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AddMeal()),
                                      );
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.white,

                                    child: Icon(
                                      Icons.dinner_dining,
                                      size: 35.0,
                                    ),
                                    padding: EdgeInsets.all(15.0),
                                    shape: CircleBorder(),
                                  ),
                                  Text("Dinner",style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Open Sans',
                                    decoration: TextDecoration.none,
                                    letterSpacing: 1.0,
                                    wordSpacing: 5.0,
                                    color: Colors.black,
                                  ),)
                                ],
                              )],
                          )
                        ],
                      )

                  )
                      )

          );
          // Add your onPressed code here!

        },
        child: Icon(Icons.add, color:Colors.white),
        backgroundColor: color,
      ),
    );
  }

}
