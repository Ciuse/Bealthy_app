import 'package:Bealthy_app/Database/ingredient.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'Database/dish.dart';
import 'Database/enumerators.dart';
import 'Models/dateStore.dart';
import 'Models/foodStore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:Bealthy_app/dishPage.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';

import 'Models/ingredientStore.dart';
import 'Models/mealTimeStore.dart';

class SearchDishesList extends StatefulWidget {
  @override
  _SearchDishesListState createState() => _SearchDishesListState();
}

class _SearchDishesListState extends State<SearchDishesList>{


  TextEditingController _searchController = TextEditingController();
  var storage = FirebaseStorage.instance;
  FoodStore foodStore;
  IngredientStore ingredientStore;
  MealTimeStore mealTimeStore;
  List<String> quantityList;
  DateStore dateStore;

  @override
  void initState() {
    super.initState();
    ingredientStore = Provider.of<IngredientStore>(context, listen: false);
    mealTimeStore = Provider.of<MealTimeStore>(context, listen: false);
    dateStore = Provider.of<DateStore>(context, listen: false);
    quantityList= getQuantityName();
    _searchController.addListener(_onSearchChanged);
    foodStore = Provider.of<FoodStore>(context, listen: false);
    foodStore.initSearchAllDishList(ingredientStore);
    foodStore.resultsList.clear();
    _onSearchChanged();
    

  }

  List<String> getQuantityName(){
    List<String> listToReturn = new List<String>();
    Quantity.values.forEach((element) {
      listToReturn.add(element.toString().split('.').last);
    });
    return listToReturn;
  }

  Future<void> initializeIngredients(Dish dish)async {
      ingredientStore.ingredientListOfDish.clear();
      if(foodStore.isSubstring("User", dish.id)){
        await ingredientStore.getIngredientsFromUserDish(dish);
      }else{
        await ingredientStore.getIngredientsFromDatabaseDish(dish);
      }
      ingredientStore.mapIngredientDish.putIfAbsent(dish, () => ingredientStore.ingredientListOfDish);
  }

