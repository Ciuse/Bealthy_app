// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mealTimeStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MealTimeStore on _MealTimeStoreBase, Store {
  final _$breakfastDishesListAtom =
      Atom(name: '_MealTimeStoreBase.breakfastDishesList');

  @override
  ObservableList<Dish> get breakfastDishesList {
    _$breakfastDishesListAtom.reportRead();
    return super.breakfastDishesList;
  }

  @override
  set breakfastDishesList(ObservableList<Dish> value) {
    _$breakfastDishesListAtom.reportWrite(value, super.breakfastDishesList, () {
      super.breakfastDishesList = value;
    });
  }

  final _$lunchDishesListAtom =
      Atom(name: '_MealTimeStoreBase.lunchDishesList');

  @override
  ObservableList<Dish> get lunchDishesList {
    _$lunchDishesListAtom.reportRead();
    return super.lunchDishesList;
  }

  @override
  set lunchDishesList(ObservableList<Dish> value) {
    _$lunchDishesListAtom.reportWrite(value, super.lunchDishesList, () {
      super.lunchDishesList = value;
    });
  }

  final _$snackDishesListAtom =
      Atom(name: '_MealTimeStoreBase.snackDishesList');

  @override
  ObservableList<Dish> get snackDishesList {
    _$snackDishesListAtom.reportRead();
    return super.snackDishesList;
  }

  @override
  set snackDishesList(ObservableList<Dish> value) {
    _$snackDishesListAtom.reportWrite(value, super.snackDishesList, () {
      super.snackDishesList = value;
    });
  }

  final _$dinnerDishesListAtom =
      Atom(name: '_MealTimeStoreBase.dinnerDishesList');

  @override
  ObservableList<Dish> get dinnerDishesList {
    _$dinnerDishesListAtom.reportRead();
    return super.dinnerDishesList;
  }

  @override
  set dinnerDishesList(ObservableList<Dish> value) {
    _$dinnerDishesListAtom.reportWrite(value, super.dinnerDishesList, () {
      super.dinnerDishesList = value;
    });
  }

  final _$initDishesOfMealTimeListAsyncAction =
      AsyncAction('_MealTimeStoreBase.initDishesOfMealTimeList');

  @override
  Future<void> initDishesOfMealTimeList(DateTime day) {
    return _$initDishesOfMealTimeListAsyncAction
        .run(() => super.initDishesOfMealTimeList(day));
  }

  final _$_getDishesOfMealTimeListAsyncAction =
      AsyncAction('_MealTimeStoreBase._getDishesOfMealTimeList');

  @override
  Future<void> _getDishesOfMealTimeList(int index, DateTime date) {
    return _$_getDishesOfMealTimeListAsyncAction
        .run(() => super._getDishesOfMealTimeList(index, date));
  }

  @override
  String toString() {
    return '''
breakfastDishesList: ${breakfastDishesList},
lunchDishesList: ${lunchDishesList},
snackDishesList: ${snackDishesList},
dinnerDishesList: ${dinnerDishesList}
    ''';
  }
}
