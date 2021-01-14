import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:Bealthy_app/uploadNewPictureToUserDish.dart';
import 'package:camera/camera.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
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

  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;

  final nameCt = TextEditingController();
  final categoryCt = TextEditingController();
  final ingredientsCt = TextEditingController();
  final ingredientsQty = TextEditingController();
  final ingredientSelected = TextEditingController();
  final quantitySelected = TextEditingController();

  ScrollController _controller;

  String id;  //TODO Dovrebbe prendere l' id nel database piu alto e fare Dish_+1

  List<String> quantityList = [];
  List<String> categoryList = [];

  String categoryDishCreated = "";

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
    _keyboardState = _keyboardVisibility.isKeyboardVisible;
    _controller = ScrollController();

    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardState = visible;
          print(_keyboardState);
          // if(visible==true)
          // _controller.jumpTo(_controller.offset + 100);
        });
      },
    );
    categoryList= getCategoryName();
    quantityList= getQuantityName();
    ingredientStore.ingredientsName.clear();
    ingredientStore.getIngredientsName();
  }

  Future<void> getLastNumber() async {
    dish.number = await foodStore.getLastCreatedDishId();
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
    super.dispose();
  }

  Future<void> initializeCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();

  }

  List<String> getCategoryName(){

    List<String> listToReturn = new List<String>();
    Category.values.forEach((element) {
      listToReturn.add(element.toString().split('.').last);
    });
    return listToReturn;
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
    if (nameCt.text != "" && categoryDishCreated != "" && ingredientsSelectedList.length>0 &&
        ingredientsQuantityList.length==ingredientsSelectedList.length) {
      dish.name=nameCt.text;
      dish.category=categoryDishCreated;

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

  void uploadImageToFirebase(File imageFile) {

      String fileName = "Dish_User_" + dish.number.toString()+".jpg";
      var firebaseStorageRef = FirebaseStorage.instance.ref().child('DishImage/$fileName');
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
    final ingredientStore = Provider.of<IngredientStore>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Create New Dish"),
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          controller: _controller,
        child:Observer(builder: (_) =>Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[   Flexible(
              child:

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
              controller: categoryCt,
              hintText: "Select Category",
              enabled: true,
              itemsVisibleInDropdown: 3,
              items: categoryList,

              strict: false,
              onValueChanged: (value){
                setState(() {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  categoryDishCreated = value;

                });
              } ,

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

          Divider(height: 30, color: Colors.black,),
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
        ]) )],
        )
        )
        ));

  }
}