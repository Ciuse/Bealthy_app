import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/ingredientStore.dart';
import 'package:Bealthy_app/Models/mealTimeStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'Database/enumerators.dart';

import 'Database/dish.dart';
import 'Models/foodStore.dart';

class DishPage extends StatefulWidget {

  final Dish dish;
  final bool createdByUser;
  final bool canBeAddToADay;
  DishPage({@required this.dish, @required this.createdByUser, @required this.canBeAddToADay});

  @override
  _DishPageState createState() => _DishPageState();
}

class _DishPageState extends State<DishPage>{
  var storage = FirebaseStorage.instance;
  final FirebaseFirestore fb = FirebaseFirestore.instance;

  List<String> quantityList;


  void initState() {
    super.initState();
    quantityList= getQuantityName();
    var store = Provider.of<IngredientStore>(context, listen: false);
    store.ingredientListOfDish.clear();
    if(widget.createdByUser){
      store.getIngredientsFromUserDish(widget.dish);
    }else{
      store.getIngredientsFromDatabaseDish(widget.dish);
    }
  }

  List<String> getQuantityName(){
    List<String> listToReturn = new List<String>();
    Quantity.values.forEach((element) {
      listToReturn.add(element.toString().split('.').last);
    });
    return listToReturn;
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

  Future getImage() async {
    try {
      return await storage.ref("DishImage/" + widget.dish.id + ".jpg").getDownloadURL();
    }
    catch (e) {
      return await Future.error(e);
    }
  }

  Future findIfLocal() {
     return rootBundle.load("images/"+widget.dish.id+".png");
  }

  void setQuantityAndMealTimeToDish(String qty){
    MealTimeStore mealTimeStore = Provider.of<MealTimeStore>(context, listen: false);
    widget.dish.mealTime = mealTimeStore.selectedMealTime.toString().split('.').last;
    widget.dish.qty = qty;
  }


  @override
  Widget build(BuildContext context) {
    FoodStore foodStore = Provider.of<FoodStore>(context);
    MealTimeStore mealTimeStore = Provider.of<MealTimeStore>(context);
    IngredientStore ingredientStore = Provider.of<IngredientStore>(context);
    DateStore dateStore = Provider.of<DateStore>(context);
    foodStore.isFoodFavourite(widget.dish);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dish.name),
        actions: <Widget>[
          Observer(builder: (_) =>IconButton(
              icon: Icon(
                widget.dish.isFavourite ? Icons.favorite : Icons.favorite_border,
                color: widget.dish.isFavourite ? Colors.pinkAccent : null,
              ),
              onPressed: () {
                if (widget.dish.isFavourite) {
                  foodStore.removeFavouriteDish(widget.dish);
                } else {
                  foodStore.addFavouriteDish(widget.dish);
                }
                // do something
              }
          ))
        ],
      ),
      body: Column(
    children: [Container(
          padding: EdgeInsets.all(10.0),
          child: FutureBuilder (
              future: findIfLocal(),
              builder: (context,  AsyncSnapshot localData) {
                if(localData.connectionState != ConnectionState.waiting ) {
                  if (localData.hasError) {
                    return FutureBuilder(
                        future: getImage(),
                        builder: (context, remoteString) {
                          if (remoteString.connectionState != ConnectionState.waiting) {
                            if (remoteString.hasError) {
                              return Text("Image not found");
                            }
                            else {
                              return Container(
                                width: 200,
                                height: 200,
                                child: ClipOval(
                                  child: Image.network(remoteString.data, fit: BoxFit.fill),),
                              );
                            }
                          }
                          else {
                            return CircularProgressIndicator();
                          }
                        }
                    );
                  }
                  else {
                    return Container(
                        width: 200,
                        height: 200,
                        child:  ClipOval(
                            child: Image(
                              image: AssetImage("images/" + widget.dish.id + ".png"),
                            )
                        ));
                  }
                } else{
                  return CircularProgressIndicator();
                }
              }
          )
    ),
      Expanded(
          child:
          Observer(builder: (_) =>new ListView.builder
            (
              itemCount: ingredientStore.ingredientListOfDish.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(ingredientStore.ingredientListOfDish[index].name),
                    subtitle: Text(ingredientStore.ingredientListOfDish[index].qty),
                    leading: FlutterLogo(),

                  ),
                );
              }
          ))
      ),

    ]

      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (widget.canBeAddToADay) {
              return showDialog(
                  context: context,
                  builder: (_) =>  new AlertDialog(
                    title: Center(child: Text("Add ${widget.dish.name} to this day ")),
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
                                  setQuantityAndMealTimeToDish(qty);
                                   mealTimeStore.addDishOfMealTimeListOfSpecificDay(widget.dish, dateStore.calendarSelectedDate)
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

            else {

              return showDialog(
                  context: context,
                  builder: (_) =>  new AlertDialog(
                    title: new Text(widget.dish.name),
                    content: new Text("Are you sure to remove it?"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Remove it!'),
                        onPressed: () {

                          mealTimeStore.removeDishOfMealTimeListOfSpecificDay(getEnumIndex(widget.dish.mealTime), widget.dish, dateStore.calendarSelectedDate)
                              .then((value) => Navigator.of(context).popUntil((route) => route.isFirst));

                        },
                      )
                    ],
                  ));
            }
          },
          child: Icon(widget.canBeAddToADay ? Icons.add : Icons.auto_delete,
              color: widget.canBeAddToADay ? Colors.white : Colors.white),
          backgroundColor: widget.canBeAddToADay ? Colors.green : Colors.redAccent
      ),

    );
  }
}
