import 'dart:async';

import 'package:Bealthy_app/Database/enumerators.dart';
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
  var symptomListOfSpecificDay = new ObservableList<Symptom>();




  @action
  Future<void> initStore(DateTime day) async {
    if (!storeInitialized) {
      await _getSymptomList();
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
        toUpdate.setIsSymptomInADay(true);
        toUpdate.setIntensity(symptom.get("intensity"));
        toUpdate.setFrequency(symptom.get("frequency"));
        toUpdate.setMealTime(symptom.get("mealTime"));
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
      if(element.isSelected==true){
        String toAdd = "${MealTime.values[index].toString().split('.').last}";
        listToAdd.add(toAdd);
      }
      index++;
    });
    symptom.mealTime = listToAdd;
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
  }

  String fixDate(DateTime date) {
    String dateSlug = "${date.year.toString()}-${date.month.toString().padLeft(
        2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return dateSlug;
  }
}