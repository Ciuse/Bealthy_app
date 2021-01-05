import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'dart:io';

part 'dish.g.dart';

Dish clientFromMap(String str) => _DishBase.fromMap(json.decode(str));

String clientToMap1(_DishBase data) => json.encode(data.toMapDishesCategory());
String clientToMap2(_DishBase data) => json.encode(data.toMapDishes());
String clientToMap3(_DishBase data) => json.encode(data.toMapDayDishes());
String clientToMap4(_DishBase data) => json.encode(data.toMapDishesCreatedByUser());



// This is the class used by rest of your codebase
class Dish = _DishBase with _$Dish;

// The store-class
abstract class _DishBase with Store {
  _DishBase({
    this.id,
    this.name,
    this.category,
    this.qty,
    this.mealTime,
  });

  @observable
  String id;
  @observable
  String name;
  @observable
  String category;
  @observable
  String qty;
  @observable
  String mealTime;
  @observable
  File imageFile = null;
  @observable
  bool isFavourite= false;

  @action
  void setIsFavourite(bool value) {
    isFavourite = value;
  }

  @action
  factory _DishBase.fromMap(Map<String, dynamic> json) =>
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

  Map<String, dynamic> toMapUpdateQtyOfDish() =>
      {
        "qty": qty,
      };

  Map<String, dynamic> toMapDishesCreatedByUser() =>
      {
        "name": name,
        "category": category,
      };
}