import 'dart:async';

import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Database/observableValues.dart';
import 'package:Bealthy_app/Database/symptom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
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

  @observable
  var mapSymptomTreatment = new ObservableMap<String,ObservableValues>();

  @observable
  var mapSymptomBeforeTreatment = new ObservableMap<String,ObservableValues>();

  Map colorSymptomsMap = new Map<String , Color>();


  @observable
  ObservableFuture loadSymptomDay;

  @observable
  ObservableFuture loadTreatmentMap;

  @observable
  ObservableFuture loadBeforeTreatmentMap;

  @action
  Future<void> initStore(DateTime day) async {
    if (!storeInitialized) {
      
      await _getSymptomList().then((value) => {
        initializeColorMap(),initSymptomDay(day),
      storeInitialized = true,
      });
    }
  }



  @action
  Future<void> _getSymptomList() async {
    await (FirebaseFirestore.instance
        .collection('Symptoms')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {

        Symptom i = new Symptom(id:result.id,name:result.get("name"),description:result.get("description"),symptoms: result.get("symptoms") );
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
  Future<void> initSymptomDay(DateTime day) async {
    symptomListOfSpecificDay.clear();
    return loadSymptomDay = ObservableFuture(_getSymptomsOfADay(day));
  }


  @action
  Future<void> _getSymptomsOfADay(DateTime date) async {
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

  @action
  Future<void> initTreatmentMap(List<DateTime> days) async {
    mapSymptomTreatment.clear();
    return loadTreatmentMap = ObservableFuture(asyncForEachSymptoms(days));
  }

  Future<void>asyncForEachSymptoms(List<DateTime> dates) async {
    await Future.wait(symptomList.map((symptom)=> asyncGetSymptomValue(dates,symptom.id)));
  }

  Future<void>asyncGetSymptomValue(List<DateTime> dates,String symptomId) async {
    await Future.wait(dates.map((date)=>_fillTreatmentMap(date,symptomId))).then((value) => calculateFractionTreatment(symptomId));
  }

  @action
  Future<void> initBeforeTreatmentMap(List<DateTime> days) async {
    mapSymptomBeforeTreatment.clear();
    return loadBeforeTreatmentMap = ObservableFuture(asyncForEachSymptomsBeforeTreatment(days));
  }

  Future<void>asyncForEachSymptomsBeforeTreatment(List<DateTime> dates) async {
    await Future.wait(symptomList.map((symptom)=> asyncGetSymptomValueBeforeTreatment(dates,symptom.id)));
  }

  Future<void>asyncGetSymptomValueBeforeTreatment(List<DateTime> dates,String symptomId) async {
    await Future.wait(dates.map((date)=>_fillBeforeTreatmentMap(date,symptomId))).then((value) => calculateFractionBefore(symptomId) );
  }


  void calculateFractionBefore(String symptomId){
    if(mapSymptomBeforeTreatment.containsKey(symptomId))
    mapSymptomBeforeTreatment[symptomId].fractionSeverityOccurrence = mapSymptomBeforeTreatment[symptomId].severitySymptom / mapSymptomBeforeTreatment[symptomId].occurrenceSymptom;
  }

  void calculateFractionTreatment(String symptomId){
    if(mapSymptomTreatment.containsKey(symptomId))
    mapSymptomTreatment[symptomId].fractionSeverityOccurrence = mapSymptomTreatment[symptomId].severitySymptom / mapSymptomTreatment[symptomId].occurrenceSymptom;
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
      value = 0.6;
    }
    if(count==2){
      value = 0.8;
    }
    if(count==3){
      value = 0.95;
    }
    if(count==4){
      value = 1.0;
    }
    return value;
  }


  @action
  Future<void> _fillTreatmentMap(DateTime date,String symptomId) async {
    String day = fixDate(date);
    await (FirebaseFirestore.instance
        .collection('UserSymptoms')
        .doc(auth.currentUser.uid).collection("DaySymptoms").doc(day)
        .collection("Symptoms").doc(symptomId)
        .get()
        .then((querySnapshot) {
          if(querySnapshot.exists){
            Symptom symptomCreated = new Symptom(id: symptomId, intensity: querySnapshot.get("intensity"),frequency: querySnapshot.get("frequency"));
            symptomCreated.initStore();
            symptomCreated.setMealTime(querySnapshot.get("mealTime"));
            symptomCreated.setMealTimeBoolList();
            symptomCreated.overviewValue = ((symptomCreated.intensity)*(symptomCreated.frequency)*mealTimeValueSymptom(symptomCreated))*0.4;
            if(mapSymptomTreatment.keys.isEmpty || mapSymptomTreatment[symptomId]==null){
              ObservableValues symptomValue = new ObservableValues();
              symptomValue.occurrenceSymptom = 1;
              symptomValue.severitySymptom = symptomCreated.overviewValue;
              mapSymptomTreatment.putIfAbsent(symptomId, () => symptomValue);
            }else{
              mapSymptomTreatment[symptomId].occurrenceSymptom = mapSymptomTreatment[symptomId].occurrenceSymptom +1;
              mapSymptomTreatment[symptomId].severitySymptom = mapSymptomTreatment[symptomId].severitySymptom + symptomCreated.overviewValue;
            }
          }

    })
    );
  }

  @action
  Future<void> _fillBeforeTreatmentMap(DateTime date,String symptomId) async {
    String day = fixDate(date);
    await (FirebaseFirestore.instance
        .collection('UserSymptoms')
        .doc(auth.currentUser.uid).collection("DaySymptoms").doc(day)
        .collection("Symptoms").doc(symptomId)
        .get()
        .then((querySnapshot) {
      if(querySnapshot.exists){
        Symptom symptomCreated = new Symptom(id: symptomId, intensity: querySnapshot.get("intensity"),frequency: querySnapshot.get("frequency"));
        symptomCreated.initStore();
        symptomCreated.setMealTime(querySnapshot.get("mealTime"));
        symptomCreated.setMealTimeBoolList();
        symptomCreated.overviewValue = ((symptomCreated.intensity)*(symptomCreated.frequency)*mealTimeValueSymptom(symptomCreated))*0.4;
        if(mapSymptomBeforeTreatment.keys.isEmpty || mapSymptomBeforeTreatment[symptomId]==null){
          ObservableValues symptomValue = new ObservableValues();
          symptomValue.occurrenceSymptom = 1;
          symptomValue.severitySymptom = symptomCreated.overviewValue;
          mapSymptomBeforeTreatment.putIfAbsent(symptomId, () => symptomValue);
        }else{
          mapSymptomBeforeTreatment[symptomId].occurrenceSymptom = mapSymptomBeforeTreatment[symptomId].occurrenceSymptom +1;
          mapSymptomBeforeTreatment[symptomId].severitySymptom = mapSymptomBeforeTreatment[symptomId].severitySymptom + symptomCreated.overviewValue;
        }
      }

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