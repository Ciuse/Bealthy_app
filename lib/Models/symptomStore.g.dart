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

  final _$mapSymptomTreatmentAtom =
      Atom(name: '_SymptomStoreBase.mapSymptomTreatment');

  @override
  ObservableMap<String, ObservableValues> get mapSymptomTreatment {
    _$mapSymptomTreatmentAtom.reportRead();
    return super.mapSymptomTreatment;
  }

  @override
  set mapSymptomTreatment(ObservableMap<String, ObservableValues> value) {
    _$mapSymptomTreatmentAtom.reportWrite(value, super.mapSymptomTreatment, () {
      super.mapSymptomTreatment = value;
    });
  }

  final _$mapSymptomBeforeTreatmentAtom =
      Atom(name: '_SymptomStoreBase.mapSymptomBeforeTreatment');

  @override
  ObservableMap<String, ObservableValues> get mapSymptomBeforeTreatment {
    _$mapSymptomBeforeTreatmentAtom.reportRead();
    return super.mapSymptomBeforeTreatment;
  }

  @override
  set mapSymptomBeforeTreatment(ObservableMap<String, ObservableValues> value) {
    _$mapSymptomBeforeTreatmentAtom
        .reportWrite(value, super.mapSymptomBeforeTreatment, () {
      super.mapSymptomBeforeTreatment = value;
    });
  }

  final _$mapTreatmentsAtom = Atom(name: '_SymptomStoreBase.mapTreatments');

  @override
  ObservableMap<String, ObservableValues> get mapTreatments {
    _$mapTreatmentsAtom.reportRead();
    return super.mapTreatments;
  }

  @override
  set mapTreatments(ObservableMap<String, ObservableValues> value) {
    _$mapTreatmentsAtom.reportWrite(value, super.mapTreatments, () {
      super.mapTreatments = value;
    });
  }

  final _$loadSymptomDayAtom = Atom(name: '_SymptomStoreBase.loadSymptomDay');

  @override
  ObservableFuture<dynamic> get loadSymptomDay {
    _$loadSymptomDayAtom.reportRead();
    return super.loadSymptomDay;
  }

  @override
  set loadSymptomDay(ObservableFuture<dynamic> value) {
    _$loadSymptomDayAtom.reportWrite(value, super.loadSymptomDay, () {
      super.loadSymptomDay = value;
    });
  }

  final _$loadTreatmentMapAtom =
      Atom(name: '_SymptomStoreBase.loadTreatmentMap');

  @override
  ObservableFuture<dynamic> get loadTreatmentMap {
    _$loadTreatmentMapAtom.reportRead();
    return super.loadTreatmentMap;
  }

  @override
  set loadTreatmentMap(ObservableFuture<dynamic> value) {
    _$loadTreatmentMapAtom.reportWrite(value, super.loadTreatmentMap, () {
      super.loadTreatmentMap = value;
    });
  }

  final _$loadTreatmentsAtom = Atom(name: '_SymptomStoreBase.loadTreatments');

  @override
  ObservableFuture<dynamic> get loadTreatments {
    _$loadTreatmentsAtom.reportRead();
    return super.loadTreatments;
  }

  @override
  set loadTreatments(ObservableFuture<dynamic> value) {
    _$loadTreatmentsAtom.reportWrite(value, super.loadTreatments, () {
      super.loadTreatments = value;
    });
  }

  final _$loadBeforeTreatmentMapAtom =
      Atom(name: '_SymptomStoreBase.loadBeforeTreatmentMap');

  @override
  ObservableFuture<dynamic> get loadBeforeTreatmentMap {
    _$loadBeforeTreatmentMapAtom.reportRead();
    return super.loadBeforeTreatmentMap;
  }

  @override
  set loadBeforeTreatmentMap(ObservableFuture<dynamic> value) {
    _$loadBeforeTreatmentMapAtom
        .reportWrite(value, super.loadBeforeTreatmentMap, () {
      super.loadBeforeTreatmentMap = value;
    });
  }

  final _$completerAtom = Atom(name: '_SymptomStoreBase.completer');

  @override
  Completer<dynamic> get completer {
    _$completerAtom.reportRead();
    return super.completer;
  }

  @override
  set completer(Completer<dynamic> value) {
    _$completerAtom.reportWrite(value, super.completer, () {
      super.completer = value;
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

  final _$initSymptomDayAsyncAction =
      AsyncAction('_SymptomStoreBase.initSymptomDay');

  @override
  Future<void> initSymptomDay(DateTime day) {
    return _$initSymptomDayAsyncAction.run(() => super.initSymptomDay(day));
  }

  final _$_getSymptomsOfADayAsyncAction =
      AsyncAction('_SymptomStoreBase._getSymptomsOfADay');

  @override
  Future<void> _getSymptomsOfADay(DateTime date) {
    return _$_getSymptomsOfADayAsyncAction
        .run(() => super._getSymptomsOfADay(date));
  }

  final _$initTreatmentsAsyncAction =
      AsyncAction('_SymptomStoreBase.initTreatments');

  @override
  Future<void> initTreatments(List<Treatment> treatments, DateStore dateStore,
      TreatmentStore treatmentStore, SymptomStore symptomStore) {
    return _$initTreatmentsAsyncAction.run(() => super
        .initTreatments(treatments, dateStore, treatmentStore, symptomStore));
  }

  final _$initTreatmentMapAsyncAction =
      AsyncAction('_SymptomStoreBase.initTreatmentMap');

  @override
  Future<void> initTreatmentMap(List<DateTime> days) {
    return _$initTreatmentMapAsyncAction
        .run(() => super.initTreatmentMap(days));
  }

  final _$initBeforeTreatmentMapAsyncAction =
      AsyncAction('_SymptomStoreBase.initBeforeTreatmentMap');

  @override
  Future<void> initBeforeTreatmentMap(List<DateTime> days) {
    return _$initBeforeTreatmentMapAsyncAction
        .run(() => super.initBeforeTreatmentMap(days));
  }

  final _$_fillTreatmentMapAsyncAction =
      AsyncAction('_SymptomStoreBase._fillTreatmentMap');

  @override
  Future<void> _fillTreatmentMap(DateTime date, String symptomId) {
    return _$_fillTreatmentMapAsyncAction
        .run(() => super._fillTreatmentMap(date, symptomId));
  }

  final _$_fillBeforeTreatmentMapAsyncAction =
      AsyncAction('_SymptomStoreBase._fillBeforeTreatmentMap');

  @override
  Future<void> _fillBeforeTreatmentMap(DateTime date, String symptomId) {
    return _$_fillBeforeTreatmentMapAsyncAction
        .run(() => super._fillBeforeTreatmentMap(date, symptomId));
  }

  final _$createOccurrenceSymptomAsyncAction =
      AsyncAction('_SymptomStoreBase.createOccurrenceSymptom');

  @override
  Future<void> createOccurrenceSymptom(Symptom symptom) {
    return _$createOccurrenceSymptomAsyncAction
        .run(() => super.createOccurrenceSymptom(symptom));
  }

  final _$updateOccurrenceSymptomAsyncAction =
      AsyncAction('_SymptomStoreBase.updateOccurrenceSymptom');

  @override
  Future<void> updateOccurrenceSymptom(String symptomId, int newOccurrence) {
    return _$updateOccurrenceSymptomAsyncAction
        .run(() => super.updateOccurrenceSymptom(symptomId, newOccurrence));
  }

  final _$updateSymptomAsyncAction =
      AsyncAction('_SymptomStoreBase.updateSymptom');

  @override
  Future<void> updateSymptom(Symptom symptom, DateTime date) {
    return _$updateSymptomAsyncAction
        .run(() => super.updateSymptom(symptom, date));
  }

  final _$removeSymptomOfSpecificDayAsyncAction =
      AsyncAction('_SymptomStoreBase.removeSymptomOfSpecificDay');

  @override
  Future<void> removeSymptomOfSpecificDay(Symptom symptom, DateTime date) {
    return _$removeSymptomOfSpecificDayAsyncAction
        .run(() => super.removeSymptomOfSpecificDay(symptom, date));
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
  Future<void> waitForFutures() {
    final _$actionInfo = _$_SymptomStoreBaseActionController.startAction(
        name: '_SymptomStoreBase.waitForFutures');
    try {
      return super.waitForFutures();
    } finally {
      _$_SymptomStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  double mealTimeValueSymptom(Symptom symptom) {
    final _$actionInfo = _$_SymptomStoreBaseActionController.startAction(
        name: '_SymptomStoreBase.mealTimeValueSymptom');
    try {
      return super.mealTimeValueSymptom(symptom);
    } finally {
      _$_SymptomStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void createStringMealTime(Symptom symptom) {
    final _$actionInfo = _$_SymptomStoreBaseActionController.startAction(
        name: '_SymptomStoreBase.createStringMealTime');
    try {
      return super.createStringMealTime(symptom);
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
symptomListOfSpecificDay: ${symptomListOfSpecificDay},
mapSymptomTreatment: ${mapSymptomTreatment},
mapSymptomBeforeTreatment: ${mapSymptomBeforeTreatment},
mapTreatments: ${mapTreatments},
loadSymptomDay: ${loadSymptomDay},
loadTreatmentMap: ${loadTreatmentMap},
loadTreatments: ${loadTreatments},
loadBeforeTreatmentMap: ${loadBeforeTreatmentMap},
completer: ${completer}
    ''';
  }
}
