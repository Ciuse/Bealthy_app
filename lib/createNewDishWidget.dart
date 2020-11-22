import 'package:flutter/material.dart';
import 'Models/foodStore.dart';
import 'Database/Dish.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'Database/Ingredient.dart';

class AddDishForm extends StatefulWidget {
  @override
  _AddDishFormState createState() => _AddDishFormState();
}

class _AddDishFormState extends State<AddDishForm>{
  final nameCt = TextEditingController();
  final categoryCt = TextEditingController();
  final ingredientsCt = TextEditingController();
  final ingredientsQty = TextEditingController();

  String id;  //TODO Dovrebbe prendere l' id nel database piu alto e fare Dish_+1

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
                child:
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
                      TextField(
                        controller: ingredientsCt,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Ingredients',
                        ),
                      ),
                      TextField(
                        controller: ingredientsQty,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'IngredientsQty',
                        ),
                      ),
                    ]
                )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  addDish();
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