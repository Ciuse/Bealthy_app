// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foodStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FoodStore on _FoodStoreBase, Store {
  final _$yourFavouriteDishListAtom =
      Atom(name: '_FoodStoreBase.yourFavouriteDishList');

  @override
  ObservableList<Dish> get yourFavouriteDishList {
    _$yourFavouriteDishListAtom.reportRead();
    return super.yourFavouriteDishList;
  }

  @override
  set yourFavouriteDishList(ObservableList<Dish> value) {
    _$yourFavouriteDishListAtom.reportWrite(value, super.yourFavouriteDishList,
        () {
      super.yourFavouriteDishList = value;
    });
  }

  final _$yourCreatedDishListAtom =
      Atom(name: '_FoodStoreBase.yourCreatedDishList');

  @override
  ObservableList<Dish> get yourCreatedDishList {
    _$yourCreatedDishListAtom.reportRead();
    return super.yourCreatedDishList;
  }

  @override
  set yourCreatedDishList(ObservableList<Dish> value) {
    _$yourCreatedDishListAtom.reportWrite(value, super.yourCreatedDishList, () {
      super.yourCreatedDishList = value;
    });
  }

  final _$firstDishListAtom = Atom(name: '_FoodStoreBase.firstDishList');

  @override
  ObservableList<Dish> get firstDishList {
    _$firstDishListAtom.reportRead();
    return super.firstDishList;
  }

  @override
  set firstDishList(ObservableList<Dish> value) {
    _$firstDishListAtom.reportWrite(value, super.firstDishList, () {
      super.firstDishList = value;
    });
  }

  final _$secondDishListAtom = Atom(name: '_FoodStoreBase.secondDishList');

  @override
  ObservableList<Dish> get secondDishList {
    _$secondDishListAtom.reportRead();
    return super.secondDishList;
  }

  @override
  set secondDishList(ObservableList<Dish> value) {
    _$secondDishListAtom.reportWrite(value, super.secondDishList, () {
      super.secondDishList = value;
    });
  }

  final _$contornDishListAtom = Atom(name: '_FoodStoreBase.contornDishList');

  @override
  ObservableList<Dish> get contornDishList {
    _$contornDishListAtom.reportRead();
    return super.contornDishList;
  }

  @override
  set contornDishList(ObservableList<Dish> value) {
    _$contornDishListAtom.reportWrite(value, super.contornDishList, () {
      super.contornDishList = value;
    });
  }

  final _$dessertDishListAtom = Atom(name: '_FoodStoreBase.dessertDishList');

  @override
  ObservableList<Dish> get dessertDishList {
    _$dessertDishListAtom.reportRead();
    return super.dessertDishList;
  }

  @override
  set dessertDishList(ObservableList<Dish> value) {
    _$dessertDishListAtom.reportWrite(value, super.dessertDishList, () {
      super.dessertDishList = value;
    });
  }

  final _$loadInitDishListAtom = Atom(name: '_FoodStoreBase.loadInitDishList');

  @override
  ObservableFuture<dynamic> get loadInitDishList {
    _$loadInitDishListAtom.reportRead();
    return super.loadInitDishList;
  }

  @override
  set loadInitDishList(ObservableFuture<dynamic> value) {
    _$loadInitDishListAtom.reportWrite(value, super.loadInitDishList, () {
      super.loadInitDishList = value;
    });
  }

  final _$initStoreAsyncAction = AsyncAction('_FoodStoreBase.initStore');

  @override
  Future<void> initStore() {
    return _$initStoreAsyncAction.run(() => super.initStore());
  }

  final _$getYourDishesAsyncAction =
      AsyncAction('_FoodStoreBase.getYourDishes');

  @override
  Future<void> getYourDishes() {
    return _$getYourDishesAsyncAction.run(() => super.getYourDishes());
  }

  final _$_FoodStoreBaseActionController =
      ActionController(name: '_FoodStoreBase');

  @override
  Future<void> loadInitialBho() {
    final _$actionInfo = _$_FoodStoreBaseActionController.startAction(
        name: '_FoodStoreBase.loadInitialBho');
    try {
      return super.loadInitialBho();
    } finally {
      _$_FoodStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addDishWithCategory(Dish dish) {
    final _$actionInfo = _$_FoodStoreBaseActionController.startAction(
        name: '_FoodStoreBase.addDishWithCategory');
    try {
      return super.addDishWithCategory(dish);
    } finally {
      _$_FoodStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addNewDish(Dish dish) {
    final _$actionInfo = _$_FoodStoreBaseActionController.startAction(
        name: '_FoodStoreBase.addNewDish');
    try {
      return super.addNewDish(dish);
    } finally {
      _$_FoodStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addNewDishCreatedByUser(Dish dish, List<Ingredient> ingredients) {
    final _$actionInfo = _$_FoodStoreBaseActionController.startAction(
        name: '_FoodStoreBase.addNewDishCreatedByUser');
    try {
      return super.addNewDishCreatedByUser(dish, ingredients);
    } finally {
      _$_FoodStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<Dish> getFavouritesDishes() {
    final _$actionInfo = _$_FoodStoreBaseActionController.startAction(
        name: '_FoodStoreBase.getFavouritesDishes');
    try {
      return super.getFavouritesDishes();
    } finally {
      _$_FoodStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
yourFavouriteDishList: ${yourFavouriteDishList},
yourCreatedDishList: ${yourCreatedDishList},
firstDishList: ${firstDishList},
secondDishList: ${secondDishList},
contornDishList: ${contornDishList},
dessertDishList: ${dessertDishList},
loadInitDishList: ${loadInitDishList}
    ''';
  }
}
