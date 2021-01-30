import 'dart:convert';
import 'dart:io';
import 'package:Bealthy_app/Database/dish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

String fixture(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  return File('$dir/test/fixture/$name').readAsStringSync();
}

Future<void> main() async {
  String fileString = fixture('dishJson.json');
  final json = jsonDecode(fileString);
  Dish dish = Dish.fromJson(json);
print(json);


  test('Trying to add already present dish with search test', () async {
    expect(dish.name, "Chocolate");
    expect(dish.mealTime, "Lunch");
    expect(dish.qty, "Little");
  });
}