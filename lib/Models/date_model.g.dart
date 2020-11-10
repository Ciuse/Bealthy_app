// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DateModel on _DateModel, Store {
  Computed<int> _$weekDayComputed;

  @override
  int get weekDay => (_$weekDayComputed ??=
          Computed<int>(() => super.weekDay, name: '_DateModel.weekDay'))
      .value;

  final _$dateAtom = Atom(name: '_DateModel.date');

  @override
  DateTime get date {
    _$dateAtom.reportRead();
    return super.date;
  }

  @override
  set date(DateTime value) {
    _$dateAtom.reportWrite(value, super.date, () {
      super.date = value;
    });
  }

  @override
  String toString() {
    return '''
date: ${date},
weekDay: ${weekDay}
    ''';
  }
}
