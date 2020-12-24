// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overviewStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OverviewStore on _OverviewBase, Store {
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

  final _$initStoreAsyncAction = AsyncAction('_OverviewBase.initStore');

  @override
  Future<void> initStore(DateTime day) {
    return _$initStoreAsyncAction.run(() => super.initStore(day));
  }

  final _$getSymptomsOfADayAsyncAction =
      AsyncAction('_OverviewBase.getSymptomsOfADay');

  @override
  Future<void> getSymptomsOfADay(DateTime date) {
    return _$getSymptomsOfADayAsyncAction
        .run(() => super.getSymptomsOfADay(date));
  }

  @override
  String toString() {
    return '''
overviewSymptomList: ${overviewSymptomList}
    ''';
  }
}
