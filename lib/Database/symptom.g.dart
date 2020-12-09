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

  final _$mealTimeAtom = Atom(name: '_SymptomBase.mealTime');

  @override
  String get mealTime {
    _$mealTimeAtom.reportRead();
    return super.mealTime;
  }

  @override
  set mealTime(String value) {
    _$mealTimeAtom.reportWrite(value, super.mealTime, () {
      super.mealTime = value;
    });
  }

  final _$isSymptomInADayAtom = Atom(name: '_SymptomBase.isSymptomInADay');

  @override
  bool get isSymptomInADay {
    _$isSymptomInADayAtom.reportRead();
    return super.isSymptomInADay;
  }

  @override
  set isSymptomInADay(bool value) {
    _$isSymptomInADayAtom.reportWrite(value, super.isSymptomInADay, () {
      super.isSymptomInADay = value;
    });
  }

  final _$_SymptomBaseActionController = ActionController(name: '_SymptomBase');

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
  String toString() {
    return '''
id: ${id},
name: ${name},
intensity: ${intensity},
mealTime: ${mealTime},
isSymptomInADay: ${isSymptomInADay}
    ''';
  }
}
