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

  List<String> dishListChoices = ["information","modify"];
  List<String> quantityList;
  @override
  void initState() {
    super.initState();
    quantityList= getQuantityName();
  }

  List<String> getQuantityName(){
    List<String> listToReturn = new List<String>();
    Quantity.values.forEach((element) {
      listToReturn.add(element.toString().split('.').last);
    });
    return listToReturn;
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
          leading: Icon(Icons.breakfast_dining),
          trailing: Row (
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add,color: Colors.green,size: 30,),
                  tooltip: 'Add new dish to Breakfast',
                  onPressed: () {
                    mealTimeStore.changeCurrentMealTime(index);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddMeal(title: MealTime.Breakfast.toString().split('.').last,)),
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
          leading: Icon(Icons.lunch_dining),
          trailing: Row (
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add,color: Colors.green,size: 30,),
                  tooltip: 'Add new dish to Lunch',
                  onPressed: () {
                    mealTimeStore.changeCurrentMealTime(index);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddMeal(title: MealTime.Lunch.toString().split('.').last,)),
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
          leading: Icon(Icons.fastfood_rounded),
          trailing: Row (
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add,color: Colors.green,size: 30,),
                  tooltip: 'Add new dish to Snack',
                  onPressed: () {
                    mealTimeStore.changeCurrentMealTime(index);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddMeal(title: MealTime.Snack.toString().split('.').last,)),
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
          leading: Icon(Icons.dinner_dining),
          trailing: Row (
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add,color: Colors.green,size: 30,),
                  tooltip: 'Add new dish to Dinner',
                  onPressed: () {
                    mealTimeStore.changeCurrentMealTime(index);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddMeal(title: MealTime.Dinner.toString().split('.').last,)),
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
  int getEnumIndex(String name){
    int i =0;
    int toReturn=0;
    MealTime.values.forEach((element) {
      if (element.toString().contains(name))
      {
        toReturn=i;
      }i++;
    }
    );
    return toReturn;
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
                    onTap: ()=> {
                    print(mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index]),
                      Navigator.push(
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
                          PopupMenuButton(
                              onSelected: (String choice) {
                                if(choice=="information"){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          DishPage(dish: mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index],

                                              createdByUser: mealTimeStore.isSubstring("User", mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].id),canBeAddToADay:false)));
                                }
                                if(choice=="modify"){
                                     return showDialog(
                                       context: context,
                                       builder: (_) =>  new AlertDialog(
                                           title: Center(child: Text("Modify the quantity of ${mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].name} to this day ")),
                                           content: Row(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             crossAxisAlignment: CrossAxisAlignment.center,
                                             children : <Widget>[
                                               Expanded(
                                                 child: Text(
                                                   "Indicate the quantity eaten! ",
                                                   textAlign: TextAlign.center,
                                                   style: TextStyle(
                                                     color: Colors.red,

                                                   ),
                                                 ),
                                               )
                                             ],
                                           ),
                                           actions: <Widget> [
                                             for(String qty in quantityList) RaisedButton(
                                                 onPressed:  () {
                                                   mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].qty = qty;
                                                   mealTimeStore.updateDishOfMealTimeListOfSpecificDay(mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index], widget.day)
                                                       .then((value) => Navigator.of(context).popUntil((route) => route.isFirst)
                                                   );
                                                 },
                                                 textColor: Colors.white,
                                                 padding: const EdgeInsets.all(0.0),
                                                 child: Container(
                                                   decoration: const BoxDecoration(
                                                     gradient: LinearGradient(
                                                       colors: <Color>[
                                                         Color(0xFF0D47A1),
                                                         Color(0xFF1976D2),
                                                         Color(0xFF42A5F5),
                                                       ],
                                                     ),
                                                   ),
                                                   padding: const EdgeInsets.all(10.0),
                                                   child: Text(qty , style: TextStyle(fontSize: 20)),)
                                             ),
                                           ]
                                       ),
                                     );
                                }
                              },
                              itemBuilder: (BuildContext context)
                              {
                                return dishListChoices.map((String choice) {
                                  return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice));
                                }).toList();
                              }
                          ),
                        ]),
                  ),

                ),
              onDismissed: (direction){
                mealTimeStore.removeDishOfMealTimeListOfSpecificDay(mealTime.index, mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index], widget.day)
                    .then((value) => Navigator.of(context).popUntil((route) => route.isFirst));
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

  void modify(){
    print("modify");
  }
}


