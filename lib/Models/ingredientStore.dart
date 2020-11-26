import 'dart:async';

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

  @observable
  ObservableList ingredientList = new ObservableList();


  @action
  List<String> getIngredients() {
    List<String> ingredientsFromDB = new List<String>();
    FirebaseFirestore.instance
        .collection('ingredients')
        .get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {

        ingredientsFromDB.add(result.get("Name"));

      });
      //print(ingredientsFromDB);

    });
    return ingredientsFromDB;

  }

}


