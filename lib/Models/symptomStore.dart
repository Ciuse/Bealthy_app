import 'dart:async';

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

  @observable
  var symptomOfADayList = new ObservableList<Symptom>();

  @action
  Future<void> initStore() async {
    if (!storeInitialized) {
      await _getSymptomList();
      storeInitialized = true;
    }
  }

  @observable
  ObservableFuture loadDaySymptom;

  @action
  Future<void> initGetSymptomOfADay(DateTime day) {
    return loadDaySymptom = ObservableFuture(_getSymptomOfADay(day));
  }

  @action
  Future<void> _getSymptomList() async {
    await (FirebaseFirestore.instance
        .collection('Symptoms')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {

        Symptom i = new Symptom(id:result.id,name:result.get("name"));
        symptomList.add(i);
        print(i);
      }
      );
    }));
  }
  @action
  Future<void> _getSymptomOfADay(DateTime date) async {
    String day = fixDate(date);
    symptomOfADayList.clear();
    await (FirebaseFirestore.instance
        .collection('UserSymptoms')
        .doc(auth.currentUser.uid).collection("DaySymptoms").doc(day)
        .collection("Symptoms")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((symptom) {

        Symptom toAdd = new Symptom(
          id: symptom.id,
          name: symptom.get("name"),
          intensity: symptom.get("intensity"),
          mealTime: symptom.get("mealTime"),
        );
        symptomOfADayList.add(toAdd);
      }
      );
    })
    );
  }

  @action
  void isUserSymptomInADay (Symptom symptom)  {
    bool found= false;
    symptomOfADayList.forEach((element) {
      if(element.name.compareTo(symptom.name)==0){
        found=true;
      }
    });
    symptom.setIsSymptomInADay(found);
  }

  String fixDate(DateTime date) {
    String dateSlug = "${date.year.toString()}-${date.month.toString().padLeft(
        2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return dateSlug;
  }
}