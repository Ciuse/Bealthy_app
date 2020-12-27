import 'dart:async';

import 'package:Bealthy_app/Database/enumerators.dart';
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


  @action
  Future<void> initStore(DateTime day) async {
    if (!storeInitialized) {
      storeInitialized = true;
    }
  }


  @action
  Future<void> initializeOverviewList(DateStore dateStore) async {
    mapOverview.clear();
    symptomsPresentMap.clear();
    switch(timeSelected.index){
      case 0: await getSymptomsOfADay(dateStore.overviewDefaultLastDate)
          .then((value) => mapOverview.putIfAbsent(dateStore.overviewDefaultLastDate, () => overviewSymptomList))
          .then((value) => numOfCategorySymptoms()); break;
      case 1: await getSymptomsOfAWeek(dateStore);break;
      case 2: await getSymptomsOfAMonth(dateStore);break;

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
  void numOfCategorySymptoms(){
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
  Future<void> getSymptomsOfADay(DateTime date) async {
        String day = fixDate(date);
        overviewSymptomList.clear();
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

  @action
  Future<void> getSymptomsOfAWeek(DateStore dateStore) async {
    dateStore.rangeDays.forEach((element) async {
      await getSymptomsOfADay(element)
          .then((value) => mapOverview.putIfAbsent(element, () => overviewSymptomList))
          .then((value) => numOfCategorySymptoms());
    });
    
  }

  
  @action
  Future<void> getSymptomsOfAMonth(DateStore dateStore) async {
    dateStore.rangeDays.forEach((element) async {
      await getSymptomsOfADay(element)
          .then((value) => mapOverview.putIfAbsent(element, () => overviewSymptomList))
          .then((value) => numOfCategorySymptoms());
    });
  }


  int getIndexFromSymptomsList(Symptom symptom,List<Symptom> symptoms){
    return symptoms.indexOf(symptom,0);
  }


  String fixDate(DateTime date) {
    String dateSlug = "${date.year.toString()}-${date.month.toString().padLeft(
        2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return dateSlug;
  }
}