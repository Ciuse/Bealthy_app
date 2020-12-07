import 'dart:convert';


Symptom clientFromMap(String str) => Symptom.fromMap(json.decode(str));

String clientToMap1(Symptom data) => json.encode(data.toMap());



class Symptom {
  Symptom({
    this.id,
    this.name,
    this.intensity
  });

  String id;
  String name;
  String intensity;

  factory Symptom.fromMap(Map<String, dynamic> json) =>
      Symptom(
          id: json["id"],
          name: json["name"],
          intensity: json["intensity"]
      );

  Map<String, dynamic> toMap() =>
      {
        "id": id,
        "name": name,
        "intensity":intensity
      };

}