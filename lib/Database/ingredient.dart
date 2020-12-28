import 'dart:convert';
import 'package:mobx/mobx.dart';

part 'ingredient.g.dart';

Ingredient clientFromMap(String str) => _IngredientBase.fromMap(json.decode(str));

String clientToMap1(_IngredientBase data) => json.encode(data.toMap());



class Ingredient = _IngredientBase with _$Ingredient;

// The store-class
abstract class _IngredientBase with Store {
  _IngredientBase({
    this.id,
    this.name,
    this.qty
  });
  @observable
  String id;
  @observable
  String name;
  @observable
  String qty;



  @action
  factory _IngredientBase.fromMap(Map<String, dynamic> json) =>
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