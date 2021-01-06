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
        color: Palette.tealThreeMoreLight,
        child:Column(
          children:<Widget>[
            for( var element in MealTime.values )
        Observer(builder: (_) => listViewForAMealTime(element, mealTimeStore,ingredientStore)),
            SizedBox(
              height: 15,
            )
          ],

    ));


  }

  dynamicListTile(int index){
    final mealTimeStore = Provider.of<MealTimeStore>(context);
    switch(index) {
      case 0: {
        return ListTile(
          title: Text(MealTime.Breakfast.toString().split('.').last,style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
          leading: Icon(Icons.breakfast_dining,color: Colors.black),
          trailing: Row (
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add,color: Palette.tealDark,size: 30,),
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
          title: Text(MealTime.Lunch.toString().split('.').last,style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
          leading: Icon(Icons.lunch_dining,color: Colors.black ),
          trailing: Row (
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add,color: Palette.tealDark,size: 30,),
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
          title: Text(MealTime.Snack.toString().split('.').last,style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
          leading: Icon(Icons.fastfood_rounded,color: Colors.black),
          trailing: Row (
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add,color: Palette.tealDark,size: 30,),
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
          title: Text(MealTime.Dinner.toString().split('.').last,style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
          leading: Icon(Icons.dinner_dining,color: Colors.black),
          trailing: Row (
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add,color:Palette.tealDark,size: 30,),
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
    return  Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 15, left: 10,right: 10 ),
        width:double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), //border corner radius
          boxShadow:[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6), //color of shadow
              spreadRadius: 4, //spread radius
              blurRadius: 6, // blur radius
              offset: Offset(0, 4), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
        ),
    child: Column(
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
                margin:  EdgeInsets.symmetric(horizontal: 10 ),
                padding: EdgeInsets.symmetric(horizontal: 10 ),
                decoration: BoxDecoration(
                  color: Color(0xffb30000),
                  borderRadius: BorderRadius.circular(20),),
                alignment: AlignmentDirectional.centerEnd,
                child: Icon(Icons.delete, color: Colors.white),
              ),
                child: Card(
                  shape:  RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: EdgeInsets.only(left: 10,right: 10, bottom: 12),
                  child: ListTile(
                      shape:  RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(15.0),
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
                            (width: 45,
                              height: 45,
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                                border: new Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              child: ClipOval(
                                child: mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].imageFile==null? Image.network(remoteString.data, fit: BoxFit.fill)
                                    :Image.file(mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].imageFile)
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
                              image: AssetImage("images/Dishes/" +mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].id+".png" ),
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
                                          EatenDishPage(dish: mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index],

                                              createdByUser: mealTimeStore.isSubstring("User", mealTimeStore.getDishesOfMealTimeList(mealTime.index)[index].id))));
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

    ]));

  }

  void modify(){
    print("modify");
  }
}


