// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overviewStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OverviewStore on _OverviewBase, Store {
  final _$mapSymptomsOverviewAtom =
      Atom(name: '_OverviewBase.mapSymptomsOverview');

  @override
  ObservableMap<DateTime, List<Symptom>> get mapSymptomsOverview {
    _$mapSymptomsOverviewAtom.reportRead();
    return super.mapSymptomsOverview;
  }

  @override
  set mapSymptomsOverview(ObservableMap<DateTime, List<Symptom>> value) {
    _$mapSymptomsOverviewAtom.reportWrite(value, super.mapSymptomsOverview, () {
      super.mapSymptomsOverview = value;
    });
  }

  final _$overviewSymptomListAtom =
      Atom(name: '_OverviewBase.overviewSymptomList');

  @override
  ObservableList<Symptom> get overviewSymptomList {
    _$overviewSymptomListAtom.reportRead();
    return super.overviewSymptomList;
  }

  @override
  set overviewSymptomList(ObservableList<Symptom> value) {
    _$overviewSymptomListAtom.reportWrite(value, super.overviewSymptomList, () {
      super.overviewSymptomList = value;
    });
  }

  final _$timeSelectedAtom = Atom(name: '_OverviewBase.timeSelected');

  @override
  TemporalTime get timeSelected {
    _$timeSelectedAtom.reportRead();
    return super.timeSelected;
  }

  @override
  set timeSelected(TemporalTime value) {
    _$timeSelectedAtom.reportWrite(value, super.timeSelected, () {
      super.timeSelected = value;
    });
  }

  final _$symptomsPresentMapAtom =
      Atom(name: '_OverviewBase.symptomsPresentMap');

  @override
  ObservableMap<String, int> get symptomsPresentMap {
    _$symptomsPresentMapAtom.reportRead();
    return super.symptomsPresentMap;
  }

  @override
  set symptomsPresentMap(ObservableMap<String, int> value) {
    _$symptomsPresentMapAtom.reportWrite(value, super.symptomsPresentMap, () {
      super.symptomsPresentMap = value;
    });
  }

  final _$mapIngredientsOverviewAtom =
      Atom(name: '_OverviewBase.mapIngredientsOverview');

  @override
  ObservableMap<DateTime, List<Ingredient>> get mapIngredientsOverview {
    _$mapIngredientsOverviewAtom.reportRead();
    return super.mapIngredientsOverview;
  }

  @override
  set mapIngredientsOverview(ObservableMap<DateTime, List<Ingredient>> value) {
    _$mapIngredientsOverviewAtom
        .reportWrite(value, super.mapIngredientsOverview, () {
      super.mapIngredientsOverview = value;
    });
  }

  final _$overviewDishListAtom = Atom(name: '_OverviewBase.overviewDishList');

  @override
  ObservableList<Dish> get overviewDishList {
    _$overviewDishListAtom.reportRead();
    return super.overviewDishList;
  }

  @override
  set overviewDishList(ObservableList<Dish> value) {
    _$overviewDishListAtom.reportWrite(value, super.overviewDishList, () {
      super.overviewDishList = value;
    });
  }

  final _$overviewIngredientListAtom =
      Atom(name: '_OverviewBase.overviewIngredientList');

  @override
  ObservableList<Ingredient> get overviewIngredientList {
    _$overviewIngredientListAtom.reportRead();
    return super.overviewIngredientList;
  }

  @override
  set overviewIngredientList(ObservableList<Ingredient> value) {
    _$overviewIngredientListAtom
        .reportWrite(value, super.overviewIngredientList, () {
      super.overviewIngredientList = value;
    });
  }

  final _$ingredientPresentMapAtom =
      Atom(name: '_OverviewBase.ingredientPresentMap');

  @override
  ObservableMap<String, int> get ingredientPresentMap {
    _$ingredientPresentMapAtom.reportRead();
    return super.ingredientPresentMap;
  }

  @override
  set ingredientPresentMap(ObservableMap<String, int> value) {
    _$ingredientPresentMapAtom.reportWrite(value, super.ingredientPresentMap,
        () {
      super.ingredientPresentMap = value;
    });
  }

  final _$initStoreAsyncAction = AsyncAction('_OverviewBase.initStore');

  @override
  Future<void> initStore(DateTime day) {
    return _$initStoreAsyncAction.run(() => super.initStore(day));
  }

  final _$initializeOverviewListAsyncAction =
      AsyncAction('_OverviewBase.initializeOverviewList');

  @override
  Future<void> initializeOverviewList(DateStore dateStore) {
    return _$initializeOverviewListAsyncAction
        .run(() => super.initializeOverviewList(dateStore));
  }

  final _$initializeIngredientListAsyncAction =
      AsyncAction('_OverviewBase.initializeIngredientList');

  @override
  Future<void> initializeIngredientList(DateStore dateStore) {
    return _$initializeIngredientListAsyncAction
        .run(() => super.initializeIngredientList(dateStore));
  }

  final _$getSymptomsOfADayAsyncAction =
      AsyncAction('_OverviewBase.getSymptomsOfADay');

  @override
  Future<void> getSymptomsOfADay(DateTime date) {
    return _$getSymptomsOfADayAsyncAction
        .run(() => super.getSymptomsOfADay(date));
  }

  final _$getSymptomSingleDayOfAPeriodAsyncAction =
      AsyncAction('_OverviewBase.getSymptomSingleDayOfAPeriod');

  @override
  Future<void> getSymptomSingleDayOfAPeriod(DateTime dateTime) {
    return _$getSymptomSingleDayOfAPeriodAsyncAction
        .run(() => super.getSymptomSingleDayOfAPeriod(dateTime));
  }

  final _$getDishesOfADayAsyncAction =
      AsyncAction('_OverviewBase.getDishesOfADay');

  @override
  Future<void> getDishesOfADay(DateTime date) {
    return _$getDishesOfADayAsyncAction.run(() => super.getDishesOfADay(date));
  }

  final _$getDishMealTimeAsyncAction =
      AsyncAction('_OverviewBase.getDishMealTime');

  @override
  Future<dynamic> getDishMealTime(MealTime mealTime, DateTime dateTime) {
    return _$getDishMealTimeAsyncAction
        .run(() => super.getDishMealTime(mealTime, dateTime));
  }

  final _$getIngredientSingleDayOfAPeriodAsyncAction =
      AsyncAction('_OverviewBase.getIngredientSingleDayOfAPeriod');

  @override
  Future<void> getIngredientSingleDayOfAPeriod(DateTime dateTime) {
    return _$getIngredientSingleDayOfAPeriodAsyncAction
        .run(() => super.getIngredientSingleDayOfAPeriod(dateTime));
  }

  final _$getIngredientOfADishAsyncAction =
      AsyncAction('_OverviewBase.getIngredientOfADish');

  @override
  Future<void> getIngredientOfADish(Dish dish) {
    return _$getIngredientOfADishAsyncAction
        .run(() => super.getIngredientOfADish(dish));
  }

  final _$_OverviewBaseActionController =
      ActionController(name: '_OverviewBase');

  @override
  int totalNumOfSymptomList() {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.totalNumOfSymptomList');
    try {
      return super.totalNumOfSymptomList();
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  int totalNumOfIngredientList() {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.totalNumOfIngredientList');
    try {
      return super.totalNumOfIngredientList();
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void totalOccurrenceSymptoms() {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.totalOccurrenceSymptoms');
    try {
      return super.totalOccurrenceSymptoms();
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void totalOccurrenceIngredients() {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.totalOccurrenceIngredients');
    try {
      return super.totalOccurrenceIngredients();
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
mapSymptomsOverview: ${mapSymptomsOverview},
overviewSymptomList: ${overviewSymptomList},
timeSelected: ${timeSelected},
symptomsPresentMap: ${symptomsPresentMap},
mapIngredientsOverview: ${mapIngredientsOverview},
overviewDishList: ${overviewDishList},
overviewIngredientList: ${overviewIngredientList},
ingredientPresentMap: ${ingredientPresentMap}
    ''';
  }
}
