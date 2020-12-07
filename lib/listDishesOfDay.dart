import 'package:Bealthy_app/dishPageAddToDay.dart';
import 'package:flutter/material.dart';
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
    var store = Provider.of<FoodStore>(context, listen: false);
    store.initStore();
  }

  @override
  Widget build(BuildContext context) {
    final foodStore = Provider.of<FoodStore>(context);
    return Observer(builder: (_) => new Expanded(
      child:
      new ListView.builder
        (
          itemCount: foodStore.yourDishesDayList.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(foodStore.yourDishesDayList[index].name),
                background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),

              child: Card(
                child: ListTile(
                  onTap: ()=> { Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>
                      DishPageAddToDay(dish: foodStore.yourDishesDayList[index],
                          createdByUser: foodStore.isSubstring("User", foodStore.yourDishesDayList[index].id),canBeAddToADay:false)
                  ),
                  )
                  },
                  title: Text(foodStore.yourDishesDayList[index].name,style: TextStyle(fontSize: 22.0)),
                  subtitle: Text(foodStore.yourDishesDayList[index].category,style: TextStyle(fontSize: 18.0)),
                  leading: FlutterLogo(),
                  trailing: Row (
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        PopupMenuButton<String>(
                          onSelected: (String choice) {

                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    DishPageAddToDay(dish: foodStore.yourDishesDayList[index],
                                        createdByUser: foodStore.isSubstring("User", foodStore.yourDishesDayList[index].id),canBeAddToADay:false)));
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
                foodStore.removeDishFromUserDishesOfSpecificDay(foodStore.yourDishesDayList[index], widget.day);
              },
            );

          }
      ),


    ),);


  }
}

//check if s1 is a substring of s2



class ConstantsList  {

  static const String Informations = "informations";


  static const List<String> choices = <String>[
    Informations

  ];

}
