// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Treatment on _TreatmentBase, Store {
  final _$idAtom = Atom(name: '_TreatmentBase.id');

  @override
  String get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(String value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  final _$titleAtom = Atom(name: '_TreatmentBase.title');

  @override
  String get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  final _$startingDayAtom = Atom(name: '_TreatmentBase.startingDay');

  @override
  String get startingDay {
    _$startingDayAtom.reportRead();
    return super.startingDay;
  }

  @override
  set startingDay(String value) {
    _$startingDayAtom.reportWrite(value, super.startingDay, () {
      super.startingDay = value;
    });
  }

  final _$endingDayAtom = Atom(name: '_TreatmentBase.endingDay');

  @override
  String get endingDay {
    _$endingDayAtom.reportRead();
    return super.endingDay;
  }

  @override
  set endingDay(String value) {
    _$endingDayAtom.reportWrite(value, super.endingDay, () {
      super.endingDay = value;
    });
  }

  final _$descriptionTextAtom = Atom(name: '_TreatmentBase.descriptionText');

  @override
  String get descriptionText {
    _$descriptionTextAtom.reportRead();
    return super.descriptionText;
  }

  @override
  set descriptionText(String value) {
    _$descriptionTextAtom.reportWrite(value, super.descriptionText, () {
      super.descriptionText = value;
    });
  }

  final _$dietInfoTextAtom = Atom(name: '_TreatmentBase.dietInfoText');

  @override
  String get dietInfoText {
    _$dietInfoTextAtom.reportRead();
    return super.dietInfoText;
  }

  @override
  set dietInfoText(String value) {
    _$dietInfoTextAtom.reportWrite(value, super.dietInfoText, () {
      super.dietInfoText = value;
    });
  }

  final _$medicalInfoTextAtom = Atom(name: '_TreatmentBase.medicalInfoText');

  @override
  String get medicalInfoText {
    _$medicalInfoTextAtom.reportRead();
    return super.medicalInfoText;
  }

  @override
  set medicalInfoText(String value) {
    _$medicalInfoTextAtom.reportWrite(value, super.medicalInfoText, () {
      super.medicalInfoText = value;
    });
  }

  final _$_TreatmentBaseActionController =
      ActionController(name: '_TreatmentBase');

  @override
  String fixDate(DateTime date) {
    final _$actionInfo = _$_TreatmentBaseActionController.startAction(
        name: '_TreatmentBase.fixDate');
    try {
      return super.fixDate(date);
    } finally {
      _$_TreatmentBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  DateTime setDateFromString(String dateTime) {
    final _$actionInfo = _$_TreatmentBaseActionController.startAction(
        name: '_TreatmentBase.setDateFromString');
    try {
      return super.setDateFromString(dateTime);
    } finally {
      _$_TreatmentBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
id: ${id},
title: ${title},
startingDay: ${startingDay},
endingDay: ${endingDay},
descriptionText: ${descriptionText},
dietInfoText: ${dietInfoText},
medicalInfoText: ${medicalInfoText}
    ''';
  }
}
