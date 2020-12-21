import 'dart:async';

import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Database/mealTimeBool.dart';
import 'package:Bealthy_app/Database/symptom.dart';
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



  @action
  Future<void> initStore() async {
    if (!storeInitialized) {
      await _getSymptomList();
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
        toUpdate.setIsSymptomInADay(true);
        toUpdate.setIntensity(symptom.get("intensity"));
        toUpdate.setFrequency(symptom.get("frequency"));
        toUpdate.setMealTime(symptom.get("mealTime"));
        toUpdate.setMealTimeBoolList();
      }
      );
    })
    );
  }

  @action
  Future<void> updateSymptom(Symptom symptom, DateTime date) async {
    String day = fixDate(date);

    if(symptom.isSymptomSelectDay){
      print("sintomo già presente nel db");
      await (FirebaseFirestore.instance
          .collection("UserSymptoms")
          .doc(auth.currentUser.uid)
          .collection("DaySymptoms")
          .doc(day)
          .collection("Symptoms")
          .doc(symptom.id)
          .set(symptom.toMapDaySymptom()));
    }else{
      print("sintomo non presente nel db");

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

      symptom.isSymptomSelectDay=true;
    }

  }

  @action
  void _resetSymptomsValue ()  {
    symptomList.forEach((element) {
      element.resetValue();
    });
  }

  void reorderList(int oldIndex, int newIndex){
    symptomList.insert(newIndex, symptomList.removeAt(oldIndex));
  }


  String fixDate(DateTime date) {
    String dateSlug = "${date.year.toString()}-${date.month.toString().padLeft(
        2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return dateSlug;
  }
}