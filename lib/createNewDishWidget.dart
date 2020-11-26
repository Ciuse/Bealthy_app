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

class AddDishForm extends StatefulWidget {
  @override
  _AddDishFormState createState() => _AddDishFormState();
}

class _AddDishFormState extends State<AddDishForm>{
  final nameCt = TextEditingController();
  final categoryCt = TextEditingController();
  final ingredientsCt = TextEditingController();
  final ingredientsQty = TextEditingController();
  final citySelected = TextEditingController();

  String id;  //TODO Dovrebbe prendere l' id nel database piu alto e fare Dish_+1



  List listOfIngredient(){
    return context.read<IngredientStore>().getIngredients();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create New Dish"),
        ),
        body: Column(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal:10,vertical: 16.0),
                child: Observer(builder: (_) =>
                Column(

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
                        controller: citySelected,
                        hintText: "Select an ingredient",
                        enabled: true,
                        itemsVisibleInDropdown: 1,
                        items: listOfIngredient(),
                        strict: false,
                        onValueChanged: (value){
                          setState(() {
                            selectIngredient = value;
                          });
                        } ,
                      ),

                      SizedBox(height: 20.0,),
                      Text(selectIngredient,
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center,
                      )
                    ]
                ),
                )
            ),
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
    );
  }
}