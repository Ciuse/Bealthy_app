import 'dart:convert';
import 'Ingredient.dart';

Dish clientFromMap(String str) => Dish.fromMap(json.decode(str));

String clientToMap1(Dish data) => json.encode(data.toMapDishesCategory());
String clientToMap2(Dish data) => json.encode(data.toMapDishes());
String clientToMap3(Dish data) => json.encode(data.toMapDayDishes());
String clientToMap4(Dish data) => json.encode(data.toMapDishesCreatedByUser());


class Dish {
  Dish({
    this.id,
    this.name,
    this.category,
    this.qty,
    this.mealTime,
  });


  String id;
  String name;
  String category;
  String qty;
  String mealTime;

  factory Dish.fromMap(Map<String, dynamic> json) =>
      Dish(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        qty:json["qty"],
        mealTime: json["mealTime"],
      );

  Map<String, dynamic> toMapDishesCategory() =>
      {
        "id": id,
        "name": name,
      };

  Map<String, dynamic> toMapDishes() =>
      {
        "name": name,
        "category": category,
      };

  Map<String, dynamic> toMapDayDishes() =>
      {
        "category": category,
        "name": name,
        "qty": qty,
        "mealTime":mealTime
      };


  Map<String, dynamic> toMapDishesCreatedByUser() =>
      {
        "name": name,
        "category": category,
      };
}