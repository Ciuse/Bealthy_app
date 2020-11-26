import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Database/Dish.dart';
import '../Database/Ingredient.dart';
// Include generated file
part 'foodStore.g.dart';

enum Category {
  Primo,
  Secondo,
  Contorno,
  Dolce
}
//flutter packages pub run build_runner build
//flutter packages pub run build_runner watch
//flutter packages pub run build_runner watch --delete-conflicting-outputs
FirebaseAuth auth = FirebaseAuth.instance;

// This is the class used by rest of your codebase
class FoodStore = _FoodStoreBase with _$FoodStore;

// The store-class
abstract class _FoodStoreBase with Store {
  final firestoreInstance = FirebaseFirestore.instance;

  @action
  void addDishWithCategory(Dish dish) {
    firestoreInstance
        .collection("DishesCategory")
        .doc(dish.category)
        .collection("Dishes")
        .add(dish.toMapDishesCategory());
  }

  @action
  void addNewDish(Dish dish) {
    firestoreInstance
        .collection("Dishes")
        .doc(dish.id)
        .set(dish.toMapDishes());
  }

  @action
  void addNewDishCreatedByUser(Dish dish, List<Ingredient> ingredients) {
    firestoreInstance
        .collection("DishesCreatedByUsers")
        .doc(auth.currentUser.uid)
        .collection("DishesCategory")
        .doc(dish.category)
        .collection("Dishes")
        .doc(dish.id)
        .set(dish.toMapDishesCreatedByUser());

    ingredients.forEach((element) {
      firestoreInstance
          .collection("DishesCreatedByUsers")
          .doc(auth.currentUser.uid)
          .collection("DishesCategory")
          .doc(dish.category)
          .collection("Dishes")
          .doc(dish.id)
          .collection("Ingredients").doc(element.id).set(element.toMap());
    });
   
  }
  @action
  void getDishes() {
    FirebaseFirestore.instance
        .collection('UserDishes')
        .doc(auth.currentUser.uid).get().
    then((DocumentSnapshot documentSnapshot) =>
    {
      if (documentSnapshot.exists) {
        print('Document exists on the database')
      }
    });
    print("id:" + auth.currentUser.uid);
  }

  @action
  List<Dish> getFavouritesDishes() {
    List<Dish> dishList = new List<Dish>();
    dishList.add(Dish(id:"1",name:"pasta",category: "Primo",ingredients: null));
    dishList.add(Dish(id:"2",name:"gnocchi",category: "Primo",ingredients: null));
    dishList.add(Dish(id:"3",name:"riso",category: "Primo",ingredients: null));
    return dishList;
  }

  List<Dish> getYourDishes() {
    List<Dish> dishList = new List<Dish>();
    dishList.add(Dish(id:"1",name:"pasta",category: "Primo",ingredients: null));
    dishList.add(Dish(id:"2",name:"gnocchi",category: "Primo",ingredients: null));
    dishList.add(Dish(id:"3",name:"riso",category: "Primo",ingredients: null));
    return dishList;
  }
}

