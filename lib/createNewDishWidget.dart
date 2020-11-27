import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'Models/foodStore.dart';
import 'Models/ingredientStore.dart';
import 'Database/Dish.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'Database/Ingredient.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class AddDishForm extends StatefulWidget {
  @override
  _AddDishFormState createState() => _AddDishFormState();
}

class _AddDishFormState extends State<AddDishForm>{
  final nameCt = TextEditingController();
  final categoryCt = TextEditingController();
  final ingredientsCt = TextEditingController();
  final ingredientsQty = TextEditingController();
  final ingredSelected = TextEditingController();
  final quantitySelected = TextEditingController();


  String id;  //TODO Dovrebbe prendere l' id nel database piu alto e fare Dish_+1

  List<String> quantity = ["poco", "medio", "abbondante"];

  final List<String> ingredientsSelectedList = new List<String>();
  List listOfIngredient(){
    return context.read<IngredientStore>().getIngredients();
  }
  void addIngredientsToListView(String value){
    ingredientsSelectedList.add(value);
  }

  void addDish(){

    Random random = new Random();
    int randomNumber = random.nextInt(100);
    Dish dish = new Dish(
        id:"Dish_"+randomNumber.toString(),
        name:nameCt.text,
        category: categoryCt.text
    );

    List<Ingredient> ingredients = new List<Ingredient>();
    ingredients.add(new Ingredient(id:"Ingr_1",name: ingredientsCt.text, qty: ingredientsQty.text));
    ingredients.add(new Ingredient(id:"Ingr_2",name: "cacao", qty: "3"));

    context.read<FoodStore>().addNewDishCreatedByUser(dish, ingredients);


  }

  Map<String, dynamic> formData;


  String selectIngredient = "";  //by default we are not providing any of the cities
  String selectQuantity = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create New Dish"),
        ),
        body: Observer(builder: (_) =>Column(

                        children: <Widget>[
                          TextField(
                            controller: nameCt,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                            ),
                          ),
                          TextField(
                            controller: categoryCt,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Category',
                            ),
                          ),
                          DropDownField(
                            controller: ingredSelected,
                            hintText: "Select an ingredient",
                            enabled: true,
                            itemsVisibleInDropdown: 3,
                            items: listOfIngredient(),
                            strict: false,
                            onValueChanged: (value){
                              setState(() {
                                selectIngredient = value;
                                addIngredientsToListView(value);
                              });
                            } ,

                          ),
                          Expanded(
                              child: ListView.builder(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: ingredientsSelectedList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      height: 50,
                                      margin: EdgeInsets.all(2),
                                      color: Colors.blue[400],
                                      child: Center(
                                          child: Text('${ingredientsSelectedList[index]}',
                                            style: TextStyle(fontSize: 18),
                                          )
                                      ),
                                    );
                                  }
                              )
                          ),
                          RaisedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(selectIngredient,
                                          style: TextStyle(fontSize: 20.0),
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: [
                                          //la quantità selezionata dovrà essere salvata
                                          FlatButton(onPressed: null, child:Text("ok")),
                                        ],
                                        content: Stack(
                                          overflow: Overflow.visible,
                                          children: <Widget>[
                                            Positioned(
                                              right: -40.0,
                                              top: -40.0,
                                              child: InkResponse(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: CircleAvatar(
                                                  child: Icon(Icons.close),
                                                  backgroundColor: Colors.red,
                                                ),
                                              ),
                                            ),
                                            DropDownField(
                                              controller: ingredientsQty,
                                              hintText: "Select quantity",
                                              enabled: true,
                                              itemsVisibleInDropdown: 3,
                                              items: quantity,
                                              strict: false,
                                              onValueChanged: (value){
                                                setState(() {
                                                  selectQuantity = value;
                                                });
                                              } ,

                                            ),

                                          ],

                                        ),
                                      );
                                    });
                              }),




            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  //addDish();

                  // Validate returns true if the form is valid, or false
                  // otherwise.
                },
                child: Text('Add Dish'),
              ),
            ),

          ],
        )
        )
    );
  }
}