// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overviewStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OverviewStore on _OverviewBase, Store {
  final _$mapSymptomsOverviewPeriodAtom =
      Atom(name: '_OverviewBase.mapSymptomsOverviewPeriod');

  @override
  ObservableMap<DateTime, List<Symptom>> get mapSymptomsOverviewPeriod {
    _$mapSymptomsOverviewPeriodAtom.reportRead();
    return super.mapSymptomsOverviewPeriod;
  }

  @override
  set mapSymptomsOverviewPeriod(ObservableMap<DateTime, List<Symptom>> value) {
    _$mapSymptomsOverviewPeriodAtom
        .reportWrite(value, super.mapSymptomsOverviewPeriod, () {
      super.mapSymptomsOverviewPeriod = value;
    });
  }

  final _$mapSymptomsOverviewDayAtom =
      Atom(name: '_OverviewBase.mapSymptomsOverviewDay');

  @override
  ObservableMap<MealTime, List<Symptom>> get mapSymptomsOverviewDay {
    _$mapSymptomsOverviewDayAtom.reportRead();
    return super.mapSymptomsOverviewDay;
  }

  @override
  set mapSymptomsOverviewDay(ObservableMap<MealTime, List<Symptom>> value) {
    _$mapSymptomsOverviewDayAtom
        .reportWrite(value, super.mapSymptomsOverviewDay, () {
      super.mapSymptomsOverviewDay = value;
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

  final _$totalOccurrenceSymptomAtom =
      Atom(name: '_OverviewBase.totalOccurrenceSymptom');

  @override
  ObservableMap<String, int> get totalOccurrenceSymptom {
    _$totalOccurrenceSymptomAtom.reportRead();
    return super.totalOccurrenceSymptom;
  }

  @override
  set totalOccurrenceSymptom(ObservableMap<String, int> value) {
    _$totalOccurrenceSymptomAtom
        .reportWrite(value, super.totalOccurrenceSymptom, () {
      super.totalOccurrenceSymptom = value;
    });
  }

  final _$dayOccurrenceSymptomAtom =
      Atom(name: '_OverviewBase.dayOccurrenceSymptom');

  @override
  SortedMap<String, int> get dayOccurrenceSymptom {
    _$dayOccurrenceSymptomAtom.reportRead();
    return super.dayOccurrenceSymptom;
  }

  @override
  set dayOccurrenceSymptom(SortedMap<String, int> value) {
    _$dayOccurrenceSymptomAtom.reportWrite(value, super.dayOccurrenceSymptom,
        () {
      super.dayOccurrenceSymptom = value;
    });
  }

  final _$mapIngredientsOverviewPeriodAtom =
      Atom(name: '_OverviewBase.mapIngredientsOverviewPeriod');

  @override
  ObservableMap<DateTime, List<Ingredient>> get mapIngredientsOverviewPeriod {
    _$mapIngredientsOverviewPeriodAtom.reportRead();
    return super.mapIngredientsOverviewPeriod;
  }

  @override
  set mapIngredientsOverviewPeriod(
      ObservableMap<DateTime, List<Ingredient>> value) {
    _$mapIngredientsOverviewPeriodAtom
        .reportWrite(value, super.mapIngredientsOverviewPeriod, () {
      super.mapIngredientsOverviewPeriod = value;
    });
  }

  final _$mapIngredientsOverviewDayAtom =
      Atom(name: '_OverviewBase.mapIngredientsOverviewDay');

  @override
  ObservableMap<MealTime, List<Ingredient>> get mapIngredientsOverviewDay {
    _$mapIngredientsOverviewDayAtom.reportRead();
    return super.mapIngredientsOverviewDay;
  }

  @override
  set mapIngredientsOverviewDay(
      ObservableMap<MealTime, List<Ingredient>> value) {
    _$mapIngredientsOverviewDayAtom
        .reportWrite(value, super.mapIngredientsOverviewDay, () {
      super.mapIngredientsOverviewDay = value;
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

  final _$totalOccurrenceIngredientAtom =
      Atom(name: '_OverviewBase.totalOccurrenceIngredient');

  @override
  ObservableMap<String, int> get totalOccurrenceIngredient {
    _$totalOccurrenceIngredientAtom.reportRead();
    return super.totalOccurrenceIngredient;
  }

  @override
  set totalOccurrenceIngredient(ObservableMap<String, int> value) {
    _$totalOccurrenceIngredientAtom
        .reportWrite(value, super.totalOccurrenceIngredient, () {
      super.totalOccurrenceIngredient = value;
    });
  }

  final _$dayOccurrenceIngredientBySymptomAtom =
      Atom(name: '_OverviewBase.dayOccurrenceIngredientBySymptom');

  @override
  ObservableMap<String, int> get dayOccurrenceIngredientBySymptom {
    _$dayOccurrenceIngredientBySymptomAtom.reportRead();
    return super.dayOccurrenceIngredientBySymptom;
  }

  @override
  set dayOccurrenceIngredientBySymptom(ObservableMap<String, int> value) {
    _$dayOccurrenceIngredientBySymptomAtom
        .reportWrite(value, super.dayOccurrenceIngredientBySymptom, () {
      super.dayOccurrenceIngredientBySymptom = value;
    });
  }

  final _$totalOccurrenceIngredientBySymptomAtom =
      Atom(name: '_OverviewBase.totalOccurrenceIngredientBySymptom');

  @override
  ObservableMap<String, int> get totalOccurrenceIngredientBySymptom {
    _$totalOccurrenceIngredientBySymptomAtom.reportRead();
    return super.totalOccurrenceIngredientBySymptom;
  }

  @override
  set totalOccurrenceIngredientBySymptom(ObservableMap<String, int> value) {
    _$totalOccurrenceIngredientBySymptomAtom
        .reportWrite(value, super.totalOccurrenceIngredientBySymptom, () {
      super.totalOccurrenceIngredientBySymptom = value;
    });
  }

  final _$initStoreAsyncAction = AsyncAction('_OverviewBase.initStore');

  @override
  Future<void> initStore(DateTime day) {
    return _$initStoreAsyncAction.run(() => super.initStore(day));
  }

  final _$initializeSymptomsMapAsyncAction =
      AsyncAction('_OverviewBase.initializeSymptomsMap');

  @override
  Future<void> initializeSymptomsMap(DateStore dateStore) {
    return _$initializeSymptomsMapAsyncAction
        .run(() => super.initializeSymptomsMap(dateStore));
  }

  final _$initializeIngredientMapAsyncAction =
      AsyncAction('_OverviewBase.initializeIngredientMap');

  @override
  Future<void> initializeIngredientMap(DateStore dateStore) {
    return _$initializeIngredientMapAsyncAction
        .run(() => super.initializeIngredientMap(dateStore));
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

  final _$getDishMealTimeAsyncAction =
      AsyncAction('_OverviewBase.getDishMealTime');

  @override
  Future<dynamic> getDishMealTime(MealTime mealTime, DateTime dateTime) {
    return _$getDishMealTimeAsyncAction
        .run(() => super.getDishMealTime(mealTime, dateTime));
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
  void totalOccurrenceSymptomsDay() {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.totalOccurrenceSymptomsDay');
    try {
      return super.totalOccurrenceSymptomsDay();
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void totalOccurrenceSymptomsPeriod() {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.totalOccurrenceSymptomsPeriod');
    try {
      return super.totalOccurrenceSymptomsPeriod();
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void totalOccurrenceIngredientsPeriod() {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.totalOccurrenceIngredientsPeriod');
    try {
      return super.totalOccurrenceIngredientsPeriod();
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void totalOccurrenceIngredientsDay() {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.totalOccurrenceIngredientsDay');
    try {
      return super.totalOccurrenceIngredientsDay();
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getTotalIngredientBySymptomOfAPeriod(String symptomId) {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.getTotalIngredientBySymptomOfAPeriod');
    try {
      return super.getTotalIngredientBySymptomOfAPeriod(symptomId);
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getTotalIngredientBySymptomOfADay(String symptomId) {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.getTotalIngredientBySymptomOfADay');
    try {
      return super.getTotalIngredientBySymptomOfADay(symptomId);
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getIngredientBySymptomDayOfAPeriod(DateTime dateTime, String symptomId) {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.getIngredientBySymptomDayOfAPeriod');
    try {
      return super.getIngredientBySymptomDayOfAPeriod(dateTime, symptomId);
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getIngredientBySymptomMealTimeOfADay(
      MealTime mealTime, String symptomId) {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.getIngredientBySymptomMealTimeOfADay');
    try {
      return super.getIngredientBySymptomMealTimeOfADay(mealTime, symptomId);
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMealTimeSymptomMap() {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.setMealTimeSymptomMap');
    try {
      return super.setMealTimeSymptomMap();
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  double mealTimeValueSymptom(Symptom symptom) {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.mealTimeValueSymptom');
    try {
      return super.mealTimeValueSymptom(symptom);
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initializeOverviewValueDay(String symptomId) {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.initializeOverviewValueDay');
    try {
      return super.initializeOverviewValueDay(symptomId);
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initializeOverviewValuePeriod(DateTime dateTime, String symptomId) {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.initializeOverviewValuePeriod');
    try {
      return super.initializeOverviewValuePeriod(dateTime, symptomId);
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
mapSymptomsOverviewPeriod: ${mapSymptomsOverviewPeriod},
mapSymptomsOverviewDay: ${mapSymptomsOverviewDay},
overviewSymptomList: ${overviewSymptomList},
totalOccurrenceSymptom: ${totalOccurrenceSymptom},
dayOccurrenceSymptom: ${dayOccurrenceSymptom},
mapIngredientsOverviewPeriod: ${mapIngredientsOverviewPeriod},
mapIngredientsOverviewDay: ${mapIngredientsOverviewDay},
overviewDishList: ${overviewDishList},
overviewIngredientList: ${overviewIngredientList},
totalOccurrenceIngredient: ${totalOccurrenceIngredient},
dayOccurrenceIngredientBySymptom: ${dayOccurrenceIngredientBySymptom},
totalOccurrenceIngredientBySymptom: ${totalOccurrenceIngredientBySymptom}
    ''';
  }
}
