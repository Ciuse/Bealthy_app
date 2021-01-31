import 'dart:convert';
import 'dart:io';
import 'package:Bealthy_app/Database/dish.dart';
import 'package:Bealthy_app/Database/ingredient.dart';
import 'package:Bealthy_app/Database/symptom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

String fixture(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('test')) {
    dir = dir.replaceAll('test', '');
  }
  return File('$dir/test/fixture/$name').readAsStringSync();
}

Future<void> main() async {
  String fileStringDish = fixture('dishJson.json');
  String fileStringIngredient = fixture('ingredientJson.json');
  String fileStringSymptom = fixture('symptomJson.json');
  final jsonDish = jsonDecode(fileStringDish);
  final jsonIngredient = jsonDecode(fileStringIngredient);
  final jsonSymptom = jsonDecode(fileStringSymptom);
  Dish dish = Dish.fromJson(jsonDish);
  Ingredient ingredient = Ingredient.fromJson(jsonIngredient);
  Symptom symptom = Symptom.fromJson(jsonSymptom);

  group("Firebase data test", ()
  {
  test('Check function fromJson dish', () async {
    expect(dish.name, "Chocolate");
    expect(dish.mealTime, "Lunch");
    expect(dish.qty, "Little");
  });

  test('Check function fromJson ingredient', () async {
    expect(ingredient.name, "Milk");
    expect(ingredient.id, "Ingr_9");
    expect(ingredient.qty, "Normal");
  });

  test('Check function fromJson Symptom', () async {
    expect(symptom.name, "Flatulence");
    expect(symptom.intensity, 4);
    expect(symptom.frequency, 3);
    expect(symptom.mealTime, ["Breakfast", "Snack"]);
  });
});
}