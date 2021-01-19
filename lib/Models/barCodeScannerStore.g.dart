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

  final _$loadProductAtom = Atom(name: '_BarCodeScannerStoreBase.loadProduct');

  @override
  ObservableFuture<dynamic> get loadProduct {
    _$loadProductAtom.reportRead();
    return super.loadProduct;
  }

  @override
  set loadProduct(ObservableFuture<dynamic> value) {
    _$loadProductAtom.reportWrite(value, super.loadProduct, () {
      super.loadProduct = value;
    });
  }

  final _$loadIngredientsAtom =
      Atom(name: '_BarCodeScannerStoreBase.loadIngredients');

  @override
  ObservableFuture<dynamic> get loadIngredients {
    _$loadIngredientsAtom.reportRead();
    return super.loadIngredients;
  }

  @override
  set loadIngredients(ObservableFuture<dynamic> value) {
    _$loadIngredientsAtom.reportWrite(value, super.loadIngredients, () {
      super.loadIngredients = value;
    });
  }

  final _$productFromQueryAtom =
      Atom(name: '_BarCodeScannerStoreBase.productFromQuery');

  @override
  OFF.Product get productFromQuery {
    _$productFromQueryAtom.reportRead();
    return super.productFromQuery;
  }

  @override
  set productFromQuery(OFF.Product value) {
    _$productFromQueryAtom.reportWrite(value, super.productFromQuery, () {
      super.productFromQuery = value;
    });
  }

  final _$getProductFromOpenFoodDBAsyncAction =
      AsyncAction('_BarCodeScannerStoreBase.getProductFromOpenFoodDB');

  @override
  Future<void> getProductFromOpenFoodDB(String barcode) {
    return _$getProductFromOpenFoodDBAsyncAction
        .run(() => super.getProductFromOpenFoodDB(barcode));
  }

  final _$getIngredientsAsyncAction =
      AsyncAction('_BarCodeScannerStoreBase.getIngredients');

  @override
  Future<void> getIngredients(
      IngredientStore ingredientStore, FoodStore foodStore) {
    return _$getIngredientsAsyncAction
        .run(() => super.getIngredients(ingredientStore, foodStore));
  }

  final _$getScannedDishesAsyncAction =
      AsyncAction('_BarCodeScannerStoreBase.getScannedDishes');

  @override
  Future<Dish> getScannedDishes(String barcode) {
    return _$getScannedDishesAsyncAction
        .run(() => super.getScannedDishes(barcode));
  }

  final _$_BarCodeScannerStoreBaseActionController =
      ActionController(name: '_BarCodeScannerStoreBase');

  @override
  Future<void> initProduct() {
    final _$actionInfo = _$_BarCodeScannerStoreBaseActionController.startAction(
        name: '_BarCodeScannerStoreBase.initProduct');
    try {
      return super.initProduct();
    } finally {
      _$_BarCodeScannerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
scanBarcode: ${scanBarcode},
ingredients: ${ingredients},
loadProduct: ${loadProduct},
loadIngredients: ${loadIngredients},
productFromQuery: ${productFromQuery}
    ''';
  }
}
