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

  final _$calendarSelectedDateAtom =
      Atom(name: '_DateStoreBase.calendarSelectedDate');

  @override
  DateTime get calendarSelectedDate {
    _$calendarSelectedDateAtom.reportRead();
    return super.calendarSelectedDate;
  }

  @override
  set calendarSelectedDate(DateTime value) {
    _$calendarSelectedDateAtom.reportWrite(value, super.calendarSelectedDate,
        () {
      super.calendarSelectedDate = value;
    });
  }

  final _$overviewSelectedDateAtom =
      Atom(name: '_DateStoreBase.overviewSelectedDate');

  @override
  DateTime get overviewSelectedDate {
    _$overviewSelectedDateAtom.reportRead();
    return super.overviewSelectedDate;
  }

  @override
  set overviewSelectedDate(DateTime value) {
    _$overviewSelectedDateAtom.reportWrite(value, super.overviewSelectedDate,
        () {
      super.overviewSelectedDate = value;
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
  void nextDayCalendar() {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.nextDayCalendar');
    try {
      return super.nextDayCalendar();
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void previousDayCalendar() {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.previousDayCalendar');
    try {
      return super.previousDayCalendar();
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextDayOverview() {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.nextDayOverview');
    try {
      return super.nextDayOverview();
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void previousDayOverview() {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.previousDayOverview');
    try {
      return super.previousDayOverview();
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
calendarSelectedDate: ${calendarSelectedDate},
overviewSelectedDate: ${overviewSelectedDate},
weekDay: ${weekDay}
    ''';
  }
}
