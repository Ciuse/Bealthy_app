// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dateStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DateStore on _DateStoreBase, Store {
  Computed<int> _$weekDayComputed;

  @override
  int get weekDay => (_$weekDayComputed ??=
          Computed<int>(() => super.weekDay, name: '_DateStoreBase.weekDay'))
      .value;

  final _$selectedDateAtom = Atom(name: '_DateStoreBase.selectedDate');

  @override
  DateTime get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(DateTime value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  final _$_DateStoreBaseActionController =
      ActionController(name: '_DateStoreBase');

  @override
  void changeCurrentDate(DateTime date) {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.changeCurrentDate');
    try {
      return super.changeCurrentDate(date);
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void fixDate(DateTime date) {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.fixDate');
    try {
      return super.fixDate(date);
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextDay(DateTime day) {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.nextDay');
    try {
      return super.nextDay(day);
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void previousDay(DateTime day) {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.previousDay');
    try {
      return super.previousDay(day);
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedDate: ${selectedDate},
weekDay: ${weekDay}
    ''';
  }
}
