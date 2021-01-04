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

  @observable
  TemporalTime timeSelected = TemporalTime.Day;

  @observable
  var mapSymptomsOverviewPeriod = new ObservableMap<DateTime,List<Symptom>>();

  @observable
  var mapSymptomsOverviewDay = new ObservableMap<MealTime, List<Symptom>>();

  @observable
  var overviewSymptomList = new ObservableList<Symptom>();

  @observable
  var totalOccurrenceSymptom = new ObservableMap<String, int>();

  @observable
  var dayOccurrenceSymptom = new ObservableMap<String, int>();

  @observable
  var mapIngredientsOverviewPeriod = new ObservableMap<DateTime,List<Ingredient>>();

  @observable
  var mapIngredientsOverviewDay = new ObservableMap<MealTime,List<Ingredient>>();

  @observable
  var overviewDishList = new ObservableList<Dish>();

  @observable
  var overviewIngredientList = new ObservableList<Ingredient>();

  @observable
  var totalOccurrenceIngredient = new ObservableMap<String, int>();

  @observable
  var dayOccurrenceIngredient = new ObservableMap<String, int>();

  @action
  Future<void> initStore(DateTime day) async {
    if (!storeInitialized) {
      storeInitialized = true;
    }
  }


  @action
  Future<void> initializeSymptomsMap(DateStore dateStore) async {
    initializeIngredientMap(dateStore);
    mapSymptomsOverviewDay.clear();
    mapSymptomsOverviewPeriod.clear();
    totalOccurrenceSymptom.clear();
    overviewSymptomList.clear();
    switch(timeSelected.index){
      case 0: await getSymptomsOfADay(dateStore.overviewDefaultLastDate)
          .then((value) => setMealTimeSymptomMap())
          .then((value) => totalOccurrenceSymptomsDay()); break;
      case 1:
        await Future.wait(dateStore.rangeDays.map(getSymptomSingleDayOfAPeriod))
            .then((value) =>  totalOccurrenceSymptomsPeriod());
        break;
      case 2: await Future.wait(dateStore.rangeDays.map(getSymptomSingleDayOfAPeriod))
          .then((value) =>  totalOccurrenceSymptomsPeriod());
      break;
    }

  }

  @action
  Future<void> initializeIngredientMap(DateStore dateStore) async {
    mapIngredientsOverviewDay.clear();
    mapIngredientsOverviewPeriod.clear();
    overviewIngredientList.clear();
    totalOccurrenceIngredient.clear();
    overviewDishList.clear();
    switch(timeSelected.index){
      case 0: await asyncGetDish(dateStore.overviewDefaultLastDate);
        break;
      case 1: await initializePeriodIngredientAsync(dateStore);
      break;
      case 2: await initializePeriodIngredientAsync(dateStore);
      break;
    }

  }

  initializePeriodIngredientAsync(DateStore dateStore) async {
    await  Future.forEach(dateStore.rangeDays, (day) async {await asyncGetDish(day);}).then((value) => totalOccurrenceIngredientsPeriod());
  }

  asyncGetDish(DateTime day) async {
    await Future.forEach(MealTime.values, (mealTime) async {
      await getDishMealTime(mealTime, day);
    }).then((value) => asyncGetIngredient(day));
  }

  asyncGetIngredient(DateTime day) async
  {
        await Future.forEach(overviewDishList, (dish) async {await getIngredientOfADish(dish);}).then((value) => asyncMapIngredient(day));
  }

  asyncMapIngredient(DateTime day)async{
    if(timeSelected==TemporalTime.Day){
      List<Ingredient> mealTimeList = new List<Ingredient>();
      MealTime.values.forEach((mealTime) {
        overviewIngredientList.forEach((ingredient) {
          if(ingredient.mealTime.contains(mealTime.toString().split('.').last)){
            mealTimeList.add(ingredient);
          }
        });
        mapIngredientsOverviewDay.putIfAbsent(mealTime, () => mealTimeList.toList());
        mealTimeList.clear();
      });
      totalOccurrenceIngredientsDay();

      overviewDishList.clear();
      overviewIngredientList.clear();
    }else{
      mapIngredientsOverviewPeriod.update(day, (value) => overviewIngredientList.toList(), ifAbsent: ()=> overviewIngredientList.toList());
      overviewDishList.clear();
      overviewIngredientList.clear();
    }

  }


  @action
  int totalNumOfSymptomList(){
    int count = 0;
    if(timeSelected==TemporalTime.Day){
      mapSymptomsOverviewDay.values.forEach((symptomsList) {
        count = count + symptomsList.length;
      });
    }else{
      mapSymptomsOverviewPeriod.values.forEach((symptomsList) {
        count = count + symptomsList.length;
      });
    }


    return count;
  }

  @action
  int totalNumOfIngredientList(){
    int count = 0;
    if(timeSelected==TemporalTime.Day){
      mapIngredientsOverviewDay.values.forEach((ingredientList) {
        count = count + ingredientList.length;
      });
    }else
    mapIngredientsOverviewPeriod.values.forEach((ingredientList) {
      count = count + ingredientList.length;
    });
    return count;
  }

  @action
  void totalOccurrenceSymptomsDay(){
    mapSymptomsOverviewDay.values.forEach((symptomsList) {
      symptomsList.forEach((symptom) {
        if(!totalOccurrenceSymptom.keys.contains(symptom.id)){
          totalOccurrenceSymptom.putIfAbsent(symptom.id, () => 1);
        }else{
          totalOccurrenceSymptom.update(symptom.id, (value) => value+1);
        }
      });
    });
  }

  @action
  void totalOccurrenceSymptomsPeriod(){
    mapSymptomsOverviewPeriod.values.forEach((symptomsList) {
      symptomsList.forEach((symptom) {
        if(!totalOccurrenceSymptom.keys.contains(symptom.id)){
          totalOccurrenceSymptom.putIfAbsent(symptom.id, () => 1);
      }else{
          totalOccurrenceSymptom.update(symptom.id, (value) => value+1);
        }
      });
    });
  }

  @action
  void totalOccurrenceIngredientsPeriod(){
    mapIngredientsOverviewPeriod.values.forEach((ingredientList) {
      ingredientList.forEach((ingredient) {
        if(!totalOccurrenceIngredient.keys.contains(ingredient.id)){
          totalOccurrenceIngredient.putIfAbsent(ingredient.id, () => 1);
        }else{
          totalOccurrenceIngredient.update(ingredient.id, (value) => value+1);
        }
      });
    });
  }

  @action
  void totalOccurrenceIngredientsDay(){
    mapIngredientsOverviewDay.values.forEach((ingredientList) {
      ingredientList.forEach((ingredient) {
        if(!totalOccurrenceIngredient.keys.contains(ingredient.id)){
          totalOccurrenceIngredient.putIfAbsent(ingredient.id, () => 1);
        }else{
          totalOccurrenceIngredient.update(ingredient.id, (value) => value+1);
        }
      });
    });
  }

  @action
  void singleDayOccurrenceIngredientsPeriod(DateTime dateTime){
    dayOccurrenceIngredient.clear();
    mapIngredientsOverviewPeriod[dateTime].forEach((ingredient) {
      if(!dayOccurrenceIngredient.keys.contains(ingredient.id)){
        dayOccurrenceIngredient.putIfAbsent(ingredient.id, () => 1);
      }else{
        dayOccurrenceIngredient.update(ingredient.id, (value) => value+1);
      }
    });
  }
  @action
  void singleDayOccurrenceIngredientsDay(MealTime mealTime){
    dayOccurrenceIngredient.clear();
    mapIngredientsOverviewDay[mealTime].forEach((ingredient) {
      if(!dayOccurrenceIngredient.keys.contains(ingredient.id)){
        dayOccurrenceIngredient.putIfAbsent(ingredient.id, () => 1);
      }else{
        dayOccurrenceIngredient.update(ingredient.id, (value) => value+1);
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
  void setMealTimeSymptomMap(){
    List<Symptom> mealTimeList = new List<Symptom>();
    MealTime.values.forEach((mealTime) {
      overviewSymptomList.forEach((symptom) { 
        if(symptom.mealTime.contains(mealTime.toString().split('.').last)){
          mealTimeList.add(symptom);
        }
      });
      mapSymptomsOverviewDay.putIfAbsent(mealTime, () => mealTimeList.toList());
      mealTimeList.clear();
    });
  }

  @action
  Future<void> getSymptomSingleDayOfAPeriod(DateTime dateTime) async {
      await getSymptomsOfADay(dateTime)
          .then((value) =>
           {
             mapSymptomsOverviewPeriod.update(dateTime, (value) => overviewSymptomList.toList(), ifAbsent: ()=> overviewSymptomList.toList())});
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
          mealTime: mealTime.toString().toString().split('.').last,
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
    if(count==0){
      value = 0;
    }
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
    return value;
  }

  @action
  void initializeOverviewValueDay(String symptomId){
    MealTime.values.forEach((mealTime) {
      if( mapSymptomsOverviewDay[mealTime].any((element) => element.id==symptomId)){
        Symptom toUpdate = mapSymptomsOverviewDay[mealTime].firstWhere((element) => element.id==symptomId);
        toUpdate.overviewValue = toUpdate.intensity*toUpdate.frequency*mealTimeValueSymptom(toUpdate);
        toUpdate.overviewValue.roundToDouble();
      }else{
        Symptom symptomNotPresent = new Symptom(id: symptomId, intensity: 0,frequency: 0,mealTime: []);
        mapSymptomsOverviewDay[mealTime].add(symptomNotPresent);
        symptomNotPresent.overviewValue = 0;
      }
    });
  }

  @action
  void initializeOverviewValuePeriod(DateTime dateTime, String symptomId){

    if( mapSymptomsOverviewPeriod[dateTime].any((element) => element.id==symptomId)){
      Symptom toUpdate = mapSymptomsOverviewPeriod[dateTime].firstWhere((element) => element.id==symptomId);
      toUpdate.overviewValue = toUpdate.intensity*toUpdate.frequency*mealTimeValueSymptom(toUpdate);
      toUpdate.overviewValue = toUpdate.overviewValue.roundToDouble();
    }else{
      Symptom symptomNotPresent = new Symptom(id: symptomId, intensity: 0,frequency: 0,mealTime: []);
      mapSymptomsOverviewPeriod[dateTime].add(symptomNotPresent);
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
          int totalQty= 0;
              //ingredient.get("qty")*dish.qty; //TODO CONVERTIRE STRINGHE AD INTERI CON GLI ENUM
          Ingredient i = new Ingredient(id:ingredient.id,name:ingredient.get("name"),qty:ingredient.get("qty"), mealTime: dish.mealTime, totalQuantity: totalQty );
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
          int totalQty= 0;
              //ingredient.get("qty")*dish.qty; //TODO CONVERTIRE STRINGHE AD INTERI CON GLI ENUM
          Ingredient i = new Ingredient(id:ingredient.id,name:ingredient.get("name"),qty:ingredient.get("qty"), mealTime: dish.mealTime, totalQuantity: totalQty);
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
