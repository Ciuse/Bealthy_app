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

  final _$selectedMealTimeAtom =
      Atom(name: '_MealTimeStoreBase.selectedMealTime');

  @override
  MealTime get selectedMealTime {
    _$selectedMealTimeAtom.reportRead();
    return super.selectedMealTime;
  }

  @override
  set selectedMealTime(MealTime value) {
    _$selectedMealTimeAtom.reportWrite(value, super.selectedMealTime, () {
      super.selectedMealTime = value;
    });
  }

  final _$initDishesOfMealTimeListAsyncAction =
      AsyncAction('_MealTimeStoreBase.initDishesOfMealTimeList');

  @override
  Future<void> initDishesOfMealTimeList(DateTime day) {
    return _$initDishesOfMealTimeListAsyncAction
        .run(() => super.initDishesOfMealTimeList(day));
  }

  final _$_getDishesOfMealTimeListOfSpecificDayAsyncAction =
      AsyncAction('_MealTimeStoreBase._getDishesOfMealTimeListOfSpecificDay');

  @override
  Future<void> _getDishesOfMealTimeListOfSpecificDay(int index, DateTime date) {
    return _$_getDishesOfMealTimeListOfSpecificDayAsyncAction
        .run(() => super._getDishesOfMealTimeListOfSpecificDay(index, date));
  }

  final _$removeDishOfMealTimeListOfSpecificDayAsyncAction =
      AsyncAction('_MealTimeStoreBase.removeDishOfMealTimeListOfSpecificDay');

  @override
  Future<void> removeDishOfMealTimeListOfSpecificDay(
      int index, Dish dish, DateTime date) {
    return _$removeDishOfMealTimeListOfSpecificDayAsyncAction.run(
        () => super.removeDishOfMealTimeListOfSpecificDay(index, dish, date));
  }

  final _$addDishOfMealTimeListOfSpecificDayAsyncAction =
      AsyncAction('_MealTimeStoreBase.addDishOfMealTimeListOfSpecificDay');

  @override
  Future<void> addDishOfMealTimeListOfSpecificDay(Dish dish, DateTime day) {
    return _$addDishOfMealTimeListOfSpecificDayAsyncAction
        .run(() => super.addDishOfMealTimeListOfSpecificDay(dish, day));
  }

  final _$_MealTimeStoreBaseActionController =
      ActionController(name: '_MealTimeStoreBase');

  @override
  void changeCurrentMealTime(int mealTimeIndex) {
    final _$actionInfo = _$_MealTimeStoreBaseActionController.startAction(
        name: '_MealTimeStoreBase.changeCurrentMealTime');
    try {
      return super.changeCurrentMealTime(mealTimeIndex);
    } finally {
      _$_MealTimeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  ObservableList<Dish> getDishesOfMealTimeList(int mealTimeIndex) {
    final _$actionInfo = _$_MealTimeStoreBaseActionController.startAction(
        name: '_MealTimeStoreBase.getDishesOfMealTimeList');
    try {
      return super.getDishesOfMealTimeList(mealTimeIndex);
    } finally {
      _$_MealTimeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
breakfastDishesList: ${breakfastDishesList},
lunchDishesList: ${lunchDishesList},
snackDishesList: ${snackDishesList},
dinnerDishesList: ${dinnerDishesList},
selectedMealTime: ${selectedMealTime}
    ''';
  }
}
