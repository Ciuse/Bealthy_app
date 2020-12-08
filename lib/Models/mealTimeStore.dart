import 'dart:async';

import 'package:Bealthy_app/Database/Dish.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Include generated file
part 'mealTimeStore.g.dart';

enum MealTime{
  Breakfast,
  Lunch,
  Snack,
  Dinner
}

FirebaseAuth auth = FirebaseAuth.instance;

// This is the class used by rest of your codebase
class MealTimeStore = _MealTimeStoreBase with _$MealTimeStore;

// The store-class
abstract class _MealTimeStoreBase with Store {

  @observable
  var breakfastDishesList = new ObservableList<Dish>();
  @observable
  var lunchDishesList = new ObservableList<Dish>();
  @observable
  var snackDishesList = new ObservableList<Dish>();
  @observable
  var dinnerDishesList = new ObservableList<Dish>();


  @action
  Future<void> initDishesOfMealTimeList(DateTime day) async {
    MealTime.values.forEach((element) {
      _getDishesOfMealTimeListOfSpecificDay(element.index,day);
    });

  }


  ObservableList getDishesOfMealTimeList(int mealTimeIndex) {
    switch (mealTimeIndex) {
      case 0:
        {
          return breakfastDishesList;
        }
        break;
      case 1:
        {
          return lunchDishesList;
        }
        break;
      case 2:
        {
          return snackDishesList;
        }
        break;
      case 3:
        {
          return dinnerDishesList;
        }
        break;

      default:
        {
          print("Switch case no mealTime found");
          return null;
        }
    }
  }




  String fixDate(DateTime date) {
    String dateSlug = "${date.year.toString()}-${date.month.toString().padLeft(
        2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return dateSlug;
  }

  @action
  Future<void> _getDishesOfMealTimeListOfSpecificDay(int index, DateTime date) async {
    String day = fixDate(date);
    getDishesOfMealTimeList(index).clear();
    await (FirebaseFirestore.instance
        .collection('UserDishes')
        .doc(auth.currentUser.uid).collection("DayDishes").doc(day).collection(
        "Dishes").where("mealTime",isEqualTo:MealTime.values[index].toString().split('.').last)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((dish) {

          Dish toAdd = new Dish(id: dish.id,
            name: dish.get("name"),
            category: dish.get("category"),
            qty: null,
            mealTime: dish.get("mealTime"),
          );
          getDishesOfMealTimeList(index).add(toAdd);

      }

      );
    })
    );
  }

  @action
  Future<void> removeDishOfMealTimeListOfSpecificDay(int index,Dish dish, DateTime date) async {
    String dayFix = fixDate(date);
    await (FirebaseFirestore.instance
        .collection("UserDishes")
        .doc(auth.currentUser.uid)
        .collection("DayDishes")
        .doc(dayFix)
        .collection("Dishes")
        .doc(dish.id)
        .delete());

    getDishesOfMealTimeList(index).remove(dish);
  }



  bool isSubstring(String s1, String s2) {
    int M = s1.length;
    int N = s2.length;

/* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
      int j;

/* For current index i, check for
 pattern match */
      for (j = 0; j < M; j++)
        if (s2[i + j] != s1[j])
          break;

      if (j == M)
        return true; // il piatto è stato creato dall'utente
    }

    return false; //il piatto non è stato creato dall'utente

  }



}


