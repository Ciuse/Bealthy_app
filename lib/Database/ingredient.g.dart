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

  final _$mealTimeAtom = Atom(name: '_IngredientBase.mealTime');

  @override
  String get mealTime {
    _$mealTimeAtom.reportRead();
    return super.mealTime;
  }

  @override
  set mealTime(String value) {
    _$mealTimeAtom.reportWrite(value, super.mealTime, () {
      super.mealTime = value;
    });
  }

  final _$totalQuantityAtom = Atom(name: '_IngredientBase.totalQuantity');

  @override
  int get totalQuantity {
    _$totalQuantityAtom.reportRead();
    return super.totalQuantity;
  }

  @override
  set totalQuantity(int value) {
    _$totalQuantityAtom.reportWrite(value, super.totalQuantity, () {
      super.totalQuantity = value;
    });
  }

  @override
  String toString() {
    return '''
id: ${id},
name: ${name},
qty: ${qty},
mealTime: ${mealTime},
totalQuantity: ${totalQuantity}
    ''';
  }
}
