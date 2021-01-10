import 'dart:convert';
import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Database/mealTimeBool.dart';
import 'package:mobx/mobx.dart';

part 'symptom.g.dart';

Symptom clientFromMap(String str) => _SymptomBase.fromMap(json.decode(str));

String clientToMap1(_SymptomBase data) => json.encode(data.toMapSymptom());
String clientToMap2(_SymptomBase data) => json.encode(data.toMapDaySymptom());



class Symptom = _SymptomBase with _$Symptom;

// The store-class
abstract class _SymptomBase with Store {
  _SymptomBase(
  {
    this.id,
    this.name,
    this.intensity,
    this.frequency,
    this.mealTime,
  });

  @observable
  String id;
  @observable
  String name;
  @observable
  int occurrence;
  @observable
  int intensity;
  @observable
  int frequency;
  @observable
  List<dynamic> mealTime; //è una lista di stringhe

  @observable
  double overviewValue;

  @observable
  bool isSymptomSelectDay=false;

  @observable
  bool isModifyButtonActive=false;

  @observable
  bool isPresentAtLeastOneMeal=false;

  bool storeInitialized = false;

  @observable
  var mealTimeBoolList = new List<MealTimeBool>();


  @action
  Future<void> initStore() async {
    if (!storeInitialized) {
      storeInitialized = true;
      createMealTimeListBool();
    }
  }

  @action
  bool isPresentAtLeastOneTrue(){
    int count = 0;
    mealTimeBoolList.forEach((element) {
      if(element.isSelected){
        count = count+1;
      }
    });
   if(count>0){
     return true;
   }else return false;
  }

  @action
  void createMealTimeListBool(){
    MealTime.values.forEach((element) {
      MealTimeBool mealTimeBool = new MealTimeBool(isSelected: false);
      mealTimeBoolList.add(mealTimeBool);
    });
  }

  @action
  void setMealTimeBoolList() {
    //in teoria si creano nell'ordine giusto
    int index = 0;
    MealTime.values.forEach((element) {
      mealTime.forEach((elem)  {
        if(element.toString().toString().split('.').last==elem.toString()){
          mealTimeBoolList[index].setIsSelected(true);
          //mealTimeBoolListFromDb[index].setIsSelected(true);
        }
      });
      index++;
    });
  }



  @action
  void resetMealTimeBoolList() {
    mealTimeBoolList.forEach((element) {
      element.setIsSelected(false);
      });
  }

  @action
  void setIsSymptomInADay(bool value) {
    isSymptomSelectDay = value;
  }

  @action
  void setOccurrence(int value) {
    occurrence = value;
  }

  @action
  void setIntensity(int value) {
    intensity = value;
  }
  @action
  void setFrequency(int value) {
    frequency = value;
  }
  @action
  void setMealTime(List<dynamic> value) {
    mealTime = value;
  }


  @action
  void resetValue() {
    setIntensity(0);
    setFrequency(0);
    setMealTime(null);
    setIsSymptomInADay(false);
    resetMealTimeBoolList();
  }

  @action
  factory _SymptomBase.fromMap(Map<String, dynamic> json) =>
      Symptom(
          id: json["id"],
          name: json["name"],
          intensity: json["intensity"],
          frequency: json["frequency"]
      );

  Map<String, dynamic> toMapOccurrenceSymptom() =>
      {
        "occurrence": occurrence,
      };

  Map<String, dynamic> toMapSymptom() =>
      {
        "name": name,
      };

  Map<String, dynamic> toMapDaySymptom() =>
      {
        "name": name,
        "intensity": intensity,
        "mealTime":mealTime,
        "frequency":frequency,
      };

}