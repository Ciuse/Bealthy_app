// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptomStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SymptomStore on _SymptomStoreBase, Store {
  final _$symptomListOfSpecificDayAtom =
      Atom(name: '_SymptomStoreBase.symptomListOfSpecificDay');

  @override
  ObservableList<Symptom> get symptomListOfSpecificDay {
    _$symptomListOfSpecificDayAtom.reportRead();
    return super.symptomListOfSpecificDay;
  }

  @override
  set symptomListOfSpecificDay(ObservableList<Symptom> value) {
    _$symptomListOfSpecificDayAtom
        .reportWrite(value, super.symptomListOfSpecificDay, () {
      super.symptomListOfSpecificDay = value;
    });
  }

  final _$symptomListAtom = Atom(name: '_SymptomStoreBase.symptomList');

  @override
  ObservableList<Symptom> get symptomList {
    _$symptomListAtom.reportRead();
    return super.symptomList;
  }

  @override
  set symptomList(ObservableList<Symptom> value) {
    _$symptomListAtom.reportWrite(value, super.symptomList, () {
      super.symptomList = value;
    });
  }

  final _$loadDaySymptomAtom = Atom(name: '_SymptomStoreBase.loadDaySymptom');

  @override
  ObservableFuture<dynamic> get loadDaySymptom {
    _$loadDaySymptomAtom.reportRead();
    return super.loadDaySymptom;
  }

  @override
  set loadDaySymptom(ObservableFuture<dynamic> value) {
    _$loadDaySymptomAtom.reportWrite(value, super.loadDaySymptom, () {
      super.loadDaySymptom = value;
    });
  }

  final _$initStoreAsyncAction = AsyncAction('_SymptomStoreBase.initStore');

  @override
  Future<void> initStore() {
    return _$initStoreAsyncAction.run(() => super.initStore());
  }

  final _$_getSymptomListAsyncAction =
      AsyncAction('_SymptomStoreBase._getSymptomList');

  @override
  Future<void> _getSymptomList() {
    return _$_getSymptomListAsyncAction.run(() => super._getSymptomList());
  }

  final _$_getSymptomOfADayAsyncAction =
      AsyncAction('_SymptomStoreBase._getSymptomOfADay');

  @override
  Future<void> _getSymptomOfADay(DateTime date) {
    return _$_getSymptomOfADayAsyncAction
        .run(() => super._getSymptomOfADay(date));
  }

  final _$_SymptomStoreBaseActionController =
      ActionController(name: '_SymptomStoreBase');

  @override
  Future<void> initGetSymptomOfADay(DateTime day) {
    final _$actionInfo = _$_SymptomStoreBaseActionController.startAction(
        name: '_SymptomStoreBase.initGetSymptomOfADay');
    try {
      return super.initGetSymptomOfADay(day);
    } finally {
      _$_SymptomStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearUserSymptomInADay() {
    final _$actionInfo = _$_SymptomStoreBaseActionController.startAction(
        name: '_SymptomStoreBase.clearUserSymptomInADay');
    try {
      return super.clearUserSymptomInADay();
    } finally {
      _$_SymptomStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserSymptomInADay(String symptomId) {
    final _$actionInfo = _$_SymptomStoreBaseActionController.startAction(
        name: '_SymptomStoreBase.setUserSymptomInADay');
    try {
      return super.setUserSymptomInADay(symptomId);
    } finally {
      _$_SymptomStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
symptomListOfSpecificDay: ${symptomListOfSpecificDay},
symptomList: ${symptomList},
loadDaySymptom: ${loadDaySymptom}
    ''';
  }
}
