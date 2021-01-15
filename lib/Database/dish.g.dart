// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Dish on _DishBase, Store {
  final _$idAtom = Atom(name: '_DishBase.id');

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

  final _$numberAtom = Atom(name: '_DishBase.number');

  @override
  int get number {
    _$numberAtom.reportRead();
    return super.number;
  }

  @override
  set number(int value) {
    _$numberAtom.reportWrite(value, super.number, () {
      super.number = value;
    });
  }

  final _$nameAtom = Atom(name: '_DishBase.name');

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

  final _$categoryAtom = Atom(name: '_DishBase.category');

  @override
  String get category {
    _$categoryAtom.reportRead();
    return super.category;
  }

  @override
  set category(String value) {
    _$categoryAtom.reportWrite(value, super.category, () {
      super.category = value;
    });
  }

  final _$qtyAtom = Atom(name: '_DishBase.qty');

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

  final _$mealTimeAtom = Atom(name: '_DishBase.mealTime');

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

  final _$barcodeAtom = Atom(name: '_DishBase.barcode');

  @override
  String get barcode {
    _$barcodeAtom.reportRead();
    return super.barcode;
  }

  @override
  set barcode(String value) {
    _$barcodeAtom.reportWrite(value, super.barcode, () {
      super.barcode = value;
    });
  }

  final _$imageFileAtom = Atom(name: '_DishBase.imageFile');

  @override
  File get imageFile {
    _$imageFileAtom.reportRead();
    return super.imageFile;
  }

  @override
  set imageFile(File value) {
    _$imageFileAtom.reportWrite(value, super.imageFile, () {
      super.imageFile = value;
    });
  }

  final _$isFavouriteAtom = Atom(name: '_DishBase.isFavourite');

  @override
  bool get isFavourite {
    _$isFavouriteAtom.reportRead();
    return super.isFavourite;
  }

  @override
  set isFavourite(bool value) {
    _$isFavouriteAtom.reportWrite(value, super.isFavourite, () {
      super.isFavourite = value;
    });
  }

  final _$_DishBaseActionController = ActionController(name: '_DishBase');

  @override
  void setIsFavourite(bool value) {
    final _$actionInfo = _$_DishBaseActionController.startAction(
        name: '_DishBase.setIsFavourite');
    try {
      return super.setIsFavourite(value);
    } finally {
      _$_DishBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
id: ${id},
number: ${number},
name: ${name},
category: ${category},
qty: ${qty},
mealTime: ${mealTime},
barcode: ${barcode},
imageFile: ${imageFile},
isFavourite: ${isFavourite}
    ''';
  }
}
