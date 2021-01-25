import 'package:Bealthy_app/Models/mealTimeStore.dart';
import 'package:Bealthy_app/addMeal.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'Database/enumerators.dart';
import 'Login/config/palette.dart';
import 'eatenDishPage.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:Bealthy_app/Models/ingredientStore.dart';

class ListDishesOfDay extends StatefulWidget {
  final DateTime day;
  ListDishesOfDay({@required this.day});

  @override
  _ListDishesOfDayState createState() => _ListDishesOfDayState();
}

class _ListDishesOfDayState extends State<ListDishesOfDay>{

  List<String> dishListChoices = ["information","modify"];
  List<String> quantityList;
  var storage = FirebaseStorage.instance;
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
    final ingredientStore = Provider.of<IngredientStore>(context);
    return Container(
      padding: EdgeInsets.only(top: 8),
        child:Column(
          children:<Widget>[
            for( var element in MealTime.values )
              Observer(builder: (_) => Padding(
                  padding: EdgeInsets.only(left: 8,right: 8,bottom: 16),
                  child:listViewForAMealTime(element, mealTimeStore,ingredientStore))),

          ],

        ));


  }

  dynamicListTile(int index){
    final mealTimeStore = Provider.of<MealTimeStore>(context);
    switch(index) {
      case 0: {
        return ListTile(
          onTap: () {
            mealTimeStore.changeCurrentMealTime(index);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMeal(title: MealTime.Dinner.toString().split('.').last,)),
            );
          },
          title: Text(MealTime.Breakfast.toString().split('.').last,style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
          leading: Icon(Icons.breakfast_dining,color: Colors.black),
          trailing:
          IconButton(
            icon: Icon(Icons.add,color: Theme.of(context).accentColor,size: 30,),
            tooltip: 'Add new dish to Breakfast',
            onPressed: () {
              mealTimeStore.changeCurrentMealTime(index);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMeal(title: MealTime.Breakfast.toString().split('.').last,)),
              );
            },
          ),
        );
      }
      break;

      case 1: {
        return ListTile(
          onTap: () {
            mealTimeStore.changeCurrentMealTime(index);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMeal(title: MealTime.Dinner.toString().split('.').last,)),
            );
          },
          title: Text(MealTime.Lunch.toString().split('.').last,style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
          leading: Icon(Icons.lunch_dining,color: Colors.black),
          trailing:
          IconButton(
            icon: Icon(Icons.add,color: Theme.of(context).accentColor, size: 30,),
            tooltip: 'Add new dish to Lunch',
            onPressed: () {
              mealTimeStore.changeCurrentMealTime(index);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMeal(title: MealTime.Lunch.toString().split('.').last,)),
              );
            },
          ),
        );
      }
      break;
      break;
      case 2: {
        return ListTile(
          onTap: () {
            mealTimeStore.changeCurrentMealTime(index);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMeal(title: MealTime.Dinner.toString().split('.').last,)),
            );
          },
          title: Text(MealTime.Snack.toString().split('.').last,style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
          leading: Icon(Icons.fastfood_rounded,color: Colors.black),
          trailing:
          IconButton(
            icon: Icon(Icons.add,color: Theme.of(context).accentColor,size: 30,),
            tooltip: 'Add new dish to Snack',
            onPressed: () {
              mealTimeStore.changeCurrentMealTime(index);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMeal(title: MealTime.Snack.toString().split('.').last,)),
              );
            },
          ),
        );
      }
      break;
      case 3: {
        return ListTile(
          onTap: () {
            mealTimeStore.changeCurrentMealTime(index);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMeal(title: MealTime.Dinner.toString().split('.').last,)),
            );
          },
          title: Text(MealTime.Dinner.toString().split('.').last,style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
          leading: Icon(Icons.dinner_dining,color: Colors.black),
          trailing:
          IconButton(
            icon: Icon(Icons.add,color: Theme.of(context).accentColor,size: 30,),
            tooltip: 'Add new dish to Dinner',
            onPressed: () {
              mealTimeStore.changeCurrentMealTime(index);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMeal(title: MealTime.Dinner.toString().split('.').last,)),
              );
            },
          ),
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

  Future getImage(String dishId) async {
    String userUid;
    final litUser = context.getSignedInUser();
    litUser.when(
          (user) => userUid=user.uid,
      empty: () => Text('Not signed in'),
      initializing: () => Text('Loading'),
    );
    try {
      return await storage.ref(userUid+"/DishImage/" + dishId + ".jpg").getDownloadURL();
    }
    catch (e) {
      return await Future.error(e);
    }
  }

  Widget listViewForAMealTime(MealTime mealTime, MealTimeStore mealTimeStore,IngredientStore ingredientStore ){
    return  Card(
        elevation: 3,
        margin: EdgeInsets.all(0),
        child: Column(
            children:[
              dynamicListTile(mealTime.index), // per ogni meal time setto un testo e un'icona diversa
              ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: mealTimeStore.getDishesOfMealTimeList(mealTime.index).length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        padding:EdgeInsets.only(left: 16,right: 16, bottom: 16),
                        child:Dismissible(
                      key: Key(mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].name),
                      background: Container(

                        padding: EdgeInsets.symmetric(horizontal: 10, ),
                        decoration: BoxDecoration(
                          color: Palette.bealthyColorScheme.error,
                          borderRadius: BorderRadius.circular(5),),
                        alignment: AlignmentDirectional.centerEnd,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        margin: EdgeInsets.all(0),
                        shape:  RoundedRectangleBorder(
                          side: BorderSide(color: Palette.bealthyColorScheme.primaryVariant, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ) ,
                          onTap: ()  => {
                            Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>
                                EatenDishPage(dish: mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index],
                                    createdByUser: mealTimeStore.isSubstring("User", mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].id))
                            ),
                            )
                          },
                          title: Text(mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].name,style: TextStyle(fontSize: 18.0)),
                          leading: mealTimeStore.isSubstring("User", mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].id)?
                          FutureBuilder(
                              future: getImage(mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].id),
                              builder: (context, remoteString) {
                                if (remoteString.connectionState != ConnectionState.waiting) {
                                  if (remoteString.hasError) {
                                    return Text("Image not found");
                                  }
                                  else {
                                    return Observer(builder: (_) =>Container
                                      (width: 44,
                                        height: 44,
                                        decoration: new BoxDecoration(
                                          borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                                          border: new Border.all(
                                            color: Palette.bealthyColorScheme.primaryVariant,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: ClipOval(
                                            child: mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].imageFile==null? Image.network(remoteString.data, fit:BoxFit.cover)
                                                :Image.file(mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].imageFile, fit:BoxFit.cover)
                                        )));
                                  }
                                }
                                else {
                                  return CircularProgressIndicator();
                                }
                              }
                          )

                              :
                          Container
                            (width: 44,
                              height: 44,
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                                border: new Border.all(
                                  color: Palette.bealthyColorScheme.primaryVariant,
                                  width: 1.0,
                                ),
                              ),
                              child:  ClipOval(
                                  child: Image(
                                      image: AssetImage("images/Dishes/" +mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].id+".png" )
                                      , fit:BoxFit.cover
                                  )
                              )),
                          trailing: Icon( Icons.chevron_right),
                        ),

                      ),
                      onDismissed: (direction){
                        mealTimeStore.removeDishOfMealTimeListOfSpecificDay(mealTime.index, mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index], widget.day);
                      },
                    ));

                  }

              ),

            ]));

  }
}


