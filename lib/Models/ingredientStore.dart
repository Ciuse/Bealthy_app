import 'dart:async';
import 'package:Bealthy_app/Database/dish.dart';
import 'package:Bealthy_app/Database/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Include generated file
part 'ingredientStore.g.dart';


FirebaseAuth auth = FirebaseAuth.instance;

// This is the class used by rest of your codebase
class IngredientStore = _IngredientStoreBase with _$IngredientStore;

// The store-class
abstract class _IngredientStoreBase with Store {
  final firestoreInstance = FirebaseFirestore.instance;

  bool storeInitialized = false;

  @observable
  var ingredientList = new ObservableList<Ingredient>();




  @observable
  var ingredientListOfDish = new ObservableList<Ingredient>();

  @observable
  var mapIngredientDish = new ObservableMap<Dish,List<Ingredient>>();


  @observable
  var ingredientsName = new ObservableList<String>();

  @observable
  ObservableFuture loadInitIngredientList;

  Map colorIngredientMap = new Map<String , Color>();

  @action
  Future<void> waitForIngredients() {
    return loadInitIngredientList = ObservableFuture(getIngredients());
  }
  @action
  Future<void> retryForIngredients() {
    return loadInitIngredientList = ObservableFuture(getIngredients());
  }
  @action
  Future<void> initStore() async {
    if(!storeInitialized) {
      await getIngredients().then((value) => initializeColorMap());
      storeInitialized=true;
    }
  }

  @action
  Ingredient returnIngredientFromId(String ingredientId){
    Ingredient toReturn= new Ingredient();
    ingredientList.forEach((element) {
      if(element.id==ingredientId){
        toReturn=element;
      }
    });
    return toReturn;
  }

