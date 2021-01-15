import 'dart:io';
import 'dart:ui';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:Bealthy_app/uploadNewPictureToUserDish.dart';
import 'package:camera/camera.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'Database/dish.dart';
import 'Database/ingredient.dart';
import 'Models/foodStore.dart';
import 'Models/ingredientStore.dart';
import 'Database/enumerators.dart';

class CreateNewDish extends StatefulWidget {
  @override
  _CreateNewDishState createState() => _CreateNewDishState();
}

class _CreateNewDishState extends State<CreateNewDish> {

  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;

  final nameCt = TextEditingController();
  final ingredientsCt = TextEditingController();
  final ingredientsQty = TextEditingController();
  final ingredientSelected = TextEditingController();
  final quantitySelected = TextEditingController();


  String id;  //TODO Dovrebbe prendere l' id nel database piu alto e fare Dish_+1

  List<String> quantityList = [];




  String selectIngredient = "";  //by default we are not providing any of the ingredients

  List<String> ingredientsSelectedList = new List<String>();
  List<String> ingredientsQuantityList = new List<String>();
  IngredientStore ingredientStore;
  FoodStore foodStore;
  List<CameraDescription> cameras;
  Dish dish = new Dish();

  @override
  void initState() {
    super.initState();
    initializeCameras();
    ingredientStore = Provider.of<IngredientStore>(context, listen: false);
    foodStore = Provider.of<FoodStore>(context, listen: false);
    getLastNumber().then((value) =>dish.id="Dish_User_" + dish.number.toString());
    quantityList= getQuantityName();
    ingredientStore.ingredientsName.clear();
    ingredientStore.getIngredientsName();
  }

  Future<void> getLastNumber() async {
    dish.number = await foodStore.getLastCreatedDishId();
  }

  @override
  void dispose() {
    super.dispose();
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

  void addIngredientsToListView(String value){
    ingredientsSelectedList.add(value);
    ingredientsQuantityList.add("");
  }

  void addDishToUser() {
    if (nameCt.text != "" && ingredientsSelectedList.length>0 &&
        ingredientsQuantityList.length==ingredientsSelectedList.length) {
      dish.name=nameCt.text;

      List<Ingredient> ingredients = new List<Ingredient>();

      for (int i = 0; i < ingredientsSelectedList.length; i++) {
        Ingredient ingredient =
        new Ingredient(
            id: ingredientStore.getIngredientIdFromName(
                ingredientsSelectedList[i]),
            name: ingredientsSelectedList[i],
            qty: ingredientsQuantityList[i]);
        ingredients.add(ingredient);
      }
      foodStore.addNewDishCreatedByUser(dish, ingredients);
      if(dish.imageFile!=null){
        uploadImageToFirebase(dish.imageFile);
      }
      Navigator.pop(context);
    }
  }

  Future uploadImageToFirebase(File imageFile) async {
    String userUid;
    final litUser = context.getSignedInUser();
    litUser.when(
          (user) => userUid=user.uid,
      empty: () => Text('Not signed in'),
      initializing: () => Text('Loading'),
    );
    String fileName = dish.id+".jpg";
    var firebaseStorageRef = FirebaseStorage.instance.ref().child(userUid+'/DishImage/$fileName');
    firebaseStorageRef.putFile(imageFile);
  }

  openCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadNewPictureToUserDish(camera: cameras.first,dish: dish,uploadingOnFirebase: false,),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final ingredientStore = Provider.of<IngredientStore>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Create New Dish"),
        ),
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
            reverse: true,
            child: Padding(
                padding: EdgeInsets.only(bottom: bottom),
                child:Observer(builder: (_) =>
                    Column(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            child: Observer(builder: (_) =>Container(
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
                                            child: dish.imageFile==null? null:
                                            Image.file(dish.imageFile),
                                          )
                                      ),

                                      Stack(
                                          children:  <Widget>[
                                            Container(
                                                margin: const EdgeInsets.only(left: 125,top:125),
                                                child:IconButton(padding: EdgeInsets.all(2),onPressed: openCamera, icon: Icon(Icons.add_a_photo_outlined), iconSize: 42,
                                                  color: Colors.black,)),]

                                      )
                                    ])

                            )),
                          ),


                          TextField(
                            controller: nameCt,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                          ),

                          DropDownField(

                            controller: ingredientSelected,
                            hintText: "Select an ingredient",
                            enabled: true,
                            itemsVisibleInDropdown: 3,
                            items: ingredientStore.ingredientsName,
                            strict: false,
                            onValueChanged: (value){
                              setState(() {
                                FocusScopeNode currentFocus = FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }

                                selectIngredient = value;
                                addIngredientsToListView(value);
                                ingredientStore.ingredientsName.remove(value);
                                ingredientSelected.clear();

                              });
                            } ,

                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),

                          ),

                          Container(
                            height: ingredientsSelectedList.length >= 3 ? MediaQuery.of(context).size.height/4 : null,
                            child:
                            ListView.separated(
                                separatorBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 10,
                                  );
                                },
                                shrinkWrap: true,
                                itemCount: ingredientsSelectedList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Dismissible(
                                    key: Key(ingredientsSelectedList[index]),
                                    background: Container(
                                      alignment: AlignmentDirectional.centerEnd,
                                      color: Colors.red,
                                      child: Icon(Icons.delete, color: Colors.white),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Flexible(
                                          flex:1,
                                          fit: FlexFit.tight,

                                          child:
                                          new Text('${ingredientsSelectedList[index]}',
                                              style: TextStyle(fontSize: 18)),
                                        ),
                                        Flexible(
                                            fit: FlexFit.loose,
                                            flex:2,
                                            child:
                                            new DropDownField(
                                              hintText: "Select a quantity",
                                              enabled: true,
                                              itemsVisibleInDropdown: 3,
                                              items: quantityList,
                                              strict: false,
                                              value: (ingredientsQuantityList[index]!="") ? ingredientsQuantityList[index]: null,
                                              onValueChanged: (value){
                                                setState(() {

                                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                                  if (!currentFocus.hasPrimaryFocus) {
                                                    currentFocus.unfocus();
                                                  }

                                                  ingredientsQuantityList[index]=value;
                                                });
                                              } ,

                                            )),
                                      ],),
                                    onDismissed: (direction){
                                      setState(() {
                                        FocusScopeNode currentFocus = FocusScope.of(context);

                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        ingredientsSelectedList.removeAt(index);
                                        ingredientsQuantityList.removeAt(index);
                                      });
                                    },
                                  );
                                }
                            )
                            ,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                addDishToUser();
                              },
                              child: Text('Create'),
                            ),
                          ),
                        ]) ,
                )
            )
        ));

  }
}