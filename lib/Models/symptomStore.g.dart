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

  final _$initStoreAsyncAction = AsyncAction('_SymptomStoreBase.initStore');

  @override
  Future<void> initStore() {
    return _$initStoreAsyncAction.run(() => super.initStore());
  }

  final _$_getsymptomListAsyncAction =
      AsyncAction('_SymptomStoreBase._getsymptomList');

  @override
  Future<void> _getsymptomList() {
    return _$_getsymptomListAsyncAction.run(() => super._getsymptomList());
  }

  @override
  String toString() {
    return '''
symptomList: ${symptomList}
    ''';
  }
}
