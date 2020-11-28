import 'dart:math';

import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'Database/Dish.dart';
import 'Database/Ingredient.dart';
import 'Models/foodStore.dart';
import 'Models/ingredientStore.dart';

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

  List<String> quantityList = ["poco", "medio", "abbondante"];



  final List<String> ingredientsSelectedList = new List<String>();
  List listOfIngredient(){
    return context.read<IngredientStore>().getIngredients();
  }

  void addIngredientsToListView(String value){
    ingredientsSelectedList.add(value);
  }

  void addDishToUser(){
    Random random = new Random();
    int randomNumber = random.nextInt(100);
    Dish dish = new Dish(
        id:"Dish_"+randomNumber.toString(),
        name:nameCt.text,
        category: categoryCt.text
    );
    List<Ingredient> ingredients = new List<Ingredient>();

    for(int i=0;i< ingredientsSelectedList.length;i++){
      Random random = new Random();
      int randomNumber = random.nextInt(100);
      Ingredient ingredient = new Ingredient(id:"Ingredient_"+randomNumber.toString(),name:ingredientsSelectedList[i], qty:selectQuantity[i]);
      ingredients.add(ingredient);
    }


    print(dish.category);
    print(dish.name);
    print(dish.id);
    print(ingredients);
    context.read<FoodStore>().addNewDishCreatedByUser(dish, ingredients);
  }

  String selectIngredient = "";  //by default we are not providing any of the cities
  List<String> selectQuantity = new List<String>();

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
                      return Dismissible(
                        key: Key(ingredientsSelectedList[index]),
                        background: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction){
                          setState(() {
                            ingredientsSelectedList.removeAt(index);
                          });
                        },
                        child: new Column(
                          children: <Widget>[
                            new Text('${ingredientsSelectedList[index]}',
                                style: TextStyle(fontSize: 18)),
                            new DropDownField(
                              hintText: "Select a quantity",
                              enabled: true,
                              itemsVisibleInDropdown: 3,
                              items: quantityList,
                              strict: false,
                              onValueChanged: (value){
                                setState(() {
                                  selectQuantity.add(value);
                                  print(index);
                                });
                              } ,

                            ),
                          ],),

                      );
                    }
                )
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  addDishToUser();
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