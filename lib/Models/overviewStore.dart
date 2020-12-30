import 'dart:async';

import 'package:Bealthy_app/Database/dish.dart';
import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Database/ingredient.dart';
import 'package:Bealthy_app/Database/symptom.dart';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:flutter/cupertino.dart';
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

  int count=0;
  @observable
  var  mapSymptomsOverview = new ObservableMap<DateTime,List<Symptom>>();

  @observable
  var overviewSymptomList = new ObservableList<Symptom>();

  @observable
  TemporalTime timeSelected = TemporalTime.Day;

  @observable
  var totalSymptomsPresentMap = new ObservableMap<String, int>();

  @observable
  var singleDaySymptomPresentMap = new ObservableMap<String, int>();

  @observable
  var mapIngredientsOverview = new ObservableMap<DateTime,List<Ingredient>>();

  @observable
  var overviewDishList = new ObservableList<Dish>();

  @observable
  var overviewIngredientList = new ObservableList<Ingredient>();

  @observable
  var totalIngredientPresentMap = new ObservableMap<String, int>();

  @observable
  var singleDayIngredientPresentMap = new ObservableMap<String, int>();

  @action
  Future<void> initStore(DateTime day) async {
    if (!storeInitialized) {
      storeInitialized = true;
    }
  }


  @action
  Future<void> initializeOverviewList(DateStore dateStore) async {
    initializeIngredientList(dateStore);
    mapSymptomsOverview.clear();
    totalSymptomsPresentMap.clear();
    overviewSymptomList.clear();
    switch(timeSelected.index){
      case 0: await getSymptomsOfADay(dateStore.overviewDefaultLastDate)
          .then((value) => mapSymptomsOverview.putIfAbsent(dateStore.overviewDefaultLastDate, () => overviewSymptomList.toList()))
          .then((value) => totalOccurrenceSymptoms()); break;
      case 1:
        await Future.wait(dateStore.rangeDays.map(getSymptomSingleDayOfAPeriod))
            .then((value) =>  totalOccurrenceSymptoms());
        break;
      case 2: await Future.wait(dateStore.rangeDays.map(getSymptomSingleDayOfAPeriod))
          .then((value) =>  totalOccurrenceSymptoms());
      break;
    }

  }

  function1(DateStore dateStore) async {
    await  Future.forEach(dateStore.rangeDays, (day) async {await asyncOne(day);}).then((value) => totalOccurrenceIngredients());
  }

  asyncOne(DateTime day) async {
    await Future.forEach(MealTime.values, (mealTime) async {
      await getDishMealTime(mealTime, day);
    }).then((value) => asyncTwo(day));
  }

  asyncTwo(DateTime day) async
  {
        await Future.forEach(overviewDishList, (dish) async {await getIngredientOfADish(dish);}).then((value) => asyncTre(day));

  }

  asyncTre(DateTime day)async{
    mapIngredientsOverview.update(day, (value) => overviewIngredientList.toList(), ifAbsent: ()=> overviewIngredientList.toList());
    overviewDishList.clear();
    overviewIngredientList.clear();
  }

  @action
  Future<void> initializeIngredientList(DateStore dateStore) async {
    mapIngredientsOverview.clear();
    overviewIngredientList.clear();
    totalIngredientPresentMap.clear();
    overviewDishList.clear();
    switch(timeSelected.index){
      case 0:
      // await getDishesOfADay(dateStore.overviewDefaultLastDate).then((value) =>
      // {
      //   Future.wait(overviewDishList.map(getIngredientOfADish)).then((value) => {
      //     mapIngredientsOverview.putIfAbsent(dateStore.overviewDefaultLastDate, () => overviewIngredientList.toList())
      //   }).then((value) => totalOccurrenceIngredients())});break;
      case 1: await function1(dateStore);
      break;
      case 2: await function1(dateStore);
      break;
    }

  }
  @action
  int totalNumOfSymptomList(){
    int count = 0;
    mapSymptomsOverview.values.forEach((symptomsList) {
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
  void totalOccurrenceSymptoms(){
    mapSymptomsOverview.values.forEach((symptomsList) {
      symptomsList.forEach((symptom) {
        if(!totalSymptomsPresentMap.keys.contains(symptom.id)){
          totalSymptomsPresentMap.putIfAbsent(symptom.id, () => 1);
      }else{
          totalSymptomsPresentMap.update(symptom.id, (value) => value+1);
        }
      });
    });
  }

  void singleDayOccurrenceSymptom(DateTime dateTime) {
    mapSymptomsOverview[dateTime].forEach((ingredient) {
      if (!singleDaySymptomPresentMap.keys.contains(ingredient.id)) {
        singleDaySymptomPresentMap.putIfAbsent(ingredient.id, () => 1);
      } else {
        singleDaySymptomPresentMap.update(
            ingredient.id, (value) => value + 1);
      }
    });
  }

  @action
  void totalOccurrenceIngredients(){
    mapIngredientsOverview.values.forEach((ingredientList) {
      ingredientList.forEach((ingredient) {
        if(!totalIngredientPresentMap.keys.contains(ingredient.id)){
          totalIngredientPresentMap.putIfAbsent(ingredient.id, () => 1);
        }else{
          totalIngredientPresentMap.update(ingredient.id, (value) => value+1);
        }
      });
    });
  }

  void singleDayOccurrenceIngredients(DateTime dateTime){
    singleDayIngredientPresentMap.clear();
    print(" ");
    mapIngredientsOverview[dateTime].forEach((ingredient) {
      if(!singleDayIngredientPresentMap.keys.contains(ingredient.id)){
        singleDayIngredientPresentMap.putIfAbsent(ingredient.id, () => 1);
      }else{
        singleDayIngredientPresentMap.update(ingredient.id, (value) => value+1);
      }
    });
  }

  @action
  Future<void> getSymptomsOfADay(DateTime date) async {
    await (FirebaseFirestore.instance
        .collection('UserSymptoms')
        .doc(auth.currentUser.uid).collection("DaySymptoms").doc(fixDate(date))
        .collection("Symptoms")
        .get()
        .then((querySnapshot) {
      overviewSymptomList.clear();
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

  @action
  Future<void> getSymptomSingleDayOfAPeriod(DateTime dateTime) async {
      await getSymptomsOfADay(dateTime)
          .then((value) =>
           {
             mapSymptomsOverview.update(dateTime, (value) => overviewSymptomList.toList(), ifAbsent: ()=> overviewSymptomList.toList())});
  }

  int getIndexFromSymptomsList(Symptom symptom,List<Symptom> symptoms){
    return symptoms.indexOf(symptom,0);
  }

  @action
  Future<dynamic> getDishMealTime(MealTime mealTime, DateTime dateTime) async {
    await (FirebaseFirestore.instance
        .collection('UserDishes')
        .doc(auth.currentUser.uid)
        .collection("DayDishes")
        .doc(fixDate(dateTime))
        .collection(mealTime.toString().toString().split('.').last)
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
  double mealTimeValueSymptom(Symptom symptom){
    double value;
    int count=0;
    symptom.mealTimeBoolList.forEach((element) {
      if(element.isSelected==true){
        count=count+1;
      }
    });
    if(count==1){
      value = 0.5;
    }
    if(count==2){
      value = 0.7;
    }
    if(count==3){
      value = 0.9;
    }
    if(count==4){
      value = 1.0;
    }
    if(count==0){
      value = 0;
    }
    return value;
  }


  @action
  void initializeOverviewValue(DateTime dateTime, String symptomId){

    if( mapSymptomsOverview[dateTime].any((element) => element.id==symptomId)){
      Symptom toUpdate = mapSymptomsOverview[dateTime].firstWhere((element) => element.id==symptomId);
      toUpdate.overviewValue = toUpdate.intensity*toUpdate.frequency*mealTimeValueSymptom(toUpdate)+2.5;
      print(toUpdate.overviewValue);
    }else{
      Symptom symptomNotPresent = new Symptom(id: symptomId, intensity: 0,frequency: 0,mealTime: []);
      mapSymptomsOverview[dateTime].add(symptomNotPresent);
      symptomNotPresent.overviewValue = 0;
    }
  }


  @action
  Future<void> getIngredientOfADish(Dish dish) async {
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
