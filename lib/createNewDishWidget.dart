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
  final ingredientSelected = TextEditingController();
  final quantitySelected = TextEditingController();


  String id;  //TODO Dovrebbe prendere l' id nel database piu alto e fare Dish_+1

  List<String> quantityList = [];
  List<String> categoryList = [];

  @override
  void initState() {
    categoryList= getCategoryName();
    quantityList= getQuantityName();
    super.initState();
    var store = Provider.of<IngredientStore>(context, listen: false);
    store.initStore();
    store.ingredientsName.clear();
    store.getIngredientsName();
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

  String categoryDishCreated = "";
  final List<String> ingredientsSelectedList = new List<String>();

  void addIngredientsToListView(String value){
    ingredientsSelectedList.add(value);
    ingredientsQuantityList.add("");
  }

  void addDishToUser(){
    Random random = new Random();
    int randomNumber = random.nextInt(100);
    Dish dish = new Dish(
        id:"Dish_User_"+randomNumber.toString(),
        name:nameCt.text,
        category: categoryDishCreated
    );
    List<Ingredient> ingredients = new List<Ingredient>();

    for(int i=0;i< ingredientsSelectedList.length;i++){
      Ingredient ingredient =
      new Ingredient(id:context.read<IngredientStore>().getIngredientIdFromName(ingredientsSelectedList[i]),
          name:ingredientsSelectedList[i],
          qty:ingredientsQuantityList[i]);
      ingredients.add(ingredient);
    }

    context.read<FoodStore>().addNewDishCreatedByUser(dish, ingredients);

    Navigator.pop(context);
  }

  String selectIngredient = "";  //by default we are not providing any of the ingredients
  List<String> ingredientsQuantityList = new List<String>();

  @override
  Widget build(BuildContext context) {
    final ingredientStore = Provider.of<IngredientStore>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Create New Dish"),
        ),
        body: Observer(builder: (_) => Column(

          children: <Widget>[
            TextField(
              controller: nameCt,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
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
                  ingredientSelected.clear();

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
                                  FocusScopeNode currentFocus = FocusScope.of(context);

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  ingredientsQuantityList[index]=value;
                                  print(ingredientsQuantityList);
                                });
                              } ,

                            ),
                          ],),
                        onDismissed: (direction){
                          setState(() {
                            FocusScopeNode currentFocus = FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            ingredientsSelectedList.removeAt(index);
                            ingredientsQuantityList.removeAt(index);
                            print(ingredientsQuantityList);
                          });
                        },
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