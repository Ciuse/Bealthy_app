import 'dart:convert';


Ingredient clientFromMap(String str) => Ingredient.fromMap(json.decode(str));

String clientToMap1(Ingredient data) => json.encode(data.toMap());



class Ingredient {
  Ingredient({
    this.id,
    this.name,
    this.qty
  });

  String id;
  String name;
  String qty;

  factory Ingredient.fromMap(Map<String, dynamic> json) =>
      Ingredient(
          id: json["id"],
          name: json["name"],
          qty: json["qty"]
      );

  Map<String, dynamic> toMap() =>
      {
        "id": id,
        "name": name,
        "qty":qty
      };

}