// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredientStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$IngredientStore on _IngredientStoreBase, Store {
  final _$ingredientListAtom =
      Atom(name: '_IngredientStoreBase.ingredientList');

  @override
  ObservableList<Ingredient> get ingredientList {
    _$ingredientListAtom.reportRead();
    return super.ingredientList;
  }

  @override
  set ingredientList(ObservableList<Ingredient> value) {
    _$ingredientListAtom.reportWrite(value, super.ingredientList, () {
      super.ingredientList = value;
    });
  }

  final _$ingredientListOfDishAtom =
      Atom(name: '_IngredientStoreBase.ingredientListOfDish');

  @override
  ObservableList<Ingredient> get ingredientListOfDish {
    _$ingredientListOfDishAtom.reportRead();
    return super.ingredientListOfDish;
  }

  @override
  set ingredientListOfDish(ObservableList<Ingredient> value) {
    _$ingredientListOfDishAtom.reportWrite(value, super.ingredientListOfDish,
        () {
      super.ingredientListOfDish = value;
    });
  }

  final _$mapIngredientDishAtom =
      Atom(name: '_IngredientStoreBase.mapIngredientDish');

  @override
  ObservableMap<Dish, List<Ingredient>> get mapIngredientDish {
    _$mapIngredientDishAtom.reportRead();
    return super.mapIngredientDish;
  }

  @override
  set mapIngredientDish(ObservableMap<Dish, List<Ingredient>> value) {
    _$mapIngredientDishAtom.reportWrite(value, super.mapIngredientDish, () {
      super.mapIngredientDish = value;
    });
  }

  final _$ingredientsNameAtom =
      Atom(name: '_IngredientStoreBase.ingredientsName');

  @override
  ObservableList<String> get ingredientsName {
    _$ingredientsNameAtom.reportRead();
    return super.ingredientsName;
  }

  @override
  set ingredientsName(ObservableList<String> value) {
    _$ingredientsNameAtom.reportWrite(value, super.ingredientsName, () {
      super.ingredientsName = value;
    });
  }

  final _$loadInitIngredientListAtom =
      Atom(name: '_IngredientStoreBase.loadInitIngredientList');

  @override
  ObservableFuture<dynamic> get loadInitIngredientList {
    _$loadInitIngredientListAtom.reportRead();
    return super.loadInitIngredientList;
  }

  @override
  set loadInitIngredientList(ObservableFuture<dynamic> value) {
    _$loadInitIngredientListAtom
        .reportWrite(value, super.loadInitIngredientList, () {
      super.loadInitIngredientList = value;
    });
  }

  final _$initStoreAsyncAction = AsyncAction('_IngredientStoreBase.initStore');

  @override
  Future<void> initStore() {
    return _$initStoreAsyncAction.run(() => super.initStore());
  }

  final _$getIngredientsAsyncAction =
      AsyncAction('_IngredientStoreBase.getIngredients');

  @override
  Future<void> getIngredients() {
    return _$getIngredientsAsyncAction.run(() => super.getIngredients());
  }

  final _$getIngredientsFromDatabaseDishAsyncAction =
      AsyncAction('_IngredientStoreBase.getIngredientsFromDatabaseDish');

  @override
  Future<void> getIngredientsFromDatabaseDish(Dish dish) {
    return _$getIngredientsFromDatabaseDishAsyncAction
        .run(() => super.getIngredientsFromDatabaseDish(dish));
  }

  final _$getIngredientsFromUserDishAsyncAction =
      AsyncAction('_IngredientStoreBase.getIngredientsFromUserDish');

  @override
  Future<void> getIngredientsFromUserDish(Dish dish) {
    return _$getIngredientsFromUserDishAsyncAction
        .run(() => super.getIngredientsFromUserDish(dish));
  }

  final _$getIngredientsStringFromDatabaseDishAsyncAction =
      AsyncAction('_IngredientStoreBase.getIngredientsStringFromDatabaseDish');

  @override
  Future<String> getIngredientsStringFromDatabaseDish(Dish dish) {
    return _$getIngredientsStringFromDatabaseDishAsyncAction
        .run(() => super.getIngredientsStringFromDatabaseDish(dish));
  }

  final _$getIngredientsStringFromUserDishAsyncAction =
      AsyncAction('_IngredientStoreBase.getIngredientsStringFromUserDish');

  @override
  Future<String> getIngredientsStringFromUserDish(Dish dish) {
    return _$getIngredientsStringFromUserDishAsyncAction
        .run(() => super.getIngredientsStringFromUserDish(dish));
  }

  final _$getIngredientsNameAsyncAction =
      AsyncAction('_IngredientStoreBase.getIngredientsName');

  @override
  Future<void> getIngredientsName() {
    return _$getIngredientsNameAsyncAction
        .run(() => super.getIngredientsName());
  }

  final _$_IngredientStoreBaseActionController =
      ActionController(name: '_IngredientStoreBase');

  @override
  Future<void> waitForIngredients() {
    final _$actionInfo = _$_IngredientStoreBaseActionController.startAction(
        name: '_IngredientStoreBase.waitForIngredients');
    try {
      return super.waitForIngredients();
    } finally {
      _$_IngredientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> retryForIngredients() {
    final _$actionInfo = _$_IngredientStoreBaseActionController.startAction(
        name: '_IngredientStoreBase.retryForIngredients');
    try {
      return super.retryForIngredients();
    } finally {
      _$_IngredientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Ingredient returnIngredientFromId(String ingredientId) {
    final _$actionInfo = _$_IngredientStoreBaseActionController.startAction(
        name: '_IngredientStoreBase.returnIngredientFromId');
    try {
      return super.returnIngredientFromId(ingredientId);
    } finally {
      _$_IngredientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getIngredientIdFromName(String ingredientName) {
    final _$actionInfo = _$_IngredientStoreBaseActionController.startAction(
        name: '_IngredientStoreBase.getIngredientIdFromName');
    try {
      return super.getIngredientIdFromName(ingredientName);
    } finally {
      _$_IngredientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Ingredient getIngredientFromName(String ingredientName) {
    final _$actionInfo = _$_IngredientStoreBaseActionController.startAction(
        name: '_IngredientStoreBase.getIngredientFromName');
    try {
      return super.getIngredientFromName(ingredientName);
    } finally {
      _$_IngredientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Ingredient getIngredientFromList(String ingredientId) {
    final _$actionInfo = _$_IngredientStoreBaseActionController.startAction(
        name: '_IngredientStoreBase.getIngredientFromList');
    try {
      return super.getIngredientFromList(ingredientId);
    } finally {
      _$_IngredientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
ingredientList: ${ingredientList},
ingredientListOfDish: ${ingredientListOfDish},
mapIngredientDish: ${mapIngredientDish},
ingredientsName: ${ingredientsName},
loadInitIngredientList: ${loadInitIngredientList}
    ''';
  }
}
