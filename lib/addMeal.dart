import 'package:Bealthy_app/Models/barCodeScannerStore.dart';
import 'package:Bealthy_app/dishPage.dart';
import 'package:Bealthy_app/searchDishesList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'Database/dish.dart';
import 'Database/enumerators.dart';
import 'Login/config/palette.dart';
import 'Models/foodStore.dart';
import 'createNewDish.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class AddMeal extends StatefulWidget {
  final String title;
  AddMeal({@required this.title});
  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal>{
  BarCodeScannerStore barCodeScannerStore;
  void initState() {
    super.initState();
    barCodeScannerStore = Provider.of<BarCodeScannerStore>(context, listen: false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add new dish to"+" "+widget.title),
        ),
        body: OKToast( child: SingleChildScrollView(

        child:Container(
          color: Palette.primaryThreeMoreLight,
            child: Column(
                children: [
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchDishesList()),
                      )
                    },
                    child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10,right: 10 ),
                        margin: EdgeInsets.only(top: 15, left: 10,right: 10 ),
                        height: 60,
                        width:double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30), //border corner radius
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
                        child: Row(children:[ Icon(Icons.search, size: 35, color: Colors.black,),
                          SizedBox(width: 10,),
                          Text("Search dish to add")
                        ]
                        )
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10,right: 10 ),
                      margin: EdgeInsets.only(top: 35, left: 10,right: 10 ),
                      width:double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10), //border corner radius
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
                      child: Column(children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(right: 10, top: 15),
                          child:
                          Row(
                              children: <Widget>[
                                RawMaterialButton(
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => FavouriteDishes()))
                                  },
                                  elevation: 7.0,
                                  fillColor: Colors.white,
                                  child: Icon(
                                    Icons.favorite_border,
                                    size: 24.0,
                                    color: Colors.black,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                                SizedBox(width: 10,),
                                Text("Favourites")
                              ],
                            ),
                          ),
                        Divider(
                          thickness: 0.5,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.black,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(right: 10, top: 15),
                          child:
                          Row(
                            children: <Widget>[
                              RawMaterialButton(
                                onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CategoriesDish()))
                                },
                                elevation: 7.0,
                                fillColor: Colors.white,
                                child: Icon(
                                  Icons.category_outlined,
                                  size: 24.0,
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                              SizedBox(width: 10,),
                              Text("Category")
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.black,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(right: 10, top: 15),
                          child:
                          Row(
                            children: <Widget>[
                              RawMaterialButton(
                                onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => YourDishList()))
                                },
                                elevation: 7.0,
                                fillColor: Colors.white,
                                child: Icon(
                                  Icons.handyman_rounded,
                                  size: 24.0,
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                              SizedBox(width: 10,),
                              Text("Your Dish")
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.black,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(right: 10, top: 15,bottom:15),
                          child:
                          Row(
                            children: <Widget>[
                              RawMaterialButton(
                                onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CreateNewDish()))
                                },
                                elevation: 7.0,
                                fillColor: Colors.white,
                                child: Icon(
                                  Icons.create_outlined,
                                  size: 24.0,
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                              SizedBox(width: 10,),
                              Text("Create New Dish")
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.black,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(right: 10, top: 15,bottom:15),
                          child:
                          Row(
                            children: <Widget>[
                              RawMaterialButton(
                                onPressed: () async => {
                                  //scanBarCodeAndCheckPermission(),
                                  await barCodeScannerStore.getProductFromOpenFoodDB("8003000162015"),
                                },
                                elevation: 7.0,
                                fillColor: Colors.white,
                                child: Icon(
                                  Icons.create_outlined,
                                  size: 24.0,
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                              SizedBox(width: 10,),
                              Text("BarCodeScanner")
                            ],
                          ),
                        )]
                      )
                  ),
                  Observer(
              builder: (_) => Text(barCodeScannerStore.scanBarcode),)
                ]
            )
        )))
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
      showToast("Provide Camera permission to use camera.", position: ToastPosition.bottom);
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
    if(barCodeScannerStore.scanBarcode != "-1" && errorPlatform!=true){
      print(barCodeScannerStore.scanBarcode);
      await barCodeScannerStore.getProductFromOpenFoodDB(barCodeScannerStore.scanBarcode)
          .then((value) => {
        if(value!=null){
          print(value)
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => ))
        }
        else{
          showToast("Product of this barcode: "+ barCodeScannerStore.scanBarcode + " does not exists", position: ToastPosition.bottom)
        }
      });

    }else{
      showToast("Failed To scan Barcode", position: ToastPosition.bottom);
    }
  }

}

