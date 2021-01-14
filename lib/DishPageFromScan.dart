import 'package:Bealthy_app/Database/ingredient.dart';
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
import 'Models/barCodeScannerStore.dart';
import 'Models/foodStore.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as OFF;
import 'package:camera/camera.dart';
import 'uploadNewPictureToUserDish.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';


class DishPageFromScan extends StatefulWidget {

  final String urlImage;
  final OFF.Product product;
  Dish dish;
  DishPageFromScan({@required this.urlImage,@required this.product });

  @override
  _DishPageFromScanState createState() => _DishPageFromScanState();
}

class _DishPageFromScanState extends State<DishPageFromScan>{
  var storage = FirebaseStorage.instance;
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  List<String> quantityList;
  IngredientStore ingredientStore;
  BarCodeScannerStore barCodeScannerStore;
  FoodStore foodStore;



  void initState() {
    super.initState();
    quantityList= getQuantityName();
    widget.dish = new Dish(name: widget.product.productName);
    ingredientStore = Provider.of<IngredientStore>(context, listen: false);
    barCodeScannerStore = Provider.of<BarCodeScannerStore>(context, listen: false);
    foodStore = Provider.of<FoodStore>(context, listen: false);
    ingredientStore.ingredientListOfDish.clear();
    ingredientStore.getIngredientsFromUserDish(widget.dish);
    getLastNumber().then((value) =>widget.dish.id="Dish_User_" + widget.dish.number.toString());
    getImageFileDish();
    getIngredients();
  }

  Future<void> getLastNumber() async {
    widget.dish.number = await foodStore.getLastCreatedDishId();
  }

  Future<void> getImageFileDish() async {
    widget.dish.imageFile = await barCodeScannerStore.urlToFile(widget.urlImage);
  }

  Future<void> getIngredients() async {
     await barCodeScannerStore.getIngredients(widget.product,ingredientStore, foodStore);
  }


  List<String> getQuantityName(){
    List<String> listToReturn = new List<String>();
    Quantity.values.forEach((element) {
      listToReturn.add(element.toString().split('.').last);
    });
    return listToReturn;
  }



  void setQuantityAndMealTimeToDish(String qty){
    MealTimeStore mealTimeStore = Provider.of<MealTimeStore>(context, listen: false);
    widget.dish.mealTime = mealTimeStore.selectedMealTime.toString().split('.').last;
    widget.dish.qty = qty;
  }

void openCamera(){

}

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        title: Text(widget.dish.name),
      ),
      body: Container(child:
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
                              child: widget.dish.imageFile==null? null:
                              Image.file(widget.dish.imageFile),
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
            ingredientsWidget(),
          ]
      )),

    );
  }

  Widget ingredientsWidget(){
    return Container(
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
              ListTile(
                title: Text("Ingredients:",style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
                leading: Icon(Icons.fastfood_outlined,color: Colors.black),
              ),
    Observer(builder: (_) =>ListView.builder
                (
                   scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: barCodeScannerStore.ingredients.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10, bottom: 6, top:6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex:1,
                                  child: Container(
                                      width: 35,
                                      height: 35,
                                      child:  ClipOval(
                                          child: Image(
                                            image: AssetImage("images/ingredients/" + barCodeScannerStore.ingredients[index].id + ".png"),
                                          )
                                      )))
                              ,
                              Expanded(
                                  flex:5,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20,right: 10,),
                                    child: Text(barCodeScannerStore.ingredients[index].name),
                                  ))

                            ],

                          ),
                        ),
                        index!=barCodeScannerStore.ingredients.length-1?
                        Divider(
                          thickness: 0.5,
                          indent: 10,
                          endIndent: 10,
                          color: Colors.black,
                        ):Container(),
                      ],
                    );
                  }
              ))
            ]
        ));
  }
}