  @override
  void dispose(){
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  _onSearchChanged(){
    searchResultList();
  }
  void searchResultList() {

    var showResults = [];

    if(_searchController.text != ""){

      for(Dish dish in foodStore.dishesListFromDBAndUser){
        var name = dish.name.toLowerCase();
        if(name.contains(_searchController.text.toLowerCase())){
          showResults.add(dish);
        }
      }

    }else{
      showResults.addAll(foodStore.dishesListFromDBAndUser);
    }
    foodStore.resultsList.clear();
    showResults.forEach((element) {
      foodStore.resultsList.add(element);
    });
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


  void setQuantityAndMealTimeToDish(String qty,Dish dish){
    MealTimeStore mealTimeStore = Provider.of<MealTimeStore>(context, listen: false);
    dish.mealTime = mealTimeStore.selectedMealTime.toString().split('.').last;
    dish.qty = qty;
  }

  @override
  Widget build(BuildContext context) {
    final foodStore = Provider.of<FoodStore>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Search Dish"),
        ),
        body: Container(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.black,)
                  ),
                ),
                Container(
                    child: Observer(
                      builder: (_) {
                        switch (foodStore.loadInitSearchAllDishesList.status) {
                          case FutureStatus.rejected:
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Oops something went wrong'),
                                  RaisedButton(
                                    child: Text('Retry'),
                                    onPressed: () async {
                                      await foodStore.retrySearchAllDishesList(ingredientStore);
                                    },
                                  ),
                                ],
                              ),
                            );
                          case FutureStatus.fulfilled:
                            return Expanded(child: Observer(builder: (_) => ListView.separated(
                                separatorBuilder: (BuildContext context, int index) {
                                  return Divider(
                                    height: 4,
                                  );
                                },
                                itemCount: foodStore.resultsList.length,
                                itemBuilder: (context, index) {

                                  return ListTile(
                                    onTap: ()=> {
                                      if(!mealTimeStore.checkIfDishIsPresent(foodStore.resultsList[index])){
                                        showDialog(
                                            context: context,
                                            builder: (_) =>
                                            new AlertDialog(
                                              title: Text('Select the quantity eaten'),
                                              content: Observer(builder: (_) => Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[

                                                  for (int i = 0; i < Quantity.values.length; i++)
                                                    ListTile(
                                                      title: Text(
                                                        Quantity.values[i].toString().split('.').last,
                                                      ),
                                                      leading: Radio(
                                                        value: i,
                                                        groupValue: foodStore.resultsList[index].valueShowDialog,
                                                        onChanged: (int value) {
                                                          foodStore.resultsList[index].valueShowDialog=value;
                                                        },
                                                      ),
                                                    ),
                                                  Divider(
                                                    height: 4,
                                                    thickness: 0.8,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              )),
                                              contentPadding: EdgeInsets.only(top: 8),
                                              actionsPadding: EdgeInsets.only(bottom: 5,right: 5),
                                              actions: [
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('CANCEL'),
                                                ),
                                                FlatButton(
                                                  onPressed: () {
                                                    setQuantityAndMealTimeToDish(quantityList[foodStore.resultsList[index].valueShowDialog],foodStore.resultsList[index]);
                                                    mealTimeStore.addDishOfMealTimeListOfSpecificDay(foodStore.resultsList[index], dateStore.calendarSelectedDate)
                                                        .then((value) => Navigator.of(context).popUntil((route) => route.isFirst)
                                                    );
                                                  },
                                                  child: Text('ADD'),
                                                ),
                                              ],
                                            )

                                        )
                                      }else{
                                        showDialog(
                                            context: context,
                                            builder: (_) =>
                                            new AlertDialog(
                                              title: Text('Dish already present'),
                                              content:Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Divider(
                                                    height: 4,
                                                    thickness: 0.8,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                              contentPadding: EdgeInsets.only(top: 30),
                                              actionsPadding: EdgeInsets.only(bottom: 5,right: 5),
                                              actions: [
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('OK'),
                                                )
                                              ],
                                            )

                                        )
                                      }

                                    },
                                      title: Text(foodStore.resultsList[index].name,style: TextStyle(fontSize: 22.0)),
                                      subtitle:  Observer(builder: (_) =>Text(foodStore.mapIngredientsStringDish[foodStore.resultsList[index]].stringIngredients)),
                                      leading: foodStore.isSubstring("User", foodStore.resultsList[index].id)?
                                      FutureBuilder(
                                          future: getImage(foodStore.resultsList[index].id),
                                          builder: (context, remoteString) {
                                            if (remoteString.connectionState != ConnectionState.waiting) {
                                              if (remoteString.hasError) {
                                                return Text("Image not found");
                                              }
                                              else {
                                                return Observer(builder: (_) =>Container
                                                  (width: 40,
                                                    height: 40,
                                                    decoration: new BoxDecoration(
                                                      borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                                                      border: new Border.all(
                                                        color: Colors.black,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    child: ClipOval(
                                                        child: foodStore.resultsList[index].imageFile==null? Image.network(remoteString.data, fit:BoxFit.cover)
                                                            :Image.file(foodStore.resultsList[index].imageFile, fit:BoxFit.cover)
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
                                        (width: 45,
                                          height: 45,
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                                            border: new Border.all(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                          ),
                                          child:  ClipOval(
                                              child: Image(
                                                image: AssetImage("images/Dishes/" +foodStore.resultsList[index].id+".png" ),
                                                  fit:BoxFit.cover
                                              )
                                          )),

                                    );

                                })));
                          case FutureStatus.pending:
                          default:
                            return Center(
                                child:CircularProgressIndicator());
                        }
                      },
                    ))
              ],
            )
        )
    );
  }


}