class FavouriteDishes extends StatefulWidget {
  @override
  _FavouriteDishesState createState() => _FavouriteDishesState();

}

class _FavouriteDishesState extends State<FavouriteDishes>{
  var storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    var store = Provider.of<FoodStore>(context, listen: false);
    store.initFavouriteDishList();
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
                              await foodStore.retryFavouriteDishesList();
                            },
                          ),
                        ],
                      ),
                    );
                  case FutureStatus.fulfilled:
                    return Expanded(child: ListView.builder(
                        itemCount: foodStore.yourFavouriteDishList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: ()=> { Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>
                                  DishPage(dish: foodStore.yourFavouriteDishList[index],
                                      createdByUser: foodStore.isSubstring("User", foodStore.yourFavouriteDishList[index].id))
                              ),
                              )
                              },
                              title: Text(foodStore.yourFavouriteDishList[index].name,style: TextStyle(fontSize: 22.0)),
                              subtitle: Text(foodStore.yourFavouriteDishList[index].category,style: TextStyle(fontSize: 18.0)),
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
                                                child: foodStore.yourFavouriteDishList[index].imageFile==null? Image.network(remoteString.data, fit: BoxFit.fill)
                                                    :Image.file(foodStore.yourFavouriteDishList[index].imageFile)
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
                                        image: AssetImage("images/Dishes/" +foodStore.yourFavouriteDishList[index].id+".png" ),
                                      )
                                  )),
                            ),
                          );
                        }));
                  case FutureStatus.pending:
                  default:
                    return CircularProgressIndicator();
                }
              },
            ))])
    );
  }
}


class CategoriesDish extends StatefulWidget {
  @override
  _CategoriesDishState createState() => _CategoriesDishState();
}

class _CategoriesDishState extends State<CategoriesDish>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Category"),
        ),
        body: Center(
            child: Column(
                children: [
                  for(var item in Category.values ) FlatButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CategoryDishList(category: item)),
                      )
                    },
                    color: Colors.orange,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.fastfood),
                        Text(item.toString().split('.').last)
                      ],
                    ),
                  ),
                ]
            )
        )
    );
  }

}


class CategoryDishList extends StatefulWidget {
  final Category category;

  // In the constructor, require a Category.
  CategoryDishList({@required this.category});

  @override
  _CategoryDishListState createState() => _CategoryDishListState();
}

class _CategoryDishListState extends State<CategoryDishList> {
  
  void initState() {
    super.initState();
    var store = Provider.of<FoodStore>(context, listen: false);
    store.initFoodCategoryLists(widget.category.index);
  }
  
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FoodStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category
            .toString()
            .split('.')
            .last),
      ),
        body: Center(
            child:   Observer(
                builder: (_) => Column(
                    children: [
                      for(Dish item in store.getCategoryList(widget.category.index) ) FlatButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DishPage(dish: item, createdByUser: false,)),
                          )
                        },
                        color: Colors.orange,
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.fastfood),
                            Text(item.name.toString())
                          ],
                        ),
                      ),
                    ]
                )
            )
        )
    );
  }
}




class YourDishList extends StatefulWidget {
  @override
  _YourDishListState createState() => _YourDishListState();
}

class _YourDishListState extends State<YourDishList> {
  var storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    var store = Provider.of<FoodStore>(context, listen: false);

    store.initCreatedYourDishList();

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
                                await foodStore.retryCreatedYourDishesList();
                              },
                            ),
                          ],
                        ),
                      );
                    case FutureStatus.fulfilled:
                      return Expanded(child: ListView.builder(
                          itemCount: foodStore.yourCreatedDishList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                onTap: ()=> { Navigator.push(
                                  context, MaterialPageRoute(builder: (context) =>
                                    DishPage(dish: foodStore.yourCreatedDishList[index],
                                        createdByUser: true)
                                ),
                                )
                                },
                                title: Text(foodStore.yourCreatedDishList[index].name,style: TextStyle(fontSize: 22.0)),
                                subtitle: Text(foodStore.yourCreatedDishList[index].category,style: TextStyle(fontSize: 18.0)),
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
                                                  child: foodStore.yourCreatedDishList[index].imageFile==null? Image.network(remoteString.data, fit: BoxFit.fill)
                                                      :Image.file(foodStore.yourCreatedDishList[index].imageFile)
                                              )));
                                        }
                                      }
                                      else {
                                        return CircularProgressIndicator();
                                      }
                                    }
                                )
                              ),
                            );
                          }));
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

