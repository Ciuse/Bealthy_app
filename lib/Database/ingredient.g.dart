// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Ingredient on _IngredientBase, Store {
  final _$idAtom = Atom(name: '_IngredientBase.id');

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

  final _$nameAtom = Atom(name: '_IngredientBase.name');

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  final _$qtyAtom = Atom(name: '_IngredientBase.qty');

  @override
  String get qty {
    _$qtyAtom.reportRead();
    return super.qty;
  }

  @override
  set qty(String value) {
    _$qtyAtom.reportWrite(value, super.qty, () {
      super.qty = value;
    });
  }

  final _$dayRepetitionAtom = Atom(name: '_IngredientBase.dayRepetition');

  @override
  int get dayRepetition {
    _$dayRepetitionAtom.reportRead();
    return super.dayRepetition;
  }

  @override
  set dayRepetition(int value) {
    _$dayRepetitionAtom.reportWrite(value, super.dayRepetition, () {
      super.dayRepetition = value;
    });
  }

  @override
  String toString() {
    return '''
id: ${id},
name: ${name},
qty: ${qty},
dayRepetition: ${dayRepetition}
    ''';
  }
}
