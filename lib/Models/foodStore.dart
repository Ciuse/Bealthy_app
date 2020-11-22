import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Database/Dish.dart';
// Include generated file
part 'foodStore.g.dart';

FirebaseAuth auth = FirebaseAuth.instance;

// This is the class used by rest of your codebase
class FoodStore = _FoodStoreBase with _$FoodStore;

// The store-class
abstract class _FoodStoreBase with Store {
  final firestoreInstance = FirebaseFirestore.instance;

  @action
  void addDishWithCategory(Dish dish, String category) {
    firestoreInstance
        .collection("DishesCategory")
        .doc(category)
        .collection("Dishes")
        .add(dish.toMap());
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
}

