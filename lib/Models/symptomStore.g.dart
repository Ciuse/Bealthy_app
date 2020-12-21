// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptomStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SymptomStore on _SymptomStoreBase, Store {
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

  final _$ratingAtom = Atom(name: '_SymptomStoreBase.rating');

  @override
  double get rating {
    _$ratingAtom.reportRead();
    return super.rating;
  }

  @override
  set rating(double value) {
    _$ratingAtom.reportWrite(value, super.rating, () {
      super.rating = value;
    });
  }

  final _$initStoreAsyncAction = AsyncAction('_SymptomStoreBase.initStore');

  @override
  Future<void> initStore(DateTime day) {
    return _$initStoreAsyncAction.run(() => super.initStore(day));
  }

  final _$_getSymptomListAsyncAction =
      AsyncAction('_SymptomStoreBase._getSymptomList');

  @override
  Future<void> _getSymptomList() {
    return _$_getSymptomListAsyncAction.run(() => super._getSymptomList());
  }

  final _$getSymptomsOfADayAsyncAction =
      AsyncAction('_SymptomStoreBase.getSymptomsOfADay');

  @override
  Future<void> getSymptomsOfADay(DateTime date) {
    return _$getSymptomsOfADayAsyncAction
        .run(() => super.getSymptomsOfADay(date));
  }

  final _$_SymptomStoreBaseActionController =
      ActionController(name: '_SymptomStoreBase');

  @override
  Symptom getSymptomFromList(String symptomId) {
    final _$actionInfo = _$_SymptomStoreBaseActionController.startAction(
        name: '_SymptomStoreBase.getSymptomFromList');
    try {
      return super.getSymptomFromList(symptomId);
    } finally {
      _$_SymptomStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _resetSymptomsValue() {
    final _$actionInfo = _$_SymptomStoreBaseActionController.startAction(
        name: '_SymptomStoreBase._resetSymptomsValue');
    try {
      return super._resetSymptomsValue();
    } finally {
      _$_SymptomStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
symptomList: ${symptomList},
rating: ${rating}
    ''';
  }
}
