// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barCodeScannerStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BarCodeScannerStore on _BarCodeScannerStoreBase, Store {
  final _$scanBarcodeAtom = Atom(name: '_BarCodeScannerStoreBase.scanBarcode');

  @override
  String get scanBarcode {
    _$scanBarcodeAtom.reportRead();
    return super.scanBarcode;
  }

  @override
  set scanBarcode(String value) {
    _$scanBarcodeAtom.reportWrite(value, super.scanBarcode, () {
      super.scanBarcode = value;
    });
  }

  final _$ingredientsAtom = Atom(name: '_BarCodeScannerStoreBase.ingredients');

  @override
  List<Ingredient> get ingredients {
    _$ingredientsAtom.reportRead();
    return super.ingredients;
  }

  @override
  set ingredients(List<Ingredient> value) {
    _$ingredientsAtom.reportWrite(value, super.ingredients, () {
      super.ingredients = value;
    });
  }

  final _$getProductFromOpenFoodDBAsyncAction =
      AsyncAction('_BarCodeScannerStoreBase.getProductFromOpenFoodDB');

  @override
  Future<OFF.Product> getProductFromOpenFoodDB(String barcode) {
    return _$getProductFromOpenFoodDBAsyncAction
        .run(() => super.getProductFromOpenFoodDB(barcode));
  }

  final _$getIngredientsAsyncAction =
      AsyncAction('_BarCodeScannerStoreBase.getIngredients');

  @override
  Future<void> getIngredients(OFF.Product product,
      IngredientStore ingredientStore, FoodStore foodStore) {
    return _$getIngredientsAsyncAction
        .run(() => super.getIngredients(product, ingredientStore, foodStore));
  }

  final _$_BarCodeScannerStoreBaseActionController =
      ActionController(name: '_BarCodeScannerStoreBase');

  @override
  double rankValueIngredient(int count) {
    final _$actionInfo = _$_BarCodeScannerStoreBaseActionController.startAction(
        name: '_BarCodeScannerStoreBase.rankValueIngredient');
    try {
      return super.rankValueIngredient(count);
    } finally {
      _$_BarCodeScannerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
scanBarcode: ${scanBarcode},
ingredients: ${ingredients}
    ''';
  }
}
