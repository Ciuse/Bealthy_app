import 'package:Bealthy_app/dishPageFromScan.dart';
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
import 'package:focused_menu/focused_menu.dart';
import 'Database/dish.dart';
import 'Database/enumerators.dart';
import 'Login/config/palette.dart';
import 'Models/dateStore.dart';
import 'Models/foodStore.dart';
import 'Models/ingredientStore.dart';
import 'Models/mealTimeStore.dart';
import 'createNewDish.dart';
import 'package:focused_menu/modals.dart';

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
                margin: MediaQuery.of(context).orientation==Orientation.portrait?
                EdgeInsets.all(30):EdgeInsets.symmetric(vertical: 40,horizontal: 90),
                child: Column(
                    children: [

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child:
                          Card(
                              elevation: 5,
                              child:
                              TextButton(
                              key:Key("searchButton"),
                              style: TextButton.styleFrom(
                                primary:  Palette.secondaryLight,
                              ),
                              onPressed: ()=> Navigator.push(
                                  context,MaterialPageRoute(builder: (context) => SearchDishesList())),
                              child:
                              Container(
                                  padding: MediaQuery.of(context).orientation==Orientation.portrait?
                                  EdgeInsets.all(8):EdgeInsets.symmetric(vertical: 32, horizontal: 8),
                                  child:Column(
                                  mainAxisSize: MainAxisSize.min,

                                  children:[
                                    Icon(Icons.search, size: 75),
                                    Text("Search")
                                  ]
                              )
                        )))),
                          MediaQuery.of(context).orientation==Orientation.portrait?
                          SizedBox(width: 20,):SizedBox(width: 40,),
                          Expanded(child:Card(
                              elevation: 5,
                              child:
                              TextButton(
                                  key:Key("scanButton"),
                              style: TextButton.styleFrom(
                                primary:  Palette.secondaryLight,
                              ),
                                    onPressed: () async => {
                                    scanBarCodeAndCheckPermission(),
                                      // barCodeScannerStore.scanBarcode = "8076809500302",
                                      // if(barCodeScannerStore.scanBarcode != "-1") {
                                      //   await barCodeScannerStore.getScannedDishes(
                                      //       barCodeScannerStore.scanBarcode).then((dishDB) {
                                      //     if (dishDB.id != null) {
                                      //       Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(builder: (context) =>
                                      //             DishPage(dish: dishDB, createdByUser: true,)),
                                      //       );
                                      //     } else {
                                      //       Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(builder: (context) =>
                                      //             DishPageFromScan(barcode: barCodeScannerStore.scanBarcode)),
                                      //       );
                                      //     }
                                      //   }),
                                      // }
                                      // else{
                                      //   showToast("Failed To scan Barcode", position: ToastPosition.bottom, duration: Duration(seconds: 4)),
                                      // }
                                    },
                              child:
                              Container(
                                  padding: MediaQuery.of(context).orientation==Orientation.portrait?
                                  EdgeInsets.all(8):EdgeInsets.symmetric(vertical: 32, horizontal: 8),
                                  child:Column(
                                  mainAxisSize: MainAxisSize.min,

                                  children:[
                                    Icon(FontAwesomeIcons.barcode, size: 75),
                                    FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child:Text("Scan Barcode"))
                                  ]
                              )
                          ))))
                        ],),
                      MediaQuery.of(context).orientation==Orientation.portrait?
                      SizedBox(height: 20,):SizedBox(height: 40,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(child:Card(
                              elevation: 5,
                              child:
                              TextButton(
                                  key:Key("favouriteButton"),
                                  style: TextButton.styleFrom(
                                    primary:  Palette.secondaryLight,
                                  ),
                                  onPressed: ()=> Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => FavouriteDishes())),
                                  child:
                                  Container(
                                      padding: MediaQuery.of(context).orientation==Orientation.portrait?
                                      EdgeInsets.all(8):EdgeInsets.symmetric(vertical: 32, horizontal: 8),
                                      child:Column(
                                  mainAxisSize: MainAxisSize.min,

                                  children:[
                                    Padding(
                                        padding:EdgeInsets.all(5) ,
                                        child:Icon(Icons.favorite_border, size: 65)),
                                    Text("Favourites")
                                  ]
                              )
                          )))),
                          MediaQuery.of(context).orientation==Orientation.portrait?
                          SizedBox(width: 20,):SizedBox(width: 40,),
                          Expanded(child:Card(
                              elevation: 5,
                              child:
                             TextButton(
                                 key:Key("createdButton"),
                              style: TextButton.styleFrom(
                                primary:  Palette.secondaryLight,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => YourDishList()));
                              },
                              child:
                              Container(
                                  padding: MediaQuery.of(context).orientation==Orientation.portrait?
                                  EdgeInsets.all(8):EdgeInsets.symmetric(vertical: 32, horizontal: 8),
                                  child:Column(
                                  mainAxisSize: MainAxisSize.min,

                                  children:[
                                    Padding(
                                      padding:EdgeInsets.all(10) ,
                                        child:Icon(FontAwesomeIcons.userEdit, size: 55)),
                                    Text("Created")
                                  ]
                              )
                          ))))
                        ],),
                      MediaQuery.of(context).orientation==Orientation.portrait?
                      SizedBox(height: 20,):SizedBox(height: 40,),
                      Card(
                          elevation: 5,
                          child:
                          TextButton(
                              key:Key("createNewDishButton"),
                          style: TextButton.styleFrom(
                            primary:  Palette.secondaryLight,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CreateNewDish()));
                          },
                          child:
                          Container(
                              padding: MediaQuery.of(context).orientation==Orientation.portrait?
                              EdgeInsets.all(8):EdgeInsets.symmetric(vertical: 32, horizontal: 8),
                              child:ListTile(
                              leading: Icon(Icons.restaurant_menu, size: 50),
                              title: Text("Create Dish", style: TextStyle(color: Colors.black87),),
                              trailing: Icon(FontAwesomeIcons.chevronRight, size: 20,)
                          )
                      )))
                    ]
                )
            ))))
    );
  }

  void scanBarCodeAndCheckPermission() async{
    var cameraStatus = await Permission.camera.status;

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
        body: Container(
          color: Colors.white,
          child:Column(
            children:[
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
                          return FocusedMenuHolder(
                              menuWidth: MediaQuery.of(context).size.width,
                          menuItemExtent: MediaQuery.of(context).size.height*0.45,
                          blurSize: 4,
                          animateMenuItems: false,
                          blurBackgroundColor: Palette.bealthyColorScheme.background,
                          onPressed: (){},
                          menuItems: <FocusedMenuItem>[
                          FocusedMenuItem(title: Observer(builder: (_) =>dishLongPressed(foodStore.yourFavouriteDishList[index],
                              foodStore.mapIngredientsStringDish[foodStore.yourFavouriteDishList[index]].stringIngredients)),onPressed: (){}),
                          ],
                          child:ListTile(
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
                            title: Text(foodStore.yourFavouriteDishList[index].name,maxLines: 1, overflow: TextOverflow.ellipsis,),
                            subtitle:  Observer(builder: (_) =>Text(foodStore.mapIngredientsStringDish[foodStore.yourFavouriteDishList[index]].stringIngredients,maxLines: 2, overflow: TextOverflow.ellipsis,)),
                            isThreeLine:true,
                            leading: foodStore.isSubstring("User", foodStore.yourFavouriteDishList[index].id)?
                              FutureBuilder(
                                  future: getImage(foodStore.yourFavouriteDishList[index].id),
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
                            ));
                        })));
                  case FutureStatus.pending:
                  default:
                    return Center(child:CircularProgressIndicator());
                }
              },
            )])
    ));
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
                       widgetDishImage(dish),
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
    return isSubstring("User", dish.id)?
    FutureBuilder(
        future: getImage(dish.id),
        builder: (context, remoteString) {
          if (remoteString.connectionState != ConnectionState.waiting) {
            if (remoteString.hasError) {
              return Container(
                  width: MediaQuery.of(context).orientation == Orientation.portrait?100:150,
                  height: MediaQuery.of(context).orientation == Orientation.portrait?100:150,
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
                (width: MediaQuery.of(context).orientation == Orientation.portrait?100:150,
                  height: MediaQuery.of(context).orientation == Orientation.portrait?100:150,
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
      (width: MediaQuery.of(context).orientation == Orientation.portrait?100:150,
        height: MediaQuery.of(context).orientation == Orientation.portrait?100:150,
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
            padding: EdgeInsets.all(0),
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

  bool isSubstring(String s1, String s2) {
    int M = s1.length;
    int N = s2.length;

/* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
      int j;

/* For current index i, check for
 pattern match */
      for (j = 0; j < M; j++)
        if (s2[i + j] != s1[j])
          break;

      if (j == M)
        return true; // il piatto è stato creato dall'utente
    }

    return false; //il piatto non è stato creato dall'utente

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
          title: Text("Created"),
        ),
        body: Container(
        color: Colors.white,
        child:Column(children:[
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
                           return FocusedMenuHolder(
                               menuWidth: MediaQuery.of(context).size.width,
                            menuItemExtent: MediaQuery.of(context).size.height*0.45,
                            blurSize: 4,
                            animateMenuItems: false,
                            blurBackgroundColor: Palette.bealthyColorScheme.background,
                            onPressed: (){},
                            menuItems: <FocusedMenuItem>[
                            FocusedMenuItem(title: Observer(builder: (_) =>dishLongPressed(foodStore.yourCreatedDishList[index],
                               foodStore.mapIngredientsStringDish[foodStore.yourCreatedDishList[index]].stringIngredients)),onPressed: (){}),
                            ],
                            child:ListTile(
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
                                title: Text(foodStore.yourCreatedDishList[index].name,maxLines: 1, overflow: TextOverflow.ellipsis,),
                               subtitle:  Observer(builder: (_) =>Text(foodStore.mapIngredientsStringDish[foodStore.yourCreatedDishList[index]].stringIngredients,maxLines: 2, overflow: TextOverflow.ellipsis,)),
                               isThreeLine:true,
                                leading:
                                FutureBuilder(
                                    future: getImage(foodStore.yourCreatedDishList[index].id),
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
                              ));
                          })));
                    case FutureStatus.pending:
                    default:
                      return Center(child:CircularProgressIndicator());
                  }
                },
              ),
          ],),
    ));
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
                        widgetDishImage(dish),
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
    return isSubstring("User", dish.id)?
    FutureBuilder(
        future: getImage(dish.id),
        builder: (context, remoteString) {
          if (remoteString.connectionState != ConnectionState.waiting) {
            if (remoteString.hasError) {
              return Container(
                  width: MediaQuery.of(context).orientation == Orientation.portrait?100:150,
                  height: MediaQuery.of(context).orientation == Orientation.portrait?100:150,
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
                (width: MediaQuery.of(context).orientation == Orientation.portrait?100:150,
                  height: MediaQuery.of(context).orientation == Orientation.portrait?100:150,
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
      (width: MediaQuery.of(context).orientation == Orientation.portrait?100:150,
        height: MediaQuery.of(context).orientation == Orientation.portrait?100:150,
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
              padding: EdgeInsets.all(0),
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

  bool isSubstring(String s1, String s2) {

    int M = s1.length;
    int N = s2.length;

/* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
      int j;

/* For current index i, check for
 pattern match */
      for (j = 0; j < M; j++)
        if (s2[i + j] != s1[j])
          break;

      if (j == M)
        return true; // il piatto è stato creato dall'utente
    }

    return false; //il piatto non è stato creato dall'utente

  }
}

