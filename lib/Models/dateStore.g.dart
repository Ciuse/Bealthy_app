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

  final _$overviewDefaultLastDateAtom =
      Atom(name: '_DateStoreBase.overviewDefaultLastDate');

  @override
  DateTime get overviewDefaultLastDate {
    _$overviewDefaultLastDateAtom.reportRead();
    return super.overviewDefaultLastDate;
  }

  @override
  set overviewDefaultLastDate(DateTime value) {
    _$overviewDefaultLastDateAtom
        .reportWrite(value, super.overviewDefaultLastDate, () {
      super.overviewDefaultLastDate = value;
    });
  }

  final _$rangeDaysAtom = Atom(name: '_DateStoreBase.rangeDays');

  @override
  ObservableList<DateTime> get rangeDays {
    _$rangeDaysAtom.reportRead();
    return super.rangeDays;
  }

  @override
  set rangeDays(ObservableList<DateTime> value) {
    _$rangeDaysAtom.reportWrite(value, super.rangeDays, () {
      super.rangeDays = value;
    });
  }

  final _$timeSelectedAtom = Atom(name: '_DateStoreBase.timeSelected');

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

  final _$overviewFirstDateAtom =
      Atom(name: '_DateStoreBase.overviewFirstDate');

  @override
  DateTime get overviewFirstDate {
    _$overviewFirstDateAtom.reportRead();
    return super.overviewFirstDate;
  }

  @override
  set overviewFirstDate(DateTime value) {
    _$overviewFirstDateAtom.reportWrite(value, super.overviewFirstDate, () {
      super.overviewFirstDate = value;
    });
  }

  final _$calculationPeriodInProgressAtom =
      Atom(name: '_DateStoreBase.calculationPeriodInProgress');

  @override
  bool get calculationPeriodInProgress {
    _$calculationPeriodInProgressAtom.reportRead();
    return super.calculationPeriodInProgress;
  }

  @override
  set calculationPeriodInProgress(bool value) {
    _$calculationPeriodInProgressAtom
        .reportWrite(value, super.calculationPeriodInProgress, () {
      super.calculationPeriodInProgress = value;
    });
  }

  final _$illnessesAtom = Atom(name: '_DateStoreBase.illnesses');

  @override
  ObservableMap<DateTime, List<dynamic>> get illnesses {
    _$illnessesAtom.reportRead();
    return super.illnesses;
  }

  @override
  set illnesses(ObservableMap<DateTime, List<dynamic>> value) {
    _$illnessesAtom.reportWrite(value, super.illnesses, () {
      super.illnesses = value;
    });
  }

  final _$initializeIllnessesAtom =
      Atom(name: '_DateStoreBase.initializeIllnesses');

  @override
  bool get initializeIllnesses {
    _$initializeIllnessesAtom.reportRead();
    return super.initializeIllnesses;
  }

  @override
  set initializeIllnesses(bool value) {
    _$initializeIllnessesAtom.reportWrite(value, super.initializeIllnesses, () {
      super.initializeIllnesses = value;
    });
  }

  final _$_DateStoreBaseActionController =
      ActionController(name: '_DateStoreBase');

  @override
  void addIllnesses(DateTime day) {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.addIllnesses');
    try {
      return super.addIllnesses(day);
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeIllnesses(SymptomStore symptomStore, DateTime day) {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.removeIllnesses');
    try {
      return super.removeIllnesses(symptomStore, day);
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  DateTime setDateFromString(String dateTime) {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.setDateFromString');
    try {
      return super.setDateFromString(dateTime);
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getDaysOfAWeekOrMonth(DateTime firstDate, DateTime lastDate) {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.getDaysOfAWeekOrMonth');
    try {
      return super.getDaysOfAWeekOrMonth(firstDate, lastDate);
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<DateTime> returnDaysOfAWeekOrMonth(
      DateTime firstDate, DateTime lastDate) {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.returnDaysOfAWeekOrMonth');
    try {
      return super.returnDaysOfAWeekOrMonth(firstDate, lastDate);
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

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
  void nextWeekOverview() {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.nextWeekOverview');
    try {
      return super.nextWeekOverview();
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void previousWeekOverview() {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.previousWeekOverview');
    try {
      return super.previousWeekOverview();
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextMonthOverview() {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.nextMonthOverview');
    try {
      return super.nextMonthOverview();
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void previousMonthOverview() {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.previousMonthOverview');
    try {
      return super.previousMonthOverview();
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void firstDayInWeek() {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.firstDayInWeek');
    try {
      return super.firstDayInWeek();
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void firstDayInMonth() {
    final _$actionInfo = _$_DateStoreBaseActionController.startAction(
        name: '_DateStoreBase.firstDayInMonth');
    try {
      return super.firstDayInMonth();
    } finally {
      _$_DateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
calendarSelectedDate: ${calendarSelectedDate},
overviewDefaultLastDate: ${overviewDefaultLastDate},
rangeDays: ${rangeDays},
timeSelected: ${timeSelected},
overviewFirstDate: ${overviewFirstDate},
calculationPeriodInProgress: ${calculationPeriodInProgress},
illnesses: ${illnesses},
initializeIllnesses: ${initializeIllnesses},
weekDay: ${weekDay}
    ''';
  }
}
