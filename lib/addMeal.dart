import 'package:Bealthy_app/DishPageFromScan.dart';
import 'package:Bealthy_app/Models/barCodeScannerStore.dart';
import 'package:Bealthy_app/dishPage.dart';
import 'package:Bealthy_app/searchDishesList.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'Database/dish.dart';
import 'Database/enumerators.dart';
import 'Login/config/palette.dart';
import 'Models/dateStore.dart';
import 'Models/foodStore.dart';
import 'Models/ingredientStore.dart';
import 'Models/mealTimeStore.dart';
import 'createNewDish.dart';

class AddMeal extends StatefulWidget {
  final String title;
  AddMeal({@required this.title});
  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal>{
  BarCodeScannerStore barCodeScannerStore;
  IngredientStore ingredientStore;
  FoodStore foodStore;

  void initState() {
    super.initState();
    barCodeScannerStore = Provider.of<BarCodeScannerStore>(context, listen: false);
    ingredientStore = Provider.of<IngredientStore>(context, listen: false);
    foodStore = Provider.of<FoodStore>(context, listen: false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: OKToast( child: Container(
            child:SingleChildScrollView(
            child:Container(
                margin: EdgeInsets.all(30),
                child: Column(
                    children: [

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(child:Card(
                              elevation: 5,
                              child:
                          TextButton(
                              style: TextButton.styleFrom(
                                primary:  Palette.secondaryLight,
                              ),
                              onPressed: ()=> Navigator.push(
                                  context,MaterialPageRoute(builder: (context) => SearchDishesList())),
                              child:
                              Column(
                                  mainAxisSize: MainAxisSize.min,

                                  children:[
                                    Icon(Icons.search, size: 75),
                                    Text("Search")
                                  ]
                              )
                        ))),
                          SizedBox(width: 20,),
                          Expanded(child:Card(
                              elevation: 5,
                              child:
                          TextButton(
                              style: TextButton.styleFrom(
                                primary:  Palette.secondaryLight,
                              ),
                                    onPressed: () async => {
                                      // scanBarCodeAndCheckPermission(),
                                      barCodeScannerStore.scanBarcode = "3168930010906",
                                      if(barCodeScannerStore.scanBarcode != "-1") {
                                        await barCodeScannerStore.getScannedDishes(
                                            barCodeScannerStore.scanBarcode).then((dishDB) {
                                          if (dishDB.id != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>
                                                  DishPage(dish: dishDB, createdByUser: true,)),
                                            );
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>
                                                  DishPageFromScan(barcode: barCodeScannerStore.scanBarcode)),
                                            );
                                          }
                                        }),
                                      }
                                      else{
                                        showToast("Failed To scan Barcode", position: ToastPosition.bottom, duration: Duration(seconds: 4)),
                                      }
                                    },
                              child:
                              Column(
                                  mainAxisSize: MainAxisSize.min,

                                  children:[
                                    Icon(FontAwesomeIcons.barcode, size: 75),
                                    Text("Scan Barcode")
                                  ]
                              )
                          )))
                        ],),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(child:Card(
                              elevation: 5,
                              child:
                              TextButton(
                                  style: TextButton.styleFrom(
                                    primary:  Palette.secondaryLight,
                                  ),
                                  onPressed: ()=> Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => FavouriteDishes())),
                                  child:
                                  Column(
                                  mainAxisSize: MainAxisSize.min,

                                  children:[
                                    Padding(
                                        padding:EdgeInsets.all(5) ,
                                        child:Icon(Icons.favorite_border, size: 65)),
                                    Text("Favourites")
                                  ]
                              )
                          ))),
                          SizedBox(width: 20,),
                          Expanded(child:Card(
                              elevation: 5,
                              child:
                          TextButton(
                              style: TextButton.styleFrom(
                                primary:  Palette.secondaryLight,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => YourDishList()));
                              },
                              child:
                              Column(
                                  mainAxisSize: MainAxisSize.min,

                                  children:[
                                    Padding(
                                      padding:EdgeInsets.all(10) ,
                                        child:Icon(FontAwesomeIcons.userEdit, size: 55)),
                                    Text("Created")
                                  ]
                              )
                          )))
                        ],),
                      SizedBox(height: 20,),

                      Card(
                          elevation: 5,
                          child:
                      TextButton(
                          style: TextButton.styleFrom(
                            primary:  Palette.secondaryLight,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CreateNewDish()));
                          },
                          child:
                          ListTile(
                              leading: Icon(Icons.restaurant_menu, size: 50),
                              title: Text("Create Dish", style: TextStyle(color: Colors.black87),),
                              trailing: Icon(FontAwesomeIcons.chevronRight, size: 20,)
                          )
                      ))
                    ]
                )
            ))))
    );
  }

  void scanBarCodeAndCheckPermission() async{
    var cameraStatus = await Permission.camera.status;

    print(cameraStatus);
    if (!cameraStatus.isGranted)
    {await Permission.camera.request();}

    if(await Permission.camera.isGranted){
      scanBarcodeNormal();

    }else{
      showToast("Provide Camera permission to use camera.", position: ToastPosition.bottom, duration: Duration(seconds: 4));
      openAppSettings2();
    }

  }


  openAppSettings2(){
    return showDialog(
        context: context,
        builder: (_) =>  new AlertDialog(
          title: new Text("Bealthy"),
          content: new Text("Bealthy needs to access to your memory in order to upload new image"),
          actions: <Widget>[
            FlatButton(
              child: Text('Settings'),
              onPressed: () {
                openAppSettings();
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ));
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    bool errorPlatform = false;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      errorPlatform=true;
    }
    barCodeScannerStore.scanBarcode = barcodeScanRes;
    if(barCodeScannerStore.scanBarcode != "-1" && errorPlatform!=true) {
      await barCodeScannerStore.getScannedDishes(
          barCodeScannerStore.scanBarcode).then((dishDB) {
        if (dishDB.id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                DishPage(dish: dishDB, createdByUser: true,)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                DishPageFromScan(barcode: barCodeScannerStore.scanBarcode)),
          ).then((value) =>   showToast("Product of this barcode: "+ barCodeScannerStore.scanBarcode + " does not exists", position: ToastPosition.bottom, duration: Duration(seconds: 4))
          );
        }
      });
    }
    else{
      showToast("Failed To scan Barcode", position: ToastPosition.bottom, duration: Duration(seconds: 4));
    }
  }
}

