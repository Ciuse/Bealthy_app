import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Include generated file
part 'mealTimeStore.g.dart';

enum mealTime{
  Breakfast,
  Lunch,
  Snack,
  Dinner
}

FirebaseAuth auth = FirebaseAuth.instance;

// This is the class used by rest of your codebase
class MealTimeStore = _MealTimeStoreBase with _$MealTimeStore;

// The store-class
abstract class _MealTimeStoreBase with Store {

}


