// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diseaseStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DiseaseStore on _DiseaseStoreBase, Store {
  final _$diseaseListAtom = Atom(name: '_DiseaseStoreBase.diseaseList');

  @override
  ObservableList<Disease> get diseaseList {
    _$diseaseListAtom.reportRead();
    return super.diseaseList;
  }

  @override
  set diseaseList(ObservableList<Disease> value) {
    _$diseaseListAtom.reportWrite(value, super.diseaseList, () {
      super.diseaseList = value;
    });
  }

  final _$initStoreAsyncAction = AsyncAction('_DiseaseStoreBase.initStore');

  @override
  Future<void> initStore() {
    return _$initStoreAsyncAction.run(() => super.initStore());
  }

  final _$_getDiseaseListAsyncAction =
      AsyncAction('_DiseaseStoreBase._getDiseaseList');

  @override
  Future<void> _getDiseaseList() {
    return _$_getDiseaseListAsyncAction.run(() => super._getDiseaseList());
  }

  @override
  String toString() {
    return '''
diseaseList: ${diseaseList}
    ''';
  }
}
