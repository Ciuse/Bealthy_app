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
import 'package:permission_handler/permission_handler.dart';
import 'Database/dish.dart';
import 'Login/config/palette.dart';
import 'Models/foodStore.dart';
import 'package:camera/camera.dart';
import 'uploadNewPictureToUserDish.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';


class DishPage extends StatefulWidget {

  final Dish dish;
  final bool createdByUser;
  DishPage({@required this.dish, @required this.createdByUser});

  @override
  _DishPageState createState() => _DishPageState();
}

class _DishPageState extends State<DishPage>{
  var storage = FirebaseStorage.instance;
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  List<String> quantityList;
  List<CameraDescription> cameras;
  IngredientStore ingredientStore;
  FoodStore foodStore;
  MealTimeStore mealTimeStore;
  DateStore dateStore;

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
     foodStore = Provider.of<FoodStore>(context, listen: false);
     mealTimeStore = Provider.of<MealTimeStore>(context, listen: false);
     dateStore = Provider.of<DateStore>(context, listen: false);
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

  void checkPermissionOpenCamera() async{
    var cameraStatus = await Permission.camera.status;
    var galleryStatus = await Permission.storage.status;

    if (!cameraStatus.isGranted)
      {await Permission.camera.request();}

    if(!galleryStatus.isGranted){
      await Permission.storage.request();
    }

    if(await Permission.camera.isGranted){
      if(await Permission.storage.isGranted){
        openCamera();
      }else{
        showToast("Camera needs to access your Storage, please provide permission", position: ToastPosition.bottom);
        openAppSettings2();
      }
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

  openCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadNewPictureToUserDish(camera: cameras.first,dish: widget.dish,uploadingOnFirebase: true,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    foodStore.isFoodFavourite(widget.dish);
    return   Scaffold(
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
          ))
        ],
      ),
      body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(4),
                    child:MediaQuery.of(context).orientation==Orientation.portrait?Column(
                        children: [
                          widgetDishImage(),
                          widgetIngredientList(),
                          SizedBox(height: 20,),
                          widgetAddDishButton(),

                        ]

                    ):
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 4,
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height-
                                        AppBar().preferredSize.height-240
                                ),child:
                            Column(children: [
                              Expanded(child: widgetDishImage()),
                              widgetAddDishButton(),

                            ],))),
                        Expanded(
                            flex: 3,
                            child: widgetIngredientList())
                      ],))
              ]
          )),


    );
  }

  Widget widgetAddDishButton(){
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ElevatedButton(
          onPressed: (){
            if(!mealTimeStore.checkIfDishIsPresent(widget.dish)){
              return showDialog(
                  context: context,
                  builder: (_) =>  new AlertDialog(
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
                          setQuantityAndMealTimeToDish(quantityList[widget.dish.valueShowDialog]);
                          mealTimeStore.addDishOfMealTimeListOfSpecificDay(widget.dish, dateStore.calendarSelectedDate)
                              .then((value) => Navigator.of(context).popUntil((route) => route.isFirst)
                          );
                        },
                        child: Text('ACCEPT'),
                      ),
                    ],
                  )
              );
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

              );
            }

          },
          child:  Text('ADD DISH'),
          style: ElevatedButton.styleFrom(primary: Palette.bealthyColorScheme.primary),
        )
    );
  }

  Widget widgetDishImage(){
    return Card(
      elevation: 0,
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
                            (width: MediaQuery.of(context).orientation==Orientation.portrait?150:325,
                              height: MediaQuery.of(context).orientation==Orientation.portrait?150:325,
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(new Radius.circular(300.0)),
                                border: new Border.all(
                                  color: Palette.bealthyColorScheme.primaryVariant,
                                  width: 1.5,
                                ),
                              ),
                              child: ClipOval(
                                child: widget.dish.imageFile==null? Container(
                                    width: MediaQuery.of(context).orientation==Orientation.portrait?150:325,
                                    height: MediaQuery.of(context).orientation==Orientation.portrait?150:325,
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.all(new Radius.circular(300.0)),
                                      border: new Border.all(
                                        color: Palette.bealthyColorScheme.primaryVariant,
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipOval(
                                        child: Image(
                                          fit: BoxFit.cover,
                                          image: AssetImage("images/defaultDish.png"),
                                        ))):
                                Image.file(widget.dish.imageFile,  fit: BoxFit.cover,),)),

                          Stack(
                              children:  <Widget>[
                                MediaQuery.of(context).orientation==Orientation.portrait?Container(

                                    margin: const EdgeInsets.only(left: 125,top:125),
                                    child:IconButton(padding: EdgeInsets.all(2),onPressed: openCamera, icon: Icon(Icons.add_a_photo_outlined), iconSize: 42, color: Palette.bealthyColorScheme.secondary,
                                    )):Container(
                                    margin: const EdgeInsets.only(left: 280,top:280),
                                    child:IconButton(padding: EdgeInsets.all(2),onPressed: openCamera, icon: Icon(Icons.add_a_photo_outlined), iconSize: 48, color: Palette.bealthyColorScheme.secondary,
                                    )),]
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
                            (width: MediaQuery.of(context).orientation==Orientation.portrait?150:325,
                              height: MediaQuery.of(context).orientation==Orientation.portrait?150:325,
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(new Radius.circular(300.0)),
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
                                MediaQuery.of(context).orientation==Orientation.portrait?Container(

                                    margin: const EdgeInsets.only(left: 125,top:125),
                                    child:IconButton(padding: EdgeInsets.all(2),onPressed: openCamera, icon: Icon(Icons.add_a_photo_outlined), iconSize: 42, color: Palette.bealthyColorScheme.secondary,
                                    )):Container(
                                    margin: const EdgeInsets.only(left: 280,top:280),
                                    child:IconButton(padding: EdgeInsets.all(2),onPressed: openCamera, icon: Icon(Icons.add_a_photo_outlined), iconSize: 48, color: Palette.bealthyColorScheme.secondary,
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
                return Container(
                    width: 44,
                    height: 44,
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.all(new Radius.circular(300.0)),
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
                return Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    child:Stack(
                        children: [
                          Container(
                              width: MediaQuery.of(context).orientation==Orientation.portrait?150:325,
                              height: MediaQuery.of(context).orientation==Orientation.portrait?150:325,
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(new Radius.circular(300.0)),
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

    );
  }
  Widget widgetIngredientList(){
    return  Card(
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
    );
  }
}

