import 'dart:convert';


Disease clientFromMap(String str) => Disease.fromMap(json.decode(str));

String clientToMap1(Disease data) => json.encode(data.toMap());



class Disease {
  Disease({
    this.id,
    this.name,
    this.intensity
  });

  String id;
  String name;
  String intensity;

  factory Disease.fromMap(Map<String, dynamic> json) =>
      Disease(
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