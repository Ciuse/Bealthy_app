// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatmentStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TreatmentStore on _TreatmentStoreBase, Store {
  final _$treatmentsInProgressListAtom =
      Atom(name: '_TreatmentStoreBase.treatmentsInProgressList');

  @override
  ObservableList<Treatment> get treatmentsInProgressList {
    _$treatmentsInProgressListAtom.reportRead();
    return super.treatmentsInProgressList;
  }

  @override
  set treatmentsInProgressList(ObservableList<Treatment> value) {
    _$treatmentsInProgressListAtom
        .reportWrite(value, super.treatmentsInProgressList, () {
      super.treatmentsInProgressList = value;
    });
  }

  final _$treatmentsCompletedListAtom =
      Atom(name: '_TreatmentStoreBase.treatmentsCompletedList');

  @override
  ObservableList<Treatment> get treatmentsCompletedList {
    _$treatmentsCompletedListAtom.reportRead();
    return super.treatmentsCompletedList;
  }

  @override
  set treatmentsCompletedList(ObservableList<Treatment> value) {
    _$treatmentsCompletedListAtom
        .reportWrite(value, super.treatmentsCompletedList, () {
      super.treatmentsCompletedList = value;
    });
  }

  final _$mapSymptomPercentageAtom =
      Atom(name: '_TreatmentStoreBase.mapSymptomPercentage');

  @override
  ObservableMap<String, ObservableValues> get mapSymptomPercentage {
    _$mapSymptomPercentageAtom.reportRead();
    return super.mapSymptomPercentage;
  }

  @override
  set mapSymptomPercentage(ObservableMap<String, ObservableValues> value) {
    _$mapSymptomPercentageAtom.reportWrite(value, super.mapSymptomPercentage,
        () {
      super.mapSymptomPercentage = value;
    });
  }

  final _$initTreatmentsListAsyncAction =
      AsyncAction('_TreatmentStoreBase.initTreatmentsList');

  @override
  Future<void> initTreatmentsList(DateTime day) {
    return _$initTreatmentsListAsyncAction
        .run(() => super.initTreatmentsList(day));
  }

  final _$_getTreatmentsListAsyncAction =
      AsyncAction('_TreatmentStoreBase._getTreatmentsList');

  @override
  Future<void> _getTreatmentsList(DateTime date) {
    return _$_getTreatmentsListAsyncAction
        .run(() => super._getTreatmentsList(date));
  }

  final _$addNewTreatmentCreatedByUserAsyncAction =
      AsyncAction('_TreatmentStoreBase.addNewTreatmentCreatedByUser');

  @override
  Future<void> addNewTreatmentCreatedByUser(Treatment treatment) {
    return _$addNewTreatmentCreatedByUserAsyncAction
        .run(() => super.addNewTreatmentCreatedByUser(treatment));
  }

  final _$removeTreatmentCreatedByUserAsyncAction =
      AsyncAction('_TreatmentStoreBase.removeTreatmentCreatedByUser');

  @override
  Future<void> removeTreatmentCreatedByUser(Treatment treatment) {
    return _$removeTreatmentCreatedByUserAsyncAction
        .run(() => super.removeTreatmentCreatedByUser(treatment));
  }

  final _$getLastTreatmentIdAsyncAction =
      AsyncAction('_TreatmentStoreBase.getLastTreatmentId');

  @override
  Future<int> getLastTreatmentId() {
    return _$getLastTreatmentIdAsyncAction
        .run(() => super.getLastTreatmentId());
  }

  final _$calculateTreatmentEndedStatisticsAsyncAction =
      AsyncAction('_TreatmentStoreBase.calculateTreatmentEndedStatistics');

  @override
  Future<void> calculateTreatmentEndedStatistics(SymptomStore symptomStore) {
    return _$calculateTreatmentEndedStatisticsAsyncAction
        .run(() => super.calculateTreatmentEndedStatistics(symptomStore));
  }

  final _$_TreatmentStoreBaseActionController =
      ActionController(name: '_TreatmentStoreBase');

  @override
  DateTime setDateFromString(String dateTime) {
    final _$actionInfo = _$_TreatmentStoreBaseActionController.startAction(
        name: '_TreatmentStoreBase.setDateFromString');
    try {
      return super.setDateFromString(dateTime);
    } finally {
      _$_TreatmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
treatmentsInProgressList: ${treatmentsInProgressList},
treatmentsCompletedList: ${treatmentsCompletedList},
mapSymptomPercentage: ${mapSymptomPercentage}
    ''';
  }
}
