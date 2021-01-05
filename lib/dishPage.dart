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

    print(galleryStatus);
    if (!cameraStatus.isGranted)
      {await Permission.camera.request();}

    if(!galleryStatus.isGranted){
      print("richiesta permessi");
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
    FoodStore foodStore = Provider.of<FoodStore>(context);
    MealTimeStore mealTimeStore = Provider.of<MealTimeStore>(context);
    IngredientStore ingredientStore = Provider.of<IngredientStore>(context);
    DateStore dateStore = Provider.of<DateStore>(context);
    foodStore.isFoodFavourite(widget.dish);
    return   Scaffold(
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
    children: [
      Container(
        padding: EdgeInsets.all(10.0),
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
                                    color: Colors.black,
                                    width: 4.0,
                                  ),
                                ),
                                child: ClipOval(
                                  child: widget.dish.imageFile==null? null:
                                  Image.file(widget.dish.imageFile),)),

                            Stack(
                                children:  <Widget>[
                                  Container(
                                      margin: const EdgeInsets.only(left: 125,top:125),
                                      child:IconButton(padding: EdgeInsets.all(2),onPressed: openCamera, icon: Icon(Icons.add_a_photo_outlined), iconSize: 42,
                                        color: Colors.black,)),]

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
                                child: ClipOval(
                                  child: widget.dish.imageFile==null? Image.network(remoteString.data, fit: BoxFit.fill):
                                  Image.file(widget.dish.imageFile),)),

                            Stack(
                                children:  <Widget>[
                                  Container(
                                      margin: const EdgeInsets.only(left: 125,top:125),
                                      child:IconButton(padding: EdgeInsets.all(2),onPressed: openCamera, icon: Icon(Icons.add_a_photo_outlined), iconSize: 42,
                                        color: Colors.black,)),]

                            )
                          ])

                  ));
                }
              }
              else {
                return CircularProgressIndicator();
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
                      width: 200,
                      height: 200,
                      child:  ClipOval(
                          child: Image(
                            image: AssetImage("images/Dishes/" + widget.dish.id + ".png"),
                          )
                      ));
                }
              } else{
                return CircularProgressIndicator();
              }
            }
        ),

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
                    leading: Container(
                        width: 50,
                        height: 50,
                        child:  ClipOval(
                            child: Image(
                              image: AssetImage("images/ingredients/" + ingredientStore.ingredientListOfDish[index].id + ".png"),
                            )
                        )),

                  ),
                );
              }
          ))
      ),

    ]

      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () {

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


          },
          child: Icon(Icons.add , color:  Colors.white ),
          backgroundColor:  Colors.green
      ),

    );
  }
}

