// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overviewStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OverviewStore on _OverviewBase, Store {
  final _$mapOverviewAtom = Atom(name: '_OverviewBase.mapOverview');

  @override
  ObservableMap<DateTime, List<Symptom>> get mapSymptomsOverview {
    _$mapOverviewAtom.reportRead();
    return super.mapSymptomsOverview;
  }

  @override
  set mapSymptomsOverview(ObservableMap<DateTime, List<Symptom>> value) {
    _$mapOverviewAtom.reportWrite(value, super.mapSymptomsOverview, () {
      super.mapSymptomsOverview = value;
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

  final _$timeSelectedAtom = Atom(name: '_OverviewBase.timeSelected');

  @override
  TemporalTime get timeSelected {
    _$timeSelectedAtom.reportRead();
    return super.timeSelected;
  }

  @override
  set timeSelected(TemporalTime value) {
    _$timeSelectedAtom.reportWrite(value, super.timeSelected, () {
      super.timeSelected = value;
    });
  }

  final _$symptomsPresentMapAtom =
      Atom(name: '_OverviewBase.symptomsPresentMap');

  @override
  ObservableMap<String, int> get symptomsPresentMap {
    _$symptomsPresentMapAtom.reportRead();
    return super.symptomsPresentMap;
  }

  @override
  set symptomsPresentMap(ObservableMap<String, int> value) {
    _$symptomsPresentMapAtom.reportWrite(value, super.symptomsPresentMap, () {
      super.symptomsPresentMap = value;
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

  final _$ingredientPresentMapAtom =
      Atom(name: '_OverviewBase.ingredientPresentMap');

  @override
  ObservableMap<String, int> get ingredientPresentMap {
    _$ingredientPresentMapAtom.reportRead();
    return super.ingredientPresentMap;
  }

  @override
  set ingredientPresentMap(ObservableMap<String, int> value) {
    _$ingredientPresentMapAtom.reportWrite(value, super.ingredientPresentMap,
        () {
      super.ingredientPresentMap = value;
    });
  }

  final _$initStoreAsyncAction = AsyncAction('_OverviewBase.initStore');

  @override
  Future<void> initStore(DateTime day) {
    return _$initStoreAsyncAction.run(() => super.initStore(day));
  }

  final _$initializeOverviewListAsyncAction =
      AsyncAction('_OverviewBase.initializeOverviewList');

  @override
  Future<void> initializeOverviewList(DateStore dateStore) {
    return _$initializeOverviewListAsyncAction
        .run(() => super.initializeOverviewList(dateStore));
  }

  final _$getSymptomsOfADayAsyncAction =
      AsyncAction('_OverviewBase.getSymptomsOfADay');

  @override
  Future<void> getSymptomsOfADay(DateTime date) {
    return _$getSymptomsOfADayAsyncAction
        .run(() => super.getSymptomsOfADay(date));
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
  void numOfCategorySymptoms() {
    final _$actionInfo = _$_OverviewBaseActionController.startAction(
        name: '_OverviewBase.numOfCategorySymptoms');
    try {
      return super.numOfCategorySymptoms();
    } finally {
      _$_OverviewBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
mapOverview: ${mapSymptomsOverview},
overviewSymptomList: ${overviewSymptomList},
timeSelected: ${timeSelected},
symptomsPresentMap: ${symptomsPresentMap},
overviewIngredientList: ${overviewIngredientList},
ingredientPresentMap: ${ingredientPresentMap}
    ''';
  }
}
