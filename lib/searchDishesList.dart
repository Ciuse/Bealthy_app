import 'package:Bealthy_app/dishPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:mobx/mobx.dart';
import 'Database/dish.dart';
import 'Database/enumerators.dart';
import 'Login/config/palette.dart';
import 'Models/dateStore.dart';
import 'Models/mealTimeStore.dart';
import 'Models/foodStore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'Models/ingredientStore.dart';


class SearchDishesList extends StatefulWidget {
  @override
  _SearchDishesListState createState() => _SearchDishesListState();
}

class _SearchDishesListState extends State<SearchDishesList>{


  TextEditingController _searchController = TextEditingController();

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
      var storage = FirebaseStorage.instance;
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
          title: Text("Search"),
        ),
        body: Container(
          color: Colors.white,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color:Palette.bealthyColorScheme.secondary)
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

                            searchResultList();
                            return Expanded(child: Observer(builder: (_) => ListView.separated(
                                key:Key("ListView"),
                                separatorBuilder: (BuildContext context, int index) {
                                  return Divider(
                                    height: 4,
                                  );
                                },
                                itemCount: foodStore.resultsList.length,
                                itemBuilder: (context, index) {

                                  return FocusedMenuHolder(
                                    menuWidth: MediaQuery.of(context).size.width,
                                    menuItemExtent: MediaQuery.of(context).size.height*0.45,
                                    blurSize: 4,
                                    animateMenuItems: false,
                                    blurBackgroundColor: Palette.bealthyColorScheme.background,
                                    onPressed: (){},
                                      menuItems: <FocusedMenuItem>[
                                  FocusedMenuItem(title: Observer(builder: (_) =>dishLongPressed(foodStore.resultsList[index],foodStore.mapIngredientsStringDish[foodStore.resultsList[index]].stringIngredients)),onPressed: (){}),
                                      ],
                                      child: ListTile(
                                    onTap: ()=> {
                                      if(!mealTimeStore.checkIfDishIsPresent(foodStore.resultsList[index])){
                                        showDialog(
                                            context: context,
                                            builder: (_) =>
                                            new AlertDialog(
                                              key: Key("alertDialog"),
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
                                              key: Key("alertDialogDishPresent"),
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
                                    title: Text(foodStore.resultsList[index].name,maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    subtitle:  Observer(builder: (_) =>Text(foodStore.mapIngredientsStringDish[foodStore.resultsList[index]].stringIngredients,maxLines: 2, overflow: TextOverflow.ellipsis,)),
                                    isThreeLine:true,
                                    leading: foodStore.isSubstring("User", foodStore.resultsList[index].id)?
                                      FutureBuilder(
                                          future: getImage(foodStore.resultsList[index].id),
                                          builder: (context, remoteString) {
                                            if (remoteString.connectionState != ConnectionState.waiting) {
                                              if (remoteString.hasError) {
                                                return Container(
                                                    width: 44,
                                                    height: 44,
                                                    decoration: new BoxDecoration(
                                                      borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                                                      border: new Border.all(
                                                        color: Palette.bealthyColorScheme.primaryVariant,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    child: ClipOval(
                                                        child: Image(
                                                          fit: BoxFit.cover,
                                                          image: AssetImage("images/defaultDish.png"),
                                                        )));
                                              }
                                              else {
                                                return Observer(builder: (_) =>Container
                                                  (width: 40,
                                                    height: 40,
                                                    decoration: new BoxDecoration(
                                                      borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                                                      border: new Border.all(
                                                        color: Palette.bealthyColorScheme.primaryVariant,
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
                                              color: Palette.bealthyColorScheme.primaryVariant,
                                              width: 1.0,
                                            ),
                                          ),
                                          child:  ClipOval(
                                              child: Image(
                                                image: AssetImage("images/Dishes/" +foodStore.resultsList[index].id+".png" ),
                                                  fit:BoxFit.cover
                                              )
                                          )),

                                    ));

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

  Widget dishLongPressed(Dish dish,String ingredients){
    return Column(
        children: [
          Expanded(
              flex:1,
              child:Container(
              padding: EdgeInsets.all(4),
              child:
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                      child:
              Row(children: [
                Expanded(
                  flex:1,
                    child:widgetDishImage(dish)),
               SizedBox(width: 12,),
               Expanded(
                 flex:2,
                   child:Text(dish.name,style: TextStyle(fontSize: 20),)),
              ],))
          )),
          Expanded(
            flex:2,
              child: widgetIngredientList(ingredients)),
        ]
    );
  }

  Widget widgetDishImage(Dish dish){
    return foodStore.isSubstring("User", dish.id)?
    FutureBuilder(
        future: getImage(dish.id),
        builder: (context, remoteString) {
          if (remoteString.connectionState != ConnectionState.waiting) {
            if (remoteString.hasError) {
              return Container(
                  width: 100,
                  height: 100,
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                    border: new Border.all(
                      color: Palette.bealthyColorScheme.primaryVariant,
                      width: 1.0,
                    ),
                  ),
                  child: ClipOval(
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage("images/defaultDish.png"),
                      )));
            }
            else {
              return Observer(builder: (_) =>Container
                (width: 100,
                  height: 100,
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                    border: new Border.all(
                      color: Palette.bealthyColorScheme.primaryVariant,
                      width: 1.0,
                    ),
                  ),
                  child: ClipOval(
                      child: dish.imageFile==null? Image.network(remoteString.data, fit:BoxFit.cover)
                          :Image.file(dish.imageFile, fit:BoxFit.cover)
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
      (width: 100,
        height: 100,
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
          border: new Border.all(
            color: Palette.bealthyColorScheme.primaryVariant,
            width: 1.0,
          ),
        ),
        child:  ClipOval(
            child: Image(
                image: AssetImage("images/Dishes/" +dish.id+".png" ),
                fit:BoxFit.cover
            )
        ));
  }

  Widget widgetIngredientList(String ingredients){
    String ingr2 = ingredients.replaceAll(' ', '');
    List<String> ingr = ingr2.split(',');
    return   Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(vertical: 8),
              child:Text("Ingredients",style: TextStyle(fontSize: 20))),
              Expanded(child:
                SizedBox(width: MediaQuery.of(context).size.width*0.9, child:  ListView.builder
                (
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: ingr.length,
                  itemBuilder: (BuildContext context, int index) {
                    return
                            ListTile(
                              title: Text(ingr[index]),
                              leading: Image(image:AssetImage("images/ingredients/" + ingredientStore.getIngredientFromName(ingr[index]).id + ".png"), height: 24,width:24,),
                            );
                  }
              )))
            ]);

  }

}