class FavouriteDishes extends StatefulWidget {
  @override
  _FavouriteDishesState createState() => _FavouriteDishesState();

}

class _FavouriteDishesState extends State<FavouriteDishes>{
  var storage = FirebaseStorage.instance;
  FoodStore foodStore;
  IngredientStore ingredientStore;
  MealTimeStore mealTimeStore;
  List<String> quantityList;
  DateStore dateStore;

  @override
  void initState() {
    super.initState();
    quantityList= getQuantityName();
    var foodStore = Provider.of<FoodStore>(context, listen: false);
    ingredientStore = Provider.of<IngredientStore>(context, listen: false);
    mealTimeStore = Provider.of<MealTimeStore>(context, listen: false);
    dateStore = Provider.of<DateStore>(context, listen: false);
    foodStore.initFavouriteDishList(ingredientStore);
  }

  List<String> getQuantityName(){
    List<String> listToReturn = new List<String>();
    Quantity.values.forEach((element) {
      listToReturn.add(element.toString().split('.').last);
    });
    return listToReturn;
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
          title: Text("Favourites"),
        ),
        body: Column(
            children:[Container(
              child:
            Observer(
              builder: (_) {
                switch (foodStore.loadInitFavouriteDishesList.status) {
                  case FutureStatus.rejected:
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Oops something went wrong'),
                          RaisedButton(
                            child: Text('Retry'),
                            onPressed: () async {
                              await foodStore.retryFavouriteDishesList(ingredientStore);
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
                        itemCount: foodStore.yourFavouriteDishList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              onTap: ()=> {
                                if(!mealTimeStore.checkIfDishIsPresent(foodStore.yourFavouriteDishList[index])){
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
                                                  groupValue: foodStore.yourFavouriteDishList[index].valueShowDialog,
                                                  onChanged: (int value) {
                                                    foodStore.yourFavouriteDishList[index].valueShowDialog=value;
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
                                              setQuantityAndMealTimeToDish(quantityList[foodStore.yourFavouriteDishList[index].valueShowDialog],foodStore.yourFavouriteDishList[index]);
                                              mealTimeStore.addDishOfMealTimeListOfSpecificDay(foodStore.yourFavouriteDishList[index], dateStore.calendarSelectedDate)
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
                              title: Text(foodStore.yourFavouriteDishList[index].name,style: TextStyle(fontSize: 22.0)),
                            subtitle:  Observer(builder: (_) =>Text(foodStore.mapIngredientsStringDish[foodStore.yourFavouriteDishList[index]].stringIngredients)),
                              leading: foodStore.isSubstring("User", foodStore.yourFavouriteDishList[index].id)?
                              FutureBuilder(
                                  future: getImage(foodStore.yourFavouriteDishList[index].id),
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
                                                child: foodStore.yourFavouriteDishList[index].imageFile==null? Image.network(remoteString.data, fit:BoxFit.cover)
                                                    :Image.file(foodStore.yourFavouriteDishList[index].imageFile, fit:BoxFit.cover)
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
                                        image: AssetImage("images/Dishes/" +foodStore.yourFavouriteDishList[index].id+".png" )
                                          , fit:BoxFit.cover
                                      )
                                  )),
                            );
                        })));
                  case FutureStatus.pending:
                  default:
                    return CircularProgressIndicator();
                }
              },
            ))])
    );
  }
}





