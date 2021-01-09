// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserStore on _UserStoreBase, Store {
  final _$profileImageAtom = Atom(name: '_UserStoreBase.profileImage');

  @override
  File get profileImage {
    _$profileImageAtom.reportRead();
    return super.profileImage;
  }

  @override
  set profileImage(File value) {
    _$profileImageAtom.reportWrite(value, super.profileImage, () {
      super.profileImage = value;
    });
  }

  final _$loadInitOccurrenceSymptomsListAtom =
      Atom(name: '_UserStoreBase.loadInitOccurrenceSymptomsList');

  @override
  ObservableFuture<dynamic> get loadInitOccurrenceSymptomsList {
    _$loadInitOccurrenceSymptomsListAtom.reportRead();
    return super.loadInitOccurrenceSymptomsList;
  }

  @override
  set loadInitOccurrenceSymptomsList(ObservableFuture<dynamic> value) {
    _$loadInitOccurrenceSymptomsListAtom
        .reportWrite(value, super.loadInitOccurrenceSymptomsList, () {
      super.loadInitOccurrenceSymptomsList = value;
    });
  }

  final _$initPersonalPageAsyncAction =
      AsyncAction('_UserStoreBase.initPersonalPage');

  @override
  Future<void> initPersonalPage() {
    return _$initPersonalPageAsyncAction.run(() => super.initPersonalPage());
  }

  final _$occurrenceInitAsyncAction =
      AsyncAction('_UserStoreBase.occurrenceInit');

  @override
  Future<void> occurrenceInit() {
    return _$occurrenceInitAsyncAction.run(() => super.occurrenceInit());
  }

  final _$_getSymptomListForPersonalPageAsyncAction =
      AsyncAction('_UserStoreBase._getSymptomListForPersonalPage');

  @override
  Future<void> _getSymptomListForPersonalPage() {
    return _$_getSymptomListForPersonalPageAsyncAction
        .run(() => super._getSymptomListForPersonalPage());
  }

  final _$_UserStoreBaseActionController =
      ActionController(name: '_UserStoreBase');

  @override
  Future<void> retryForOccurrenceSymptoms() {
    final _$actionInfo = _$_UserStoreBaseActionController.startAction(
        name: '_UserStoreBase.retryForOccurrenceSymptoms');
    try {
      return super.retryForOccurrenceSymptoms();
    } finally {
      _$_UserStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
profileImage: ${profileImage},
loadInitOccurrenceSymptomsList: ${loadInitOccurrenceSymptomsList}
    ''';
  }
}
