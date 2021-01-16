import 'dart:async';
import 'dart:io';
import 'package:Bealthy_app/Database/dish.dart';
import 'package:Bealthy_app/Database/ingredient.dart';
import 'package:Bealthy_app/Database/fileImageDish.dart';
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
  Future<void> getIngredients() async {
    await (FirebaseFirestore.instance
        .collection('Ingredients')
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
        .collection('Dishes').doc(dish.id).collection("Ingredients")
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
    await (FirebaseFirestore.instance
        .collection("DishesCreatedByUsers")
        .doc(auth.currentUser.uid)
        .collection("Dishes").doc(dish.id).collection("Ingredients")
        .get().then((querySnapshot) {
      querySnapshot.docs.forEach((ingredient) {
        Ingredient i = new Ingredient(id:ingredient.id,name:ingredient.get("name"),qty:ingredient.get("qty") );
        ingredientListOfDish.add(i);

      }
      );
    }));
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
  Ingredient getSymptomFromList(String ingredientId){
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
    List<Color> colorsOfChart = [Colors.red,Colors.cyanAccent, Colors.purple,Colors.deepOrange,Colors.blueAccent,
      Colors.green,Colors.teal,Colors.pinkAccent,Colors.blueGrey,Colors.black,Colors.orangeAccent,
      Colors.yellowAccent,Colors.grey,Colors.lightBlueAccent];


    colorIngredientMap=Map.fromIterables(keys, colorsOfChart);
  }


}


