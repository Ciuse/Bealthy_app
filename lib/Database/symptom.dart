import 'dart:convert';
import 'package:mobx/mobx.dart';

part 'symptom.g.dart';

Symptom clientFromMap(String str) => _SymptomBase.fromMap(json.decode(str));

String clientToMap1(_SymptomBase data) => json.encode(data.toMapSymptom());
String clientToMap2(_SymptomBase data) => json.encode(data.toMapDaySymptom());



class Symptom = _SymptomBase with _$Symptom;

// The store-class
abstract class _SymptomBase with Store {
  _SymptomBase({
    this.id,
    this.name,
    this.intensity,
    this.mealTime,
  });

  @observable
  String id;
  @observable
  String name;
  @observable
  int intensity;
  @observable
  int frequency;
  @observable
  List<dynamic> mealTime; //TODO fare una lista di stringe o cmq mealtime

  @observable
  bool isSymptomSelectDay=false;

  @action
  void setIsSymptomInADay(bool value) {
    isSymptomSelectDay = value;
  }
  @action
  factory _SymptomBase.fromMap(Map<String, dynamic> json) =>
      Symptom(
          id: json["id"],
          name: json["name"],
          intensity: json["intensity"]
      );

  Map<String, dynamic> toMapSymptom() =>
      {
        "name": name,
      };

  Map<String, dynamic> toMapDaySymptom() =>
      {
        "name": name,
        "intensity": intensity,
        "mealTime":mealTime
      };

}