import 'dart:async';

import 'package:Bealthy_app/Database/Ingredient.dart';
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
  var ingredientsName = new ObservableList<String>();

  @observable
  ObservableFuture loadInitIngredientList;

  @action
  Future<void> loadInitialBho() {
    return loadInitIngredientList = ObservableFuture(initStore());
  }

  @action
  Future<void> initStore() async {
    if(!storeInitialized) {
      await getIngredients();
      storeInitialized=true;
    }
  }

  @action
  Future<void> getIngredients() async {
    await (FirebaseFirestore.instance
        .collection('Ingredients')
        .get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Ingredient i = new Ingredient(id:result.id,name:result.get("name"),qty: "" );
        ingredientList.add(i);
        print(i);
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




}


