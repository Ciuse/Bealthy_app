import 'package:Bealthy_app/Models/mealTimeStore.dart';
import 'package:Bealthy_app/addMeal.dart';
import 'package:Bealthy_app/dishPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:flutter_mobx/flutter_mobx.dart';

import 'Database/enumerators.dart';


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
  }

  @override
  Widget build(BuildContext context) {
    final mealTimeStore = Provider.of<MealTimeStore>(context);
    return Expanded(
        child: ListView(
          children:<Widget>[
            for( var element in MealTime.values )
        Observer(builder: (_) => listViewForAMealTime(element, mealTimeStore))
          ],
        )
    );


  }

  dynamicListTile(int index){
    final mealTimeStore = Provider.of<MealTimeStore>(context);
    switch(index) {
      case 0: {
        return  ListTile(
          title: Text(MealTime.Breakfast.toString().split('.').last,style: TextStyle(fontSize:18,fontStyle: FontStyle.italic)),
          trailing: Row (
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.breakfast_dining),
                  tooltip: 'Add new dish to Breakfast',
                  onPressed: () {
                    mealTimeStore.changeCurrentMealTime(index);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddMeal()),
                    );
                  },
                ),
              ]),
        );
      }
      break;

      case 1: {
        return ListTile(
          title: Text(MealTime.Lunch.toString().split('.').last,style: TextStyle(fontSize:18,fontStyle: FontStyle.italic)),
          trailing: Row (
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.lunch_dining),
                  tooltip: 'Add new dish to Lunch',
                  onPressed: () {
                    mealTimeStore.changeCurrentMealTime(index);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddMeal()),
                    );
                  },
                ),
              ]),
        );
      }
      break;
      case 2: {
        return ListTile(
          title: Text(MealTime.Snack.toString().split('.').last,style: TextStyle(fontSize:18,fontStyle: FontStyle.italic)),
          trailing: Row (
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.fastfood_rounded),
                  tooltip: 'Add new dish to Snack',
                  onPressed: () {
                    mealTimeStore.changeCurrentMealTime(index);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddMeal()),
                    );
                  },
                ),
              ]),
        );
      }
      break;
      case 3: {
        return ListTile(
          title: Text(MealTime.Dinner.toString().split('.').last,style: TextStyle(fontSize:18,fontStyle: FontStyle.italic)),
          trailing: Row (
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.dinner_dining),
                  tooltip: 'Add new dish to Dinner',
                  onPressed: () {
                    mealTimeStore.changeCurrentMealTime(index);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddMeal()),
                    );
                  },
                ),
              ]),
        );
      }
      break;
      default: {
        print("No meal time found");
      }
      break;
    }
  }


  Widget listViewForAMealTime(MealTime mealTime, MealTimeStore mealTimeStore ){
    return Column(
        children:[
      dynamicListTile(mealTime.index), // per ogni meal time setto un testo e un'icona diversa
      ListView.builder(
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
                        DishPage(dish: mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index],
                            createdByUser: mealTimeStore.isSubstring("User", mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].id),canBeAddToADay:false)
                    ),
                    )
                    },
                    title: Text(mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].name,style: TextStyle(fontSize: 22.0)),
                    subtitle: Text(mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].category,style: TextStyle(fontSize: 18.0)),
                    leading: mealTimeStore.isSubstring("User", mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].id)? FlutterLogo():
                    Container(
                        width: 50,
                        height: 50,
                        child:  ClipOval(
                            child: Image(
                              image: AssetImage("images/" +mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].id+".png" ),
                            )
                        )),
                    trailing: Row (
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          PopupMenuButton<String>(
                            onSelected: (String choice) {

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      DishPage(dish: mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index],
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
                mealTimeStore.removeDishOfMealTimeListOfSpecificDay(mealTime.index,mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index], widget.day);
              },
            );

          }

      ),
      Divider(
        height: 2.5,
        thickness: 2.5,
        color: Colors.black87,
      )
    ]);

  }
}

//check if s1 is a substring of s2



class ConstantsList  {

  static const String Informations = "informations";


  static const List<String> choices = <String>[
    Informations

  ];

}