class YourDishList extends StatefulWidget {
  @override
  _YourDishListState createState() => _YourDishListState();
}

class _YourDishListState extends State<YourDishList> {
  var storage = FirebaseStorage.instance;
  FoodStore foodStore;
  IngredientStore ingredientStore;
  MealTimeStore mealTimeStore;
  List<String> quantityList;
  DateStore dateStore;

  @override
  void initState() {
    super.initState();
    quantityList= getQuantityName();
    var foodStore = Provider.of<FoodStore>(context, listen: false);
    ingredientStore = Provider.of<IngredientStore>(context, listen: false);
    mealTimeStore = Provider.of<MealTimeStore>(context, listen: false);
    dateStore = Provider.of<DateStore>(context, listen: false);
    foodStore.initCreatedYourDishList(ingredientStore);
  }

  List<String> getQuantityName(){
    List<String> listToReturn = new List<String>();
    Quantity.values.forEach((element) {
      listToReturn.add(element.toString().split('.').last);
    });
    return listToReturn;
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
          title: Text("Your Dish"),
        ),
        body: Column(children:[
          Container(
              child:
              Observer(
                builder: (_) {
                  switch (foodStore.loadInitCreatedYourDishesList.status) {
                    case FutureStatus.rejected:
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Oops something went wrong'),
                            RaisedButton(
                              child: Text('Retry'),
                              onPressed: () async {
                                await foodStore.retryCreatedYourDishesList(ingredientStore);
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
                          itemCount: foodStore.yourCreatedDishList.length,
                          itemBuilder: (context, index) {
                           return ListTile(
                               onTap: ()=> {
                                 if(!mealTimeStore.checkIfDishIsPresent(foodStore.yourCreatedDishList[index])){
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
                                                   groupValue: foodStore.yourCreatedDishList[index].valueShowDialog,
                                                   onChanged: (int value) {
                                                     foodStore.yourCreatedDishList[index].valueShowDialog=value;
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
                                               setQuantityAndMealTimeToDish(quantityList[foodStore.yourCreatedDishList[index].valueShowDialog],foodStore.yourCreatedDishList[index]);
                                               mealTimeStore.addDishOfMealTimeListOfSpecificDay(foodStore.yourCreatedDishList[index], dateStore.calendarSelectedDate)
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
                                title: Text(foodStore.yourCreatedDishList[index].name,style: TextStyle(fontSize: 22.0)),
                               subtitle:  Observer(builder: (_) =>Text(foodStore.mapIngredientsStringDish[foodStore.yourCreatedDishList[index]].stringIngredients)),
                                leading:
                                FutureBuilder(
                                    future: getImage(foodStore.yourCreatedDishList[index].id),
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
                                                  child: foodStore.yourCreatedDishList[index].imageFile==null? Image.network(remoteString.data, fit:BoxFit.cover)
                                                      :Image.file(foodStore.yourCreatedDishList[index].imageFile, fit:BoxFit.cover)
                                              )));
                                        }
                                      }
                                      else {
                                        return CircularProgressIndicator();
                                      }
                                    }
                                )
                              );
                          })));
                    case FutureStatus.pending:
                    default:
                      return CircularProgressIndicator();
                  }
                },
              )),
          ],),
    );
  }
}

