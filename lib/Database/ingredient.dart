import 'dart:collection';
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
    this.it_Name,
    this.qty,
    this.mealTime,
    this.totalQuantity,
  });

  @observable
  String id;
  @observable
  String name;
  @observable
  String it_Name;
  @observable
  String qty;
  @observable
  int valueShowDialog = 0;
  @observable
  String mealTime;
  @observable
  var ingredientMapSymptomsValue = new ObservableMap<String, double>();

  @observable
  Map ingredientMapSymptomsValueFiltered;

  @observable
  int totalQuantity;

  void sortIngredientMapSymptoms(){
    SplayTreeMap<String,double> sortedMap = SplayTreeMap<String,double>
        .from(ingredientMapSymptomsValueFiltered, (b, a) => ingredientMapSymptomsValueFiltered[a] > ingredientMapSymptomsValueFiltered[b] ? 1 : -1 );
    ingredientMapSymptomsValueFiltered = Map.from(sortedMap);
  }

  @action
  factory _IngredientBase.fromMap(Map<String, dynamic> json) =>
      Ingredient(
          id: json["id"],
          name: json["name"],
          qty: json["qty"]
      );

  _IngredientBase.fromJson(Map<String, dynamic> json){
    name = json['name'];
    qty = json["qty"];
    id = json["id"];
  }

  Map<String, dynamic> toMap() =>
      {
        "id": id,
        "name": name,
        "qty":qty
      };

}