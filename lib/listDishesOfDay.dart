import 'package:Bealthy_app/Models/mealTimeStore.dart';
import 'package:Bealthy_app/dishPageAddToDay.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'Models/foodStore.dart';
import 'package:provider/provider.dart';
import 'package:Bealthy_app/dishPageAddToDay.dart';


import 'package:flutter_mobx/flutter_mobx.dart';


class ListDishesOfDay extends StatefulWidget {

  final DateTime day;
  ListDishesOfDay({@required this.day});


  @override
  _ListDishesOfDayState createState() => _ListDishesOfDayState();
}

class _ListDishesOfDayState extends State<ListDishesOfDay>{


  @override
  void initState() {

    super.initState();
    var storeMealTime = Provider.of<MealTimeStore>(context, listen: false);
    storeMealTime.initDishesOfMealTimeList(widget.day);

  }

  @override
  Widget build(BuildContext context) {

    final foodStore = Provider.of<FoodStore>(context);
    final mealTimeStore = Provider.of<MealTimeStore>(context);
    return Observer(builder: (_) => Expanded(
        child: ListView(
          children:<Widget>[
            for( var element in MealTime.values ) listViewForAMealTime(element, mealTimeStore)
          ],
        )
    ));


  }


  Widget listViewForAMealTime(MealTime mealTime, MealTimeStore mealTimeStore ){



    return ListView.builder
      (
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: mealTimeStore.getDishesOfMealTimeList(mealTime.index).length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].name),
            background: Container(
              alignment: AlignmentDirectional.centerEnd,
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white),
            ),

            child: Card(
              child: ListTile(
                onTap: ()=> { Navigator.push(
                  context, MaterialPageRoute(builder: (context) =>
                    DishPageAddToDay(dish: mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index],
                        createdByUser: mealTimeStore.isSubstring("User", mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].id),canBeAddToADay:false)
                ),
                )
                },
                title: Text(mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].name,style: TextStyle(fontSize: 22.0)),
                subtitle: Text(mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].category,style: TextStyle(fontSize: 18.0)),
                leading: FlutterLogo(),
                trailing: Row (
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      PopupMenuButton<String>(
                        onSelected: (String choice) {

                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  DishPageAddToDay(dish: mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index],
                                      createdByUser: mealTimeStore.isSubstring("User", mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].id),canBeAddToADay:false)));
                        },
                        itemBuilder: (BuildContext context){
                          return ConstantsList.choices.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),


                            );
                          }).toList();
                        },
                      ),
                    ]),
              ),
            ),
            onDismissed: (direction){
             // foodStore.removeDishFromUserDishesOfSpecificDay(list[index], widget.day);
            },
          );

        }
    );
  }
}

//check if s1 is a substring of s2



class ConstantsList  {

  static const String Informations = "informations";


  static const List<String> choices = <String>[
    Informations

  ];

}

