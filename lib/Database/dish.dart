import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'dart:io';

part 'dish.g.dart';

Dish clientFromMap(String str) => _DishBase.fromMap(json.decode(str));


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
    this.qty,
    this.mealTime,
    this.barcode,
  });

  @observable
  String id;
  @observable
  int number;
  @observable
  String name;
  @observable
  String qty;
  @observable
  String mealTime;
  @observable
  String barcode;
  @observable
  File imageFile = null;
  @observable
  bool isFavourite= false;

  @observable
  int valueShowDialog = 0;


  @action
  void setIsFavourite(bool value) {
    isFavourite = value;
  }

  @action
  factory _DishBase.fromMap(Map<String, dynamic> json) =>
      Dish(
        id: json["id"],
        name: json["name"],
        qty:json["qty"],
        mealTime: json["mealTime"],
      );


  Map<String, dynamic> toMapDishes() =>
      {
        "name": name,
      };

  Map<String, dynamic> toMapDayDishes() =>
      {
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
        "number":number,
      };

  Map<String, dynamic> toMapDishesScannedByUser() =>
      {
        "name": name,
        "number":number,
        "barcode": barcode,
      };
}