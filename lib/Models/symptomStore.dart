import 'dart:async';

import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Database/symptom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Include generated file
part 'symptomStore.g.dart';


FirebaseAuth auth = FirebaseAuth.instance;

// This is the class used by rest of your codebase
class SymptomStore = _SymptomStoreBase with _$SymptomStore;

// The store-class
abstract class _SymptomStoreBase with Store {

  final firestoreInstance = FirebaseFirestore.instance;
  bool storeInitialized = false;

  @observable
  var symptomList = new ObservableList<Symptom>();

  @observable
  var symptomListOfSpecificDay = new ObservableList<Symptom>();

  Map colorSymptomsMap = new Map<String , Color>();


  @action
  Future<void> initStore(DateTime day) async {
    if (!storeInitialized) {
      
      await _getSymptomList().then((value) => initializeColorMap());
      await getSymptomsOfADay(day);
      storeInitialized = true;
    }
  }



  @action
  Future<void> _getSymptomList() async {
    await (FirebaseFirestore.instance
        .collection('Symptoms')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {

        Symptom i = new Symptom(id:result.id,name:result.get("name"));
        i.initStore();
        symptomList.add(i);
      }
      );
    }));
  }

  @action
  Symptom getSymptomFromList(String symptomId){
    Symptom symptom;
    symptomList.forEach((element) {
      if(element.id.compareTo(symptomId)==0){
        symptom = element;
      }
    });
    if (symptom==null){
      print("Errore nel codice dato");
    }
    return symptom;
  }



  @action
  Future<void> getSymptomsOfADay(DateTime date) async {
    symptomListOfSpecificDay.clear();
    _resetSymptomsValue();
    String day = fixDate(date);
    await (FirebaseFirestore.instance
        .collection('UserSymptoms')
        .doc(auth.currentUser.uid).collection("DaySymptoms").doc(day)
        .collection("Symptoms")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((symptom) {
        Symptom toUpdate = getSymptomFromList(symptom.id);
        toUpdate.setIntensity(symptom.get("intensity"));
        toUpdate.setFrequency(symptom.get("frequency"));
        toUpdate.setMealTime(symptom.get("mealTime"));
        toUpdate.setIsSymptomInADay(true);
        toUpdate.setMealTimeBoolList();
        //lista dei sintomi di un giorno specifico
        symptomListOfSpecificDay.add(toUpdate);
      }
      );
    })
    );
  }


  int getIndexFromSymptomsList(Symptom symptom,List<Symptom> symptoms){
    return symptoms.indexOf(symptom,0);
  }

  @action
  void createStringMealTime(Symptom symptom){
    List<String> listToAdd = new List<String>();
    int index =0;
    symptom.mealTimeBoolList.forEach((element) {
      print(index);
      if(element.isSelected==true){
        String toAdd = "${MealTime.values[index].toString().split('.').last}";
        listToAdd.add(toAdd);
      }
      index++;
    });
    symptom.mealTime = listToAdd;
  }

  Future<void> decrementingOccurrenceSymptom(Symptom symptom)async{
    int occurrence=0;
    await (FirebaseFirestore.instance
        .collection("UserSymptomsOccurrence")
        .doc(auth.currentUser.uid)
        .collection("Symptoms")
        .doc(symptom.id)
        .get()
        .then((doc) {
        occurrence= doc.get("occurrence")-1;
        updateOccurrenceSymptom(symptom.id,occurrence);
        }));
  }

  Future<void> incrementingOccurrenceSymptom(Symptom symptom)async{
    int occurrence=0;
    await (FirebaseFirestore.instance
        .collection("UserSymptomsOccurrence")
        .doc(auth.currentUser.uid)
        .collection("Symptoms")
        .doc(symptom.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        print(doc.data());
        occurrence= doc.get("occurrence") +1;
        updateOccurrenceSymptom(symptom.id,occurrence);
      } else {
        createOccurrenceSymptom(symptom);
      }


    }));
  }


  @action
  Future<void> createOccurrenceSymptom(Symptom symptom) async {
    //creo l'occorrenza del sintomo e la setto ad 1
    await (FirebaseFirestore.instance
        .collection("UserSymptomsOccurrence")
        .doc(auth.currentUser.uid)
        .collection("Symptoms")
        .doc(symptom.id)
        .set({"virtual": true}));

      await (FirebaseFirestore.instance
          .collection("UserSymptomsOccurrence")
          .doc(auth.currentUser.uid)
          .collection("Symptoms")
          .doc(symptom.id)
          .set({"name":symptom.name,"occurrence": 1}));

  }

  @action
  Future<void> updateOccurrenceSymptom(String symptomId, int newOccurrence) async {

    await (FirebaseFirestore.instance
        .collection("UserSymptomsOccurrence")
        .doc(auth.currentUser.uid)
        .collection("Symptoms")
        .doc(symptomId)
        .update({"occurrence": newOccurrence}));

  }

  @action
  Future<void> updateSymptom(Symptom symptom, DateTime date) async {
    String day = fixDate(date);
    createStringMealTime(symptom);
    if(symptom.isSymptomSelectDay){
      await (FirebaseFirestore.instance
          .collection("UserSymptoms")
          .doc(auth.currentUser.uid)
          .collection("DaySymptoms")
          .doc(day)
          .collection("Symptoms")
          .doc(symptom.id)
          .set(symptom.toMapDaySymptom()));
    }else{
      await (FirebaseFirestore.instance
          .collection("UserSymptoms")
          .doc(auth.currentUser.uid)
          .collection("DaySymptoms")
          .doc(day)
          .set({"virtual": true}));

      await (FirebaseFirestore.instance
          .collection("UserSymptoms")
          .doc(auth.currentUser.uid)
          .collection("DaySymptoms")
          .doc(day)
          .collection("Symptoms")
          .doc(symptom.id)
          .set(symptom.toMapDaySymptom()));

      incrementingOccurrenceSymptom(symptom);
      symptom.isSymptomSelectDay=true;
      symptomListOfSpecificDay.add(symptom);

    }

  }


  @action
  void _resetSymptomsValue ()  {
    symptomList.forEach((element) {
      element.resetValue();
    });
  }

  void reorderList(int oldIndex, int newIndex){
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Symptom item = symptomList.removeAt(oldIndex);
    symptomList.insert(newIndex, item);
  }


  @action
  Future<void> removeSymptomOfSpecificDay(Symptom symptom, DateTime date) async {
    String dayFix = fixDate(date);
    await (FirebaseFirestore.instance
        .collection("UserSymptoms")
        .doc(auth.currentUser.uid)
        .collection("DaySymptoms")
        .doc(dayFix)
        .collection("Symptoms")
        .doc(symptom.id)
        .delete());

    symptom.resetValue();
    symptomListOfSpecificDay.removeWhere((element) => symptom.id == element.id);
    decrementingOccurrenceSymptom(symptom);
  }

  void initializeColorMap(){
    List<String> keys = new List<String>();
    symptomList.forEach((element) {
      keys.add(element.id);
    });
    List<Color> colorsOfChart = [Colors.red,Colors.cyanAccent, Colors.purple,Colors.yellow,Colors.blueAccent,
      Colors.green,Colors.teal,Colors.pinkAccent];

  
    colorSymptomsMap=Map.fromIterables(keys, colorsOfChart);
  }

  String fixDate(DateTime date) {
    String dateSlug = "${date.year.toString()}-${date.month.toString().padLeft(
        2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return dateSlug;
  }
}