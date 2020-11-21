import 'dart:convert';

Dish clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Dish.fromMap(jsonData);
}

String clientToJson(Dish data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

Dish clientFromMap(String str) => Dish.fromMap(json.decode(str));

String clientToMap(Dish data) => json.encode(data.toMap());

class Dish {
  Dish({
    this.id,
    this.name,
    this.qty,
    this.category,
  });

  int id;
  String name;
  int qty;
  String category;

  factory Dish.fromMap(Map<String, dynamic> json) =>
      Dish(
        id: json["id"],
        name: json["name"],
        qty: json["qty"],
        category: json["category"],
      );

  Map<String, dynamic> toMap() =>
      {
        "id": id,
        "name": name,
        "qty": qty,
      };
}