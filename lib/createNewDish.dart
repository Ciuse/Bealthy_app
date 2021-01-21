import 'dart:io';
import 'dart:ui';
import 'package:Bealthy_app/dishPage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:Bealthy_app/uploadNewPictureToUserDish.dart';
import 'package:camera/camera.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'Database/dish.dart';
import 'Database/ingredient.dart';
import 'Login/config/palette.dart';
import 'Models/dateStore.dart';
import 'Models/foodStore.dart';
import 'Models/ingredientStore.dart';
import 'Database/enumerators.dart';
import 'Models/mealTimeStore.dart';

class CreateNewDish extends StatefulWidget {
  @override
  _CreateNewDishState createState() => _CreateNewDishState();
}

class _CreateNewDishState extends State<CreateNewDish> {
  Dish dish = new Dish();
  IngredientStore ingredientStore;
  FoodStore foodStore;
  List<CameraDescription> cameras;
  List<String> quantityList = [];
  String selectedItemIngredient="";
  final nameCt = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initializeCameras();
    ingredientStore = Provider.of<IngredientStore>(context, listen: false);
    foodStore = Provider.of<FoodStore>(context, listen: false);
    getLastNumber().then((value) =>dish.id="Dish_User_" + dish.number.toString());
    quantityList= getQuantityName();
    ingredientStore.ingredientListOfDish.clear();
    ingredientStore.ingredientsName.clear();
    ingredientStore.getIngredientsName();
    //loadDefaultImage("images/defaultImageProfile.png");
  }

  Future<void> loadDefaultImage(String path) async{
    dish.imageFile = await getImageFileFromAssets(path);
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }


  Future<void> getLastNumber() async {
    dish.number = await foodStore.getLastCreatedDishId();
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

  }

  void addDishToUser() {
    dish.name=nameCt.text;
    foodStore.addNewDishCreatedByUser(dish, ingredientStore.ingredientListOfDish,ingredientStore);
    if(dish.imageFile!=null){
      uploadImageToFirebase(dish.imageFile);
    }
  }

  void setQuantityAndMealTimeToDish(String qty,MealTimeStore mealTimeStore){
    dish.mealTime = mealTimeStore.selectedMealTime.toString().split('.').last;
    dish.qty = qty;
  }

  @override
  Widget build(BuildContext context) {
    MealTimeStore mealTimeStore = Provider.of<MealTimeStore>(context);
    DateStore dateStore = Provider.of<DateStore>(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final ingredientStore = Provider.of<IngredientStore>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Dish"),
        ),
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
            reverse: true,
            child:
    Form(
        key: this._formKey,
    child:Padding(
                padding: EdgeInsets.only(top:8,right:8,left:8,bottom: bottom),
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
                                          color: Palette.bealthyColorScheme.primaryVariant,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: dish.imageFile==null? null:
                                        Image.file(dish.imageFile, fit:BoxFit.cover),
                                      )
                                  ),

                                  Stack(
                                      children:  <Widget>[
                                        Container(
                                            margin: const EdgeInsets.only(left: 125,top:125),
                                            child:IconButton(padding: EdgeInsets.all(2),onPressed: openCamera, icon: Icon(Icons.add_a_photo_outlined), iconSize: 42,
                                              color: Palette.bealthyColorScheme.secondary)),]

                                  )
                                ])

                        )),
                      ),

                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 25,
                        controller: nameCt,
                        decoration: new InputDecoration(
                          labelText: 'Name',
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                          //fillColor: Colors.green
                        ),
                        validator: (val) {
                          if(val.length==0) {
                            return "Name cannot be empty";
                          }else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      SizedBox(height: 20,),
                      DropdownSearch<String>(
                        mode: Mode.MENU,
                        dropdownSearchDecoration:  new InputDecoration(
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(10),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                          //fillColor: Colors.green
                        ),
                        //  showSearchBox: true,
                        items: ingredientStore.ingredientsName,
                        label: "Select ingredient",
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        validator:  (val) {
                          if(ingredientStore.ingredientListOfDish.length==0) {
                            return "Insert at least one ingredient";
                          }else{
                            return null;
                          }
                        },
                        onChanged: (String ingredient) {
                          selectedItemIngredient="";
                          ingredientStore.ingredientListOfDish.add(ingredientStore.getIngredientFromName(ingredient));
                          ingredientStore.ingredientsName.remove(ingredient);

                        },
                      ),
                      Padding(padding: EdgeInsets.all(10)),

                      Observer(builder: (_) =>ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 10,
                            );
                          },
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: ingredientStore.ingredientListOfDish.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              key: Key(ingredientStore.ingredientListOfDish[index].id),
                              background: Container(
                                alignment: AlignmentDirectional.centerEnd,
                                color: Palette.bealthyColorScheme.error,
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              child: ingredient(ingredientStore.ingredientListOfDish[index], index),
                              onDismissed: (direction){
                                ingredientStore.ingredientsName.add(ingredientStore.ingredientListOfDish[index].name);
                                ingredientStore.ingredientListOfDish.removeAt(index);
                              },
                            );
                          }
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (this._formKey.currentState.validate()) {
                              return showDialog(
                                barrierDismissible: false,
                                  context: context,
                                  builder: (_) =>
                                  new AlertDialog(
                                    title: Text('Are you sure to create it?'),
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
                                          addDishToUser();
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>
                                                DishPage(dish: dish, createdByUser: true,)),
                                          );
                                        },
                                        child: Text('ACCEPT'),
                                      ),
                                    ],
                                  )
                              );
                            }
                          },
                          child: Text('Create'),
                        ),
                      ),
                    ]

                )
            )
        )
    )
    );
  }

  Widget ingredient(Ingredient ingredient, int index){
    return Observer(builder: (_) =>Column(
      children: [
        Container(
            child:
            ListTile(
              title: Text(ingredient.name),
              subtitle:Text(ingredient.qty),
              leading: Image(image:AssetImage("images/ingredients/" + ingredient.id + ".png"), height: 40,width:40,),
              trailing:
              Container(
                  width: 140,
                  child:DropdownSearch<String>(
                      key: Key(ingredient.id),
                      items: quantityList,
                      label: "Quantity",
                      popupTitle:Padding(
                          padding: EdgeInsets.all(16),
                          child:Text("Select ingredient quantity",textAlign: TextAlign.center,)),
                      maxHeight:230,
                      dialogMaxWidth:200,
                      showSelectedItem: true,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator:  (val) {
                        if(val==null) {
                          return "Empty Quantity";
                        }else{
                          return null;
                        }
                      },
                      onChanged: (String quantity) {
                        ingredient.qty=quantity;
                      }
                  )),
            )),
        index!=ingredientStore.ingredientListOfDish.length-1?
        Divider(
          height: 4,
          thickness: 0.5,
          indent: 20,
          endIndent: 20,
          color: Colors.black38,
        ):Container(),
      ],
    ));
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

}
