import 'dart:io';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/ingredientStore.dart';
import 'package:Bealthy_app/Models/mealTimeStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'Database/enumerators.dart';
import 'Database/dish.dart';
import 'Models/foodStore.dart';
import 'package:camera/camera.dart';
import 'uploadNewPictureToUserDish.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'Login/config/palette.dart';



class EatenDishPage extends StatefulWidget {

  final Dish dish;
  final bool createdByUser;
  EatenDishPage({@required this.dish, @required this.createdByUser});

  @override
  _EatenDishPageState createState() => _EatenDishPageState();
}

class _EatenDishPageState extends State<EatenDishPage>{
  var storage = FirebaseStorage.instance;
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  List<String> quantityList;
  List<CameraDescription> cameras;
  IngredientStore ingredientStore;
  File imageFile;

  void initState() {
    super.initState();
    initializeCameras();
    quantityList= getQuantityName();
    ingredientStore = Provider.of<IngredientStore>(context, listen: false);
    ingredientStore.ingredientListOfDish.clear();
    if(widget.createdByUser){
      ingredientStore.getIngredientsFromUserDish(widget.dish);
    }else{
      ingredientStore.getIngredientsFromDatabaseDish(widget.dish);
    }
  }

  Future<void> initializeCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();

  }
  List<String> getQuantityName(){
    List<String> listToReturn = new List<String>();
    Quantity.values.forEach((element) {
      listToReturn.add(element.toString().split('.').last);
    });
    return listToReturn;
  }

  int getMealTimeEnumIndex(String name){
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

  int getQuantityEnumIndex(String name){
    int i =0;
    int toReturn=0;
    Quantity.values.forEach((element) {
      if (element.toString().contains(name))
      {
        toReturn=i;
      }i++;
    }
    );
    return toReturn;
  }

  Future getImage() async {
      String userUid;
      final litUser = context.getSignedInUser();
      litUser.when(
            (user) => userUid=user.uid,
        empty: () => Text('Not signed in'),
        initializing: () => Text('Loading'),
      );
    try {
      return await storage.ref(userUid+"/DishImage/" + widget.dish.id + ".jpg").getDownloadURL();
    }
    catch (e) {
      return await Future.error(e);
    }
  }

  Future findIfLocal() {
    return rootBundle.load("images/Dishes/"+widget.dish.id+".png");
  }

  void setQuantityAndMealTimeToDish(String qty){
    MealTimeStore mealTimeStore = Provider.of<MealTimeStore>(context, listen: false);
    widget.dish.mealTime = mealTimeStore.selectedMealTime.toString().split('.').last;
    widget.dish.qty = qty;
  }

  openCamera()  {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadNewPictureToUserDish(camera: cameras.first,dish: widget.dish,uploadingOnFirebase: true,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FoodStore foodStore = Provider.of<FoodStore>(context);
    MealTimeStore mealTimeStore = Provider.of<MealTimeStore>(context);
    IngredientStore ingredientStore = Provider.of<IngredientStore>(context);
    DateStore dateStore = Provider.of<DateStore>(context);
    foodStore.isFoodFavourite(widget.dish);
    return   OKToast(
        child:Scaffold(
          appBar: AppBar(
            title: Text(widget.dish.name),
            actions: <Widget>[
              Observer(builder: (_) =>IconButton(
                  icon: Icon(
                    widget.dish.isFavourite ? Icons.favorite : Icons.favorite_border,
                    color: widget.dish.isFavourite ? Palette.bealthyColorScheme.secondary : null,
                  ),
                  onPressed: () {
                    if (widget.dish.isFavourite) {
                      foodStore.removeFavouriteDish(widget.dish);
                    } else {
                      foodStore.addFavouriteDish(widget.dish,ingredientStore);
                    }
                    // do something
                  }
              )),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Palette.bealthyColorScheme.onError,
                  ),
                  onPressed: () {
                      return showDialog(
                          context: context,
                          builder: (_) =>  new AlertDialog(
                              title: Text('Are you sure to remove it?'),
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
                                  child: Text('CANCEL'),
                                ),
                                FlatButton(
                                  child:Text('REMOVE'),
                                  onPressed: () {

                                    mealTimeStore.removeDishOfMealTimeListOfSpecificDay(getMealTimeEnumIndex(widget.dish.mealTime), widget.dish, dateStore.calendarSelectedDate)
                                        .then((value) => Navigator.of(context).popUntil((route) => route.isFirst));

                                  },

                                )]));
                  }
              )
            ],
          ),
          body: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                  children: [
                    Card(
                      child: widget.createdByUser? FutureBuilder(
                          future: getImage(),
                          builder: (context, remoteString) {
                            if (remoteString.connectionState != ConnectionState.waiting) {
                              if (remoteString.hasError) {
                                return Observer(builder: (_) =>Container(
                                    alignment: Alignment.center ,
                                    child: Stack(
                                        children: [
                                          Container
                                            (width: 150,
                                              height: 150,
                                              decoration: new BoxDecoration(
                                                borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                                                border: new Border.all(
                                                  color: Palette.bealthyColorScheme.primaryVariant,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: ClipOval(
                                                child: widget.dish.imageFile==null? null:
                                                Image.file(widget.dish.imageFile,  fit: BoxFit.cover,),)),

                                          Stack(
                                              children:  <Widget>[
                                                Container(
                                                    margin: const EdgeInsets.only(left: 125,top:125),
                                                    child:IconButton(padding: EdgeInsets.all(2),onPressed: openCamera, icon: Icon(Icons.add_a_photo_outlined), iconSize: 42,
                                                      color: Palette.bealthyColorScheme.secondary)),]

                                          )
                                        ])

                                ));
                              }
                              else {
                                return Observer(builder: (_) =>Container(
                                    alignment: Alignment.center ,
                                    child: Stack(
                                        children: [
                                          Container
                                            (width: 150,
                                              height: 150,
                                              decoration: new BoxDecoration(
                                                borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                                                border: new Border.all(
                                                  color: Palette.bealthyColorScheme.primaryVariant,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: ClipOval(
                                                child: widget.dish.imageFile==null? Image.network(remoteString.data, fit: BoxFit.cover):
                                                Image.file(widget.dish.imageFile, fit: BoxFit.cover),)),

                                          Stack(
                                              children:  <Widget>[
                                                Container(

                                                    margin: const EdgeInsets.only(left: 125,top:125),
                                                    child:IconButton(padding: EdgeInsets.all(2),onPressed: openCamera, icon: Icon(Icons.photo_camera), iconSize: 42, color: Palette.bealthyColorScheme.secondary,
                                                      )),]

                                          )
                                        ])

                                ));
                              }
                            }
                            else {
                              return Center(
                                  child:CircularProgressIndicator());
                            }
                          }
                      )
                          :
                      FutureBuilder (
                          future: findIfLocal(),
                          builder: (context,  AsyncSnapshot localData) {
                            if(localData.connectionState != ConnectionState.waiting ) {
                              if (localData.hasError) {
                                return Text("Image not found");
                              }
                              else {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                    alignment: Alignment.center,
                                    child:Stack(
                                    children: [
                                    Container(
                                    width: 150,
                                    height: 150,
                                        decoration: new BoxDecoration(
                                          borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                                          border: new Border.all(
                                            color: Palette.bealthyColorScheme.primaryVariant,
                                            width: 1.5,
                                          ),
                                        ),
                                    child:  ClipOval(
                                        child: Image(
                                          fit: BoxFit.cover,
                                          image: AssetImage("images/Dishes/" + widget.dish.id + ".png"),
                                        )
                                    ))
                                ]));
                              }
                            } else{
                              return Center(
                                  child:CircularProgressIndicator());
                            }
                          }
                      ),

                    ),

                    Card(
                      // height: 50,
                      // alignment: Alignment.center,
                      child:Observer(builder: (_) =>ListTile(
                        title:Text( "Eaten quantity"),
                        trailing:TextButton(child:
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(widget.dish.qty, textAlign: TextAlign.left),
                            Icon(Icons.mode_rounded,),
                          ],
                        ),
                            onPressed: () =>{
                              widget.dish.valueShowDialog=getQuantityEnumIndex(widget.dish.qty),
                              showDialog(
                                  context: context,
                                  builder: (_) =>  new AlertDialog(
                                    title: Text('Change Quantity'),
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
                                              groupValue: widget.dish.valueShowDialog,
                                              onChanged: (int value) {
                                                widget.dish.valueShowDialog=value;
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
                                          widget.dish.qty=Quantity.values[widget.dish.valueShowDialog].toString().split('.').last;
                                          mealTimeStore.updateDishOfMealTimeListOfSpecificDay
                                            (widget.dish, dateStore.calendarSelectedDate)
                                              .then((value) => Navigator.of(context).pop()
                                          );
                                        },
                                        child: Text('ACCEPT'),
                                      ),
                                    ],
                                  )
                              )}
                        ),
                      ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                        child: Column(
                            children:[
                              ListTile(
                                title: Text("Ingredients",style: TextStyle(fontWeight:FontWeight.bold,fontSize:19)),
                                leading: Icon(Icons.fastfood_outlined,color: Colors.black),
                              ),
                              Divider(
                                thickness: 0.8,
                                color: Colors.black54,
                              ),
                              Observer(builder: (_) => ListView.builder
                                (
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: ingredientStore.ingredientListOfDish.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        Container(
                                            child:
                                            ListTile(
                                              title: Text(ingredientStore.ingredientListOfDish[index].name),
                                              subtitle:Text(ingredientStore.ingredientListOfDish[index].qty),
                                              leading: Image(image:AssetImage("images/ingredients/" + ingredientStore.ingredientListOfDish[index].id + ".png"), height: 40,width:40,),
                                            )),
                                        index!=ingredientStore.ingredientListOfDish.length-1?
                                        Divider(
                                          height: 0,
                                          thickness: 0.5,
                                          indent: 20,
                                          endIndent: 20,
                                          color: Colors.black38,
                                        ):Container(),
                                      ],
                                    );
                                  }
                              ))
                            ]
                        )
                    ),
                    SizedBox(height: 20,)

                  ]

              )),

        ));
  }
}