  @action
  Future<void> getIngredients() async {
    await (FirebaseFirestore.instance
        .collection('Ingredients').orderBy("name")
        .get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Ingredient i = new Ingredient(id:result.id,name:result.get("name"),it_Name:result.get("it_Name"), qty: "" );
        ingredientList.add(i);
      }
      );
    }));
  }


  @action
  Future<void> getIngredientsFromDatabaseDish(Dish dish) async {
    await (FirebaseFirestore.instance
        .collection('Dishes').doc(dish.id).collection("Ingredients").orderBy("name")
        .get().then((querySnapshot) {
      querySnapshot.docs.forEach((ingredient) {
        Ingredient i = new Ingredient(id:ingredient.id,name:ingredient.get("name"),qty:ingredient.get("qty") );
        ingredientListOfDish.add(i);
      }
      );
    }));
  }

  @action
  Future<void> getIngredientsFromUserDish(Dish dish) async {
    if(auth.currentUser!=null){
      await (FirebaseFirestore.instance
          .collection("DishesCreatedByUsers")
          .doc(auth.currentUser.uid)
          .collection("Dishes").doc(dish.id).collection("Ingredients").orderBy("name")
          .get().then((querySnapshot) {
        querySnapshot.docs.forEach((ingredient) {
          print(ingredient.data());
          Ingredient i = new Ingredient(id:ingredient.id,name:ingredient.get("name"),qty:ingredient.get("qty") );
          ingredientListOfDish.add(i);

        }
        );
      }));
    }

  }

  @action
  Future<String> getIngredientsStringFromDatabaseDish(Dish dish) async {
    return await (FirebaseFirestore.instance
        .collection('Dishes').doc(dish.id).collection("Ingredients").orderBy("name")
        .get().then((querySnapshot) {
      String ingredients="";
      querySnapshot.docs.forEach((ingredient) {
        Ingredient i = new Ingredient(id:ingredient.id,name:ingredient.get("name"),qty:ingredient.get("qty") );
        ingredients = ingredients+ i.name;
        ingredients = ingredients+ ", ";
      }
      );
      return ingredients;
    }));
  }


  @action
  Future<String> getIngredientsStringFromUserDish(Dish dish) async {

    return await (FirebaseFirestore.instance
        .collection("DishesCreatedByUsers")
        .doc(auth.currentUser.uid)
        .collection("Dishes").doc(dish.id).collection("Ingredients").orderBy("name")
        .get().then((querySnapshot) {
      String ingredients="";
      querySnapshot.docs.forEach((ingredient) {

        Ingredient i = new Ingredient(id:ingredient.id,name:ingredient.get("name"),qty:ingredient.get("qty") );
        ingredients = ingredients+ i.name;
        ingredients =  ingredients+", ";
      }
      );
      return ingredients;
    }
    ));

  }


  @action
  Future<void> getIngredientsName() async {
    ingredientList.forEach((element) {
      ingredientsName.add(element.name);
    });
  }

  @action
  String getIngredientIdFromName (String ingredientName) {
    String id;
     ingredientList.forEach((element) {
      if(element.name.compareTo(ingredientName)==0){
        id=element.id;
        return;
      }
    });

    return id;
  }


  @action
  Ingredient getIngredientFromName (String ingredientName) {
    Ingredient ingredient;
    ingredientList.forEach((element) {
      if(element.name.compareTo(ingredientName)==0){
        ingredient=new Ingredient(id:element.id,name: element.name, qty: "");
        return;
      }
    });
    return ingredient;
  }

  @action
  Ingredient getIngredientFromList(String ingredientId){
    Ingredient ingredient;
    ingredientList.forEach((element) {
      if(element.id.compareTo(ingredientId)==0){
        ingredient = element;
      }
    });
    if (ingredient==null){
      print("Errore nel codice dato");
    }
    return ingredient;
  }

  void initializeColorMap(){
    List<String> keys = new List<String>();
    ingredientList.forEach((element) {
      keys.add(element.id);
    });

    List<Color> colorsOfChart = [
      Color(0xff90caf9),
      Color(0xff81c784),
      Color(0xfffff176),
      Color(0xfff9a825),
      Color(0xff40241a),
      Color(0xff8b6b61),
      Color(0xff9e9e9e),
      Color(0xfffdd835),
      Color(0xffffeb3b),
      Color(0xff5d99c6),
      Color(0xffffd699),
      Color(0xffc1d5e0),
      Color(0xffffff72),
      Color(0xff42a5f5),
      Color(0xff33691e),
      Color(0xffaed581),
      Color(0xffc67c00),
      Color(0xffff6d00),
      Color(0xff255d00),
      Color(0xffffd600),
      Color(0xffa7c0cd),
      Color(0xff00c853),
      Color(0xff9be7ff),
      Color(0xffc3fdff),
      Color(0xfff57f17),
      Color(0xffbc5100),
      Color(0xffff3d00),
      Color(0xffb0bec5),
      Color(0xffac0800),
      Color(0xffa30000),
      Color(0xfffbc02d),
    ];


    // I/flutter (28496): Anchovy -
    // I/flutter (28496): Basil -
    // I/flutter (28496): Butter -
    // I/flutter (28496): Chicken -
    // I/flutter (28496): Chocolate -
    // I/flutter (28496): Cocoa -
    // I/flutter (28496): Coconut -
    // I/flutter (28496): Corn -
    // I/flutter (28496): Egg -
    // I/flutter (28496): Fish -
    // I/flutter (28496): Flour -
    // I/flutter (28496): Garlic -
    // I/flutter (28496): Lemon -
    // I/flutter (28496): Milk -
    // I/flutter (28496): Nuts -
    // I/flutter (28496): Oil -
    // I/flutter (28496): Pasta -
    // I/flutter (28496): Peach -
    // I/flutter (28496): Pear -
    // I/flutter (28496): Potato -
    // I/flutter (28496): Rice -
    // I/flutter (28496): Salad -
    // I/flutter (28496): Salt -
    // I/flutter (28496): Shellfish -
    // I/flutter (28496): Shrimps -
    // I/flutter (28496): Soy -
    // I/flutter (28496): Strawberry -
    // I/flutter (28496): Sugar -
    // I/flutter (28496): Tomato -
    // I/flutter (28496): Vinegar -
    // I/flutter (28496): Wheat -

    colorIngredientMap=Map.fromIterables(keys, colorsOfChart);
  }


}


