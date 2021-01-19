import 'dart:async';

import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Database/dish.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Include generated file
part 'mealTimeStore.g.dart';

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

  @observable
  MealTime selectedMealTime;


  @action
  void changeCurrentMealTime(int mealTimeIndex) {

    this.selectedMealTime = MealTime.values[mealTimeIndex];

  }

  @action
  Future<void> initDishesOfMealTimeList(DateTime day) async {
    MealTime.values.forEach((element) {
      _getDishesOfMealTimeListOfSpecificDay(element.index,day);
    });

  }

  @action
  int getMealTimeIndexFromName(String mealTimeDishName){
    int index =0;
    MealTime.values.forEach((element) {
      if(element.toString().split('.').last==mealTimeDishName){
        index= MealTime.values.indexOf(element);
      }
    });
    return index;
  }

  @action
  ObservableList<Dish> getDishesOfMealTimeList(int mealTimeIndex) {
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

  void changeImageToAllSameDishes(Dish dish){
    MealTime.values.forEach((element) {
      getDishesOfMealTimeList(MealTime.values.indexOf(element)).forEach((dishToChange) {
        if(dishToChange.id==dish.id){
          dishToChange.imageFile = dish.imageFile;
        }
      });
    });
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
        MealTime.values[index].toString().split('.').last)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((dish) {

          Dish toAdd = new Dish(id: dish.id,
            name: dish.get("name"),
            qty: dish.get("qty"),
            mealTime: dish.get("mealTime"),
          );
          getDishesOfMealTimeList(index).add(toAdd);

      }

      );
    })
    );
  }

  @action
  Future<void> removeDishOfMealTimeListOfSpecificDay(int index, Dish dish, DateTime date) async {
    String dayFix = fixDate(date);
    await (FirebaseFirestore.instance
        .collection("UserDishes")
        .doc(auth.currentUser.uid)
        .collection("DayDishes")
        .doc(dayFix)
        .collection(dish.mealTime.toString().split('.').last)
        .doc(dish.id)
        .delete());

    getDishesOfMealTimeList(index).removeWhere((element) => element.id == dish.id);

  }

  @action
  Future<void> addDishOfMealTimeListOfSpecificDay(Dish dish, DateTime day) async {
    String dayFix = fixDate(day);
    await (FirebaseFirestore.instance
        .collection('UserDishes')
        .doc(auth.currentUser.uid)
        .collection("DayDishes")
        .doc(dayFix).set({"virtual": true}));

    await (FirebaseFirestore.instance
        .collection('UserDishes')
        .doc(auth.currentUser.uid)
        .collection("DayDishes")
        .doc(dayFix)
        .collection(dish.mealTime.toString().split('.').last)
        .doc(dish.id)
        .set(dish.toMapDayDishes()));

    getDishesOfMealTimeList(selectedMealTime.index).add(dish);
  }

  @action
  Future<void> updateDishOfMealTimeListOfSpecificDay(Dish dish, DateTime day) async {
    String dayFix = fixDate(day);
    await (FirebaseFirestore.instance
        .collection('UserDishes')
        .doc(auth.currentUser.uid)
        .collection("DayDishes")
        .doc(dayFix)
        .collection(dish.mealTime)
        .doc(dish.id)
        .set(dish.toMapDayDishes()));

  }

  bool checkIfDishIsPresent(Dish dish){
    bool found=false;
    if(getDishesOfMealTimeList(selectedMealTime.index).firstWhere((element) => dish.id==element.id, orElse: () => null)!=null){
      found=true;
    }else{
      found=false;
    }

    return found;
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


