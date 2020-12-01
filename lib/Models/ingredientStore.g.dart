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

  final _$_IngredientStoreBaseActionController =
      ActionController(name: '_IngredientStoreBase');

  @override
  Future<void> loadInitialBho() {
    final _$actionInfo = _$_IngredientStoreBaseActionController.startAction(
        name: '_IngredientStoreBase.loadInitialBho');
    try {
      return super.loadInitialBho();
    } finally {
      _$_IngredientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
ingredientList: ${ingredientList},
ingredientsName: ${ingredientsName},
loadInitIngredientList: ${loadInitIngredientList}
    ''';
  }
}
