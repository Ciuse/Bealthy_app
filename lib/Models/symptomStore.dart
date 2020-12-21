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
  var symptomListOfSpecificDay = new ObservableList<Symptom>();

  @observable
  var symptomList = new ObservableList<Symptom>();

  @observable
  double rating = 0.0;

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
  void initGetSymptomOfADay(DateTime day) {
    _getSymptomOfADay(day);
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

      }
      );
    }));
  }

  @action
  Future<void> _getSymptomOfADay(DateTime date) async {
    clearUserSymptomInADay();
    String day = fixDate(date);
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
          mealTime: symptom.get("mealTime")
        );
        toAdd.isSymptomSelectDay=true;
        symptomListOfSpecificDay.add(toAdd);

        setUserSymptomInADay(symptom.id);
      }
      );
    })
    );
  }
  @action
  void clearUserSymptomInADay ()  {
    symptomList.forEach((element) {
        element.setIsSymptomInADay(false);
    });
  }
  @action
  void setUserSymptomInADay (String symptomId)  {
    symptomList.forEach((element) {
      if(element.id.compareTo(symptomId)==0){
        element.isSymptomSelectDay = true;
      }
    });
    symptomList.forEach((element) {
      });
  }



  String fixDate(DateTime date) {
    String dateSlug = "${date.year.toString()}-${date.month.toString().padLeft(
        2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return dateSlug;
  }
}