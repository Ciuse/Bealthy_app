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

  final _$firstCourseDishListAtom =
      Atom(name: '_FoodStoreBase.firstCourseDishList');

  @override
  ObservableList<Dish> get firstCourseDishList {
    _$firstCourseDishListAtom.reportRead();
    return super.firstCourseDishList;
  }

  @override
  set firstCourseDishList(ObservableList<Dish> value) {
    _$firstCourseDishListAtom.reportWrite(value, super.firstCourseDishList, () {
      super.firstCourseDishList = value;
    });
  }

  final _$mainCourseDishListAtom =
      Atom(name: '_FoodStoreBase.mainCourseDishList');

  @override
  ObservableList<Dish> get mainCourseDishList {
    _$mainCourseDishListAtom.reportRead();
    return super.mainCourseDishList;
  }

  @override
  set mainCourseDishList(ObservableList<Dish> value) {
    _$mainCourseDishListAtom.reportWrite(value, super.mainCourseDishList, () {
      super.mainCourseDishList = value;
    });
  }

  final _$secondCourseDishListAtom =
      Atom(name: '_FoodStoreBase.secondCourseDishList');

  @override
  ObservableList<Dish> get secondCourseDishList {
    _$secondCourseDishListAtom.reportRead();
    return super.secondCourseDishList;
  }

  @override
  set secondCourseDishList(ObservableList<Dish> value) {
    _$secondCourseDishListAtom.reportWrite(value, super.secondCourseDishList,
        () {
      super.secondCourseDishList = value;
    });
  }

  final _$sideDishListAtom = Atom(name: '_FoodStoreBase.sideDishList');

  @override
  ObservableList<Dish> get sideDishList {
    _$sideDishListAtom.reportRead();
    return super.sideDishList;
  }

  @override
  set sideDishList(ObservableList<Dish> value) {
    _$sideDishListAtom.reportWrite(value, super.sideDishList, () {
      super.sideDishList = value;
    });
  }

  final _$dessertsDishListAtom = Atom(name: '_FoodStoreBase.dessertsDishList');

  @override
  ObservableList<Dish> get dessertsDishList {
    _$dessertsDishListAtom.reportRead();
    return super.dessertsDishList;
  }

  @override
  set dessertsDishList(ObservableList<Dish> value) {
    _$dessertsDishListAtom.reportWrite(value, super.dessertsDishList, () {
      super.dessertsDishList = value;
    });
  }

  final _$drinksDishListAtom = Atom(name: '_FoodStoreBase.drinksDishList');

  @override
  ObservableList<Dish> get drinksDishList {
    _$drinksDishListAtom.reportRead();
    return super.drinksDishList;
  }

  @override
  set drinksDishList(ObservableList<Dish> value) {
    _$drinksDishListAtom.reportWrite(value, super.drinksDishList, () {
      super.drinksDishList = value;
    });
  }

  final _$dishesListFromDBAndUserAtom =
      Atom(name: '_FoodStoreBase.dishesListFromDBAndUser');

  @override
  ObservableList<Dish> get dishesListFromDBAndUser {
    _$dishesListFromDBAndUserAtom.reportRead();
    return super.dishesListFromDBAndUser;
  }

  @override
  set dishesListFromDBAndUser(ObservableList<Dish> value) {
    _$dishesListFromDBAndUserAtom
        .reportWrite(value, super.dishesListFromDBAndUser, () {
      super.dishesListFromDBAndUser = value;
    });
  }

  final _$resultsListAtom = Atom(name: '_FoodStoreBase.resultsList');

  @override
  ObservableList<Dish> get resultsList {
    _$resultsListAtom.reportRead();
    return super.resultsList;
  }

  @override
  set resultsList(ObservableList<Dish> value) {
    _$resultsListAtom.reportWrite(value, super.resultsList, () {
      super.resultsList = value;
    });
  }

  final _$isSelectedAtom = Atom(name: '_FoodStoreBase.isSelected');

  @override
  ObservableList<bool> get isSelected {
    _$isSelectedAtom.reportRead();
    return super.isSelected;
  }

  @override
  set isSelected(ObservableList<bool> value) {
    _$isSelectedAtom.reportWrite(value, super.isSelected, () {
      super.isSelected = value;
    });
  }

  final _$loadInitDishesListAtom =
      Atom(name: '_FoodStoreBase.loadInitDishesList');

  @override
  ObservableFuture<dynamic> get loadInitSearchAllDishesList {
    _$loadInitDishesListAtom.reportRead();
    return super.loadInitSearchAllDishesList;
  }

  @override
  set loadInitSearchAllDishesList(ObservableFuture<dynamic> value) {
    _$loadInitDishesListAtom.reportWrite(value, super.loadInitSearchAllDishesList, () {
      super.loadInitSearchAllDishesList = value;
    });
  }

  final _$initStoreAsyncAction = AsyncAction('_FoodStoreBase.initStore');

  @override
  Future<void> initStore() {
    return _$initStoreAsyncAction.run(() => super.initStore());
  }

  final _$initBooleanDishQuantityAsyncAction =
      AsyncAction('_FoodStoreBase.initBooleanDishQuantity');

  @override
  Future<void> initBooleanDishQuantity() {
    return _$initBooleanDishQuantityAsyncAction
        .run(() => super.initBooleanDishQuantity());
  }

  final _$initDishListAsyncAction = AsyncAction('_FoodStoreBase.initDishList');

  @override
  Future<void> initSearchAllDishList() {
    return _$initDishListAsyncAction.run(() => super.initSearchAllDishList());
  }

  final _$initFoodCategoryListsAsyncAction =
      AsyncAction('_FoodStoreBase.initFoodCategoryLists');

  @override
  Future<void> initFoodCategoryLists(int categoryIndex) {
    return _$initFoodCategoryListsAsyncAction
        .run(() => super.initFoodCategoryLists(categoryIndex));
  }

  final _$_getCategoryDishesAsyncAction =
      AsyncAction('_FoodStoreBase._getCategoryDishes');

  @override
  Future<void> _getCategoryDishes(
      int categoryIndex, ObservableList<dynamic> list) {
    return _$_getCategoryDishesAsyncAction
        .run(() => super._getCategoryDishes(categoryIndex, list));
  }

  final _$_getDishesFromDBAndUserAsyncAction =
      AsyncAction('_FoodStoreBase._getDishesFromDBAndUser');

  @override
  Future<void> _getDishesFromDBAndUser() {
    return _$_getDishesFromDBAndUserAsyncAction
        .run(() => super._getDishesFromDBAndUser());
  }

  final _$_getYourDishesAsyncAction =
      AsyncAction('_FoodStoreBase._getYourDishes');

  @override
  Future<void> _getYourDishes() {
    return _$_getYourDishesAsyncAction.run(() => super._getYourDishes());
  }

  final _$_getFavouriteDishesAsyncAction =
      AsyncAction('_FoodStoreBase._getFavouriteDishes');

  @override
  Future<void> _getFavouriteDishes() {
    return _$_getFavouriteDishesAsyncAction
        .run(() => super._getFavouriteDishes());
  }

  final _$removeFavouriteDishAsyncAction =
      AsyncAction('_FoodStoreBase.removeFavouriteDish');

  @override
  Future<void> removeFavouriteDish(Dish dish) {
    return _$removeFavouriteDishAsyncAction
        .run(() => super.removeFavouriteDish(dish));
  }

  final _$addFavouriteDishAsyncAction =
      AsyncAction('_FoodStoreBase.addFavouriteDish');

  @override
  Future<void> addFavouriteDish(Dish dish) {
    return _$addFavouriteDishAsyncAction
        .run(() => super.addFavouriteDish(dish));
  }

  final _$_FoodStoreBaseActionController =
      ActionController(name: '_FoodStoreBase');

  @override
  void setBooleanQuantityDish() {
    final _$actionInfo = _$_FoodStoreBaseActionController.startAction(
        name: '_FoodStoreBase.setBooleanQuantityDish');
    try {
      return super.setBooleanQuantityDish();
    } finally {
      _$_FoodStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> retrySearchAllDishesList() {
    final _$actionInfo = _$_FoodStoreBaseActionController.startAction(
        name: '_FoodStoreBase.retryForDishesTotal');
    try {
      return super.retrySearchAllDishesList();
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
  void isFoodFavourite(Dish dish) {
    final _$actionInfo = _$_FoodStoreBaseActionController.startAction(
        name: '_FoodStoreBase.isFoodFavourite');
    try {
      return super.isFoodFavourite(dish);
    } finally {
      _$_FoodStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
yourFavouriteDishList: ${yourFavouriteDishList},
yourCreatedDishList: ${yourCreatedDishList},
firstCourseDishList: ${firstCourseDishList},
mainCourseDishList: ${mainCourseDishList},
secondCourseDishList: ${secondCourseDishList},
sideDishList: ${sideDishList},
dessertsDishList: ${dessertsDishList},
drinksDishList: ${drinksDishList},
dishesListFromDBAndUser: ${dishesListFromDBAndUser},
resultsList: ${resultsList},
isSelected: ${isSelected},
loadInitDishesList: ${loadInitSearchAllDishesList}
    ''';
  }
}
