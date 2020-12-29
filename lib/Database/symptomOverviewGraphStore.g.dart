// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptomOverviewGraphStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SymptomOverviewGraphStore on _SymptomOverviewGraphStoreBase, Store {
  final _$touchedIndexAtom =
      Atom(name: '_SymptomOverviewGraphStoreBase.touchedIndex');

  @override
  int get touchedIndex {
    _$touchedIndexAtom.reportRead();
    return super.touchedIndex;
  }

  @override
  set touchedIndex(int value) {
    _$touchedIndexAtom.reportWrite(value, super.touchedIndex, () {
      super.touchedIndex = value;
    });
  }

  @override
  String toString() {
    return '''
touchedIndex: ${touchedIndex}
    ''';
  }
}
