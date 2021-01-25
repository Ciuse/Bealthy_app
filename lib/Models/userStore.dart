import 'dart:io';

import 'package:Bealthy_app/Database/symptom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'userStore.g.dart';


//flutter packages pub run build_runner build
//flutter packages pub run build_runner watch
//flutter packages pub run build_runner watch --delete-conflicting-outputs
FirebaseAuth auth = FirebaseAuth.instance;

// This is the class used by rest of your codebase
class UserStore = _UserStoreBase with _$UserStore;

// The store-class
abstract class _UserStoreBase with Store {
  final firestoreInstance = FirebaseFirestore.instance;

  @observable
  File profileImage;

  var personalPageSymptomsList = new List<Symptom>();
  var totalSymptomsOccurrence;
  var numOfSickDaysInMonth;
  var sickDays = new List<DateTime>();

  @observable
  ObservableFuture loadInitOccurrenceSymptomsList;

  @observable
  ObservableFuture loadSickDayMonth;

  Future<void> initUserDb() async{
    if(auth.currentUser!=null) {
      profileImage = null;
      await Future.wait([
        _initDishCreated(),
        _initDishFavourite(),
        _initUserSymptom(),
        _initUserDish(),
        _initUserSymptomsOccurrence(),
        _initUserTreatment(),
      ]);
    }
  }

  Future<void> _initDishCreated() async{
    await  FirebaseFirestore.instance
        .collection("DishesCreatedByUsers")
        .doc(auth.currentUser.uid)
        .set({"virtual": true});
  }

  Future<void> _initDishFavourite() async{
    await  FirebaseFirestore.instance
        .collection("DishesFavouriteByUsers")
        .doc(auth.currentUser.uid)
        .set({"virtual": true});
  }

  Future<void> _initUserSymptom() async{
    await  FirebaseFirestore.instance
        .collection("UserSymptoms")
        .doc(auth.currentUser.uid)
        .set({"virtual": true});
  }

  Future<void> _initUserDish() async{
    await  FirebaseFirestore.instance
        .collection("UserDishes")
        .doc(auth.currentUser.uid)
        .set({"virtual": true});
  }

  Future<void> _initUserTreatment() async{
    await  FirebaseFirestore.instance
        .collection("UserTreatments")
        .doc(auth.currentUser.uid)
        .set({"virtual": true});
  }

  Future<void> _initUserSymptomsOccurrence() async{
    await  FirebaseFirestore.instance
        .collection("UserSymptomsOccurrence")
        .doc(auth.currentUser.uid)
        .set({"virtual": true});
  }

  @action
  Future<void> initPersonalPage()async{
    return loadInitOccurrenceSymptomsList = ObservableFuture(_occurrenceInit());

  }

  @action
  Future<void> initSickDaysMonth(List<DateTime> dates)async{
    return loadSickDayMonth = ObservableFuture(_getAverageSickDays(dates));

  }

  @action
  Future<void> retrySickDaysMonth(List<DateTime> dates) {
    return loadSickDayMonth = ObservableFuture(_getAverageSickDays(dates));
  }

  @action
  Future<void> retryForOccurrenceSymptoms() {
    return loadInitOccurrenceSymptomsList = ObservableFuture(_occurrenceInit());
  }

  @action
  Future<void> _occurrenceInit() async{
    if(auth.currentUser!=null) {
      await _getSymptomListForPersonalPage()
          .then((value) =>
          personalPageSymptomsList.sort((a, b) =>
              a.occurrence.compareTo(b.occurrence)));
    }
  }

@action
double calculatePercentageSymptom(Symptom symptom){
  return   (symptom.occurrence/totalSymptomsOccurrence)*100;
}


  @action
  Future<void> _getSymptomListForPersonalPage() async {
    personalPageSymptomsList.clear();
    totalSymptomsOccurrence = 0;
    await (FirebaseFirestore.instance
        .collection("UserSymptomsOccurrence")
        .doc(auth.currentUser.uid)
        .collection("Symptoms")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Symptom i = new Symptom(id:result.id,name:result.get("name") );
        i.occurrence = result.get("occurrence");
        personalPageSymptomsList.add(i);
        totalSymptomsOccurrence = totalSymptomsOccurrence + result.get("occurrence");
      }
      );
    }));
  }


  @action
  Future<void> _getAverageSickDays(List<DateTime> dateTimeList ) async {
    if(auth.currentUser!=null)
    {
      numOfSickDaysInMonth=0;
      sickDays.clear();
      await  Future.wait(dateTimeList.map(getSickDay));
    }


  }
  @action
  String fixDate(DateTime date){
    return "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
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
  Future<void> getSickDay(DateTime dateTime) async{
    await (FirebaseFirestore.instance
        .collection("UserSymptoms")
        .doc(auth.currentUser.uid)
        .collection("DaySymptoms")
        .doc(fixDate(dateTime))
        .collection("Symptoms")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((symptom) {
        Symptom symptomCreated = new Symptom(id: symptom.id, intensity: symptom.get("intensity"),frequency: symptom.get("frequency"));
        symptomCreated.initStore();
        symptomCreated.setMealTime(symptom.get("mealTime"));
        symptomCreated.setMealTimeBoolList();
        symptomCreated.overviewValue = ((symptomCreated.intensity)*(symptomCreated.frequency)*mealTimeValueSymptom(symptomCreated))*0.4;
        symptomCreated.overviewValue.roundToDouble();
        if(symptomCreated.overviewValue>=3.5){
          if(!sickDays.contains(dateTime)){
            sickDays.add(dateTime);
          }
        }
      }
      );
    }
    ));
  }

}
