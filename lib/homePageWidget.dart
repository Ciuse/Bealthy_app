import 'package:Bealthy_app/Models/date_model.dart';
import 'package:Bealthy_app/Models/foodStore.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'addDisease.dart';
import 'calendarWidget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'addMeal.dart';
import 'listDishesOfDay.dart';


class HomePageWidget extends StatelessWidget {
  final Color color;
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
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AddMeal()),
                                      );
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    child: Icon(
                                      Icons.food_bank_outlined,
                                      size: 35.0,
                                    ),
                                    padding: EdgeInsets.all(15.0),
                                    shape: CircleBorder(),
                                  ),
                                  Text("Foods",style: TextStyle(
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
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AddDisease()),
                                      );
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.white,

                                    child: Icon(
                                      Icons.medical_services_outlined,
                                      size: 35.0,
                                    ),
                                    padding: EdgeInsets.all(15.0),
                                    shape: CircleBorder(),
                                  ),
                                  Text("Disease",style: TextStyle(
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
        child: Icon(Icons.navigation),
        backgroundColor: color,
      ),
    );
  }

}
