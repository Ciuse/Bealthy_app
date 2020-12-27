import 'dart:async';

import 'package:Bealthy_app/Database/dish.dart';
import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Database/ingredient.dart';
import 'package:Bealthy_app/Database/symptom.dart';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Include generated file
part 'overviewStore.g.dart';


FirebaseAuth auth = FirebaseAuth.instance;

// This is the class used by rest of your codebase
class OverviewStore = _OverviewBase with _$OverviewStore;

// The store-class
abstract class _OverviewBase with Store {

  final firestoreInstance = FirebaseFirestore.instance;
  bool storeInitialized = false;

  @observable
  var  mapOverview = new ObservableMap<DateTime,List<Symptom>>();

  @observable
  var overviewSymptomList = new ObservableList<Symptom>();

  @observable
  TemporalTime timeSelected = TemporalTime.Day;

  @observable
  var symptomsPresentMap = new ObservableMap<String, int>();


  @observable
  var  mapIngredientsOverview = new ObservableMap<DateTime,List<Ingredient>>();

  @observable
  var overviewDishList = new ObservableList<Dish>();

  @observable
  var overviewIngredientList = new ObservableList<Ingredient>();

  @observable
  var ingredientPresentMap = new ObservableMap<String, int>();

  @action
  Future<void> initStore(DateTime day) async {
    if (!storeInitialized) {
      storeInitialized = true;
    }
  }


  @action
  Future<void> initializeOverviewList(DateStore dateStore) async {
    mapOverview.clear();
    switch(timeSelected.index){
      case 0:
        await getSymptomsOfADay(dateStore.overviewSelectedDate)
            .then((value) => mapOverview.putIfAbsent(dateStore.overviewSelectedDate, () => overviewSymptomList))
            .then((value) => numOfCategorySymptoms());
        break;
      case 1: break;
      case 2: break;

    }

  }
  @action
  Future<void> initializeIngredientList(DateStore dateStore) async {
    mapIngredientsOverview.clear();
    overviewIngredientList.clear();
    switch(timeSelected.index){
      case 0:
        await getDishesOfADay(dateStore.overviewSelectedDate).then((value) =>
        {
          Future.forEach(overviewDishList, getIngredientOfADay).then((value) => {
            mapIngredientsOverview.putIfAbsent(dateStore.overviewSelectedDate, () => overviewIngredientList)
          }).then((value) => numOfCategoryIngredient())});

        break;
      case 1: break;
      case 2: break;

    }

  }
  @action
  int totalNumOfSymptomList(){
    int count = 0;
    mapOverview.values.forEach((symptomsList) {
      count = count + symptomsList.length;
    });
    return count;
  }

  @action
  int totalNumOfIngredientList(){
    int count = 0;
    mapIngredientsOverview.values.forEach((ingredientList) {
      count = count + ingredientList.length;
    });
    return count;
  }
  @action
  void numOfCategorySymptoms(){
    symptomsPresentMap.clear();
    mapOverview.values.forEach((symptomsList) {
      symptomsList.forEach((symptom) {
        if(!symptomsPresentMap.keys.contains(symptom.id)){
          int occurrence=1;
          symptomsPresentMap.putIfAbsent(symptom.id, () => occurrence);
      }else{
          symptomsPresentMap.update(symptom.id, (value) => value+1);
        }
      });
    });
  }
  @action

  void numOfCategoryIngredient(){
    ingredientPresentMap.clear();
    mapIngredientsOverview.values.forEach((ingredientList) {
      ingredientList.forEach((ingredient) {
        if(!ingredientPresentMap.keys.contains(ingredient.id)){
          int occurrence=1;
          ingredientPresentMap.putIfAbsent(ingredient.id, () => occurrence);
        }else{
          ingredientPresentMap.update(ingredient.id, (value) => value+1);
        }
      });
    });

  }

  @action
  Future<void> getSymptomsOfADay(DateTime date) async {
    overviewSymptomList.clear();
    String day = fixDate(date);
    await (FirebaseFirestore.instance
        .collection('UserSymptoms')
        .doc(auth.currentUser.uid).collection("DaySymptoms").doc(day)
        .collection("Symptoms")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((symptom) {
        Symptom toAdd = new Symptom(id:symptom.id, name: symptom.get("name"));
        toAdd.initStore();
        toAdd.setIsSymptomInADay(true);
        toAdd.setIntensity(symptom.get("intensity"));
        toAdd.setFrequency(symptom.get("frequency"));
        toAdd.setMealTime(symptom.get("mealTime"));
        toAdd.setMealTimeBoolList();
        //lista dei sintomi di un giorno specifico
        overviewSymptomList.add(toAdd);
      }
      );
    })
    );
  }


  int getIndexFromSymptomsList(Symptom symptom,List<Symptom> symptoms){
    return symptoms.indexOf(symptom,0);
  }

  @action
  Future<void> getDishesOfADay(DateTime date) async {
    overviewDishList.clear();
    String day = fixDate(date);
    await (FirebaseFirestore.instance
        .collection('UserDishes')
        .doc(auth.currentUser.uid)
        .collection("DayDishes")
        .doc(day)
        .collection("Dishes")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((dish) {
        Dish toAdd = new Dish(
          id: dish.id,
          qty: dish.get("qty"),
        );
        overviewDishList.add(toAdd);
      }
      );
    }));
  }

  @action
  Future<void> getIngredientOfADay(Dish dish) async {
    if(isSubstring("User", dish.id,)){
      await (FirebaseFirestore.instance
          .collection("DishesCreatedByUsers")
          .doc(auth.currentUser.uid)
          .collection("Dishes").doc(dish.id).collection("Ingredients")
          .get().then((querySnapshot) {
        querySnapshot.docs.forEach((ingredient) {
          Ingredient i = new Ingredient(id:ingredient.id,name:ingredient.get("name"),qty:ingredient.get("qty") );
          overviewIngredientList.add(i);
        }
        );
      }));
    }
    else{
      await (FirebaseFirestore.instance
          .collection('Dishes').doc(dish.id).collection("Ingredients")
          .get().then((querySnapshot) {
        querySnapshot.docs.forEach((ingredient) {
          Ingredient i = new Ingredient(id:ingredient.id,name:ingredient.get("name"),qty:ingredient.get("qty") );
          overviewIngredientList.add(i);
        }
        );
      }));
    }
  }

  String fixDate(DateTime date) {
    String dateSlug = "${date.year.toString()}-${date.month.toString().padLeft(
        2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return dateSlug;
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