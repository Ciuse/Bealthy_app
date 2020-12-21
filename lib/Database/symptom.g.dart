// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Symptom on _SymptomBase, Store {
  final _$idAtom = Atom(name: '_SymptomBase.id');

  @override
  String get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(String value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  final _$nameAtom = Atom(name: '_SymptomBase.name');

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  final _$intensityAtom = Atom(name: '_SymptomBase.intensity');

  @override
  int get intensity {
    _$intensityAtom.reportRead();
    return super.intensity;
  }

  @override
  set intensity(int value) {
    _$intensityAtom.reportWrite(value, super.intensity, () {
      super.intensity = value;
    });
  }

  final _$frequencyAtom = Atom(name: '_SymptomBase.frequency');

  @override
  int get frequency {
    _$frequencyAtom.reportRead();
    return super.frequency;
  }

  @override
  set frequency(int value) {
    _$frequencyAtom.reportWrite(value, super.frequency, () {
      super.frequency = value;
    });
  }

  final _$mealTimeAtom = Atom(name: '_SymptomBase.mealTime');

  @override
  List<dynamic> get mealTime {
    _$mealTimeAtom.reportRead();
    return super.mealTime;
  }

  @override
  set mealTime(List<dynamic> value) {
    _$mealTimeAtom.reportWrite(value, super.mealTime, () {
      super.mealTime = value;
    });
  }

  final _$isSymptomSelectDayAtom =
      Atom(name: '_SymptomBase.isSymptomSelectDay');

  @override
  bool get isSymptomSelectDay {
    _$isSymptomSelectDayAtom.reportRead();
    return super.isSymptomSelectDay;
  }

  @override
  set isSymptomSelectDay(bool value) {
    _$isSymptomSelectDayAtom.reportWrite(value, super.isSymptomSelectDay, () {
      super.isSymptomSelectDay = value;
    });
  }

  final _$mealTimeBoolListAtom = Atom(name: '_SymptomBase.mealTimeBoolList');

  @override
  List<MealTimeBool> get mealTimeBoolList {
    _$mealTimeBoolListAtom.reportRead();
    return super.mealTimeBoolList;
  }

  @override
  set mealTimeBoolList(List<MealTimeBool> value) {
    _$mealTimeBoolListAtom.reportWrite(value, super.mealTimeBoolList, () {
      super.mealTimeBoolList = value;
    });
  }

  final _$initStoreAsyncAction = AsyncAction('_SymptomBase.initStore');

  @override
  Future<void> initStore() {
    return _$initStoreAsyncAction.run(() => super.initStore());
  }

  final _$_SymptomBaseActionController = ActionController(name: '_SymptomBase');

  @override
  void createMealTimeListBool() {
    final _$actionInfo = _$_SymptomBaseActionController.startAction(
        name: '_SymptomBase.createMealTimeListBool');
    try {
      return super.createMealTimeListBool();
    } finally {
      _$_SymptomBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMealTimeBoolList() {
    final _$actionInfo = _$_SymptomBaseActionController.startAction(
        name: '_SymptomBase.setMealTimeBoolList');
    try {
      return super.setMealTimeBoolList();
    } finally {
      _$_SymptomBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetMealTimeBoolList() {
    final _$actionInfo = _$_SymptomBaseActionController.startAction(
        name: '_SymptomBase.resetMealTimeBoolList');
    try {
      return super.resetMealTimeBoolList();
    } finally {
      _$_SymptomBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsSymptomInADay(bool value) {
    final _$actionInfo = _$_SymptomBaseActionController.startAction(
        name: '_SymptomBase.setIsSymptomInADay');
    try {
      return super.setIsSymptomInADay(value);
    } finally {
      _$_SymptomBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIntensity(int value) {
    final _$actionInfo = _$_SymptomBaseActionController.startAction(
        name: '_SymptomBase.setIntensity');
    try {
      return super.setIntensity(value);
    } finally {
      _$_SymptomBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFrequency(int value) {
    final _$actionInfo = _$_SymptomBaseActionController.startAction(
        name: '_SymptomBase.setFrequency');
    try {
      return super.setFrequency(value);
    } finally {
      _$_SymptomBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMealTime(List<dynamic> value) {
    final _$actionInfo = _$_SymptomBaseActionController.startAction(
        name: '_SymptomBase.setMealTime');
    try {
      return super.setMealTime(value);
    } finally {
      _$_SymptomBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetValue() {
    final _$actionInfo = _$_SymptomBaseActionController.startAction(
        name: '_SymptomBase.resetValue');
    try {
      return super.resetValue();
    } finally {
      _$_SymptomBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
id: ${id},
name: ${name},
intensity: ${intensity},
frequency: ${frequency},
mealTime: ${mealTime},
isSymptomSelectDay: ${isSymptomSelectDay},
mealTimeBoolList: ${mealTimeBoolList}
    ''';
  }
}
