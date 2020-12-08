import 'dart:convert';


Symptom clientFromMap(String str) => Symptom.fromMap(json.decode(str));

String clientToMap1(Symptom data) => json.encode(data.toMapSymptom());
String clientToMap2(Symptom data) => json.encode(data.toMapDaySymptom());



class Symptom {
  Symptom({
    this.id,
    this.name,
    this.intensity,
    this.mealTime,
  });

  String id;
  String name;
  int intensity;
  String mealTime;

  factory Symptom.fromMap(Map<String, dynamic> json) =>
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