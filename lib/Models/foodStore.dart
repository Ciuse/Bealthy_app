import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Database/Dish.dart';
import '../Database/Ingredient.dart';
import 'date_model.dart';

// Include generated file
part 'foodStore.g.dart';

enum Category {
  First_Course, //ANTIPASTI
  Main_Course, //PRIMI
  Second_Course, //SECONDI
  Side, //CONTORNI
  Desserts, //DOLCE
  Drinks, //BEVANDE
}

//flutter packages pub run build_runner build
//flutter packages pub run build_runner watch
//flutter packages pub run build_runner watch --delete-conflicting-outputs
FirebaseAuth auth = FirebaseAuth.instance;

// This is the class used by rest of your codebase
class FoodStore = _FoodStoreBase with _$FoodStore;

// The store-class
abstract class _FoodStoreBase with Store {
  final firestoreInstance = FirebaseFirestore.instance;

  bool storeInitialized = false;

  @observable
  var yourFavouriteDishList = new ObservableList<Dish>();

  @observable
  bool isFavourite;

  @observable
  var yourCreatedDishList = new ObservableList<Dish>();

  @observable
  var yourDishesDayList = new ObservableList<Dish>();

  @observable
  var firstDishList = new ObservableList<Dish>();

  @observable
  var secondDishList = new ObservableList<Dish>();

  @observable
  var contornDishList = new ObservableList<Dish>();

  @observable
  var dessertDishList = new ObservableList<Dish>();

  @observable
  ObservableFuture loadInitDishList;

  @action
  Future<void> loadInitialBho() {
    return loadInitDishList = ObservableFuture(initStore());
  }

  @action
  Future<void> initStore() async {

    if (!storeInitialized) {
      await getYourDishes();
      await getFavouriteDishes();
      await addDishToCategory();
      await getYourDishesOfSpecifiDay(DateTime.now());
      storeInitialized = true;
    }
  }


  @action
  void addDishWithCategory(Dish dish) {
    firestoreInstance
        .collection("DishesCategory")
        .doc(dish.category)
        .collection("Dishes")
        .add(dish.toMapDishesCategory());
  }

  @action
  void addNewDish(Dish dish) {
    firestoreInstance
        .collection("Dishes")
        .doc(dish.id)
        .set(dish.toMapDishes());
  }

  @action
  void addNewDishCreatedByUser(Dish dish, List<Ingredient> ingredients) {
    firestoreInstance
        .collection("DishesCreatedByUsers")
        .doc(auth.currentUser.uid)
        .collection("Dishes")
        .doc(dish.id)
        .set(dish.toMapDishesCreatedByUser());

    ingredients.forEach((element) {
      firestoreInstance
          .collection("DishesCreatedByUsers")
          .doc(auth.currentUser.uid)
          .collection("Dishes")
          .doc(dish.id)
          .collection("Ingredients").doc(element.id).set(element.toMap());
    });
    yourCreatedDishList.add(dish);
  }

  @action
  Future<void> getYourDishes() async {
    await (FirebaseFirestore.instance
        .collection('DishesCreatedByUsers')
        .doc(auth.currentUser.uid).collection("Dishes").get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((dish) {
        Dish toAdd = new Dish(id: dish.id,
            name: dish.get("name"),
            category: dish.get("category"),
            qty: null,
            ingredients: null);
        yourCreatedDishList.add(toAdd);
      });
    })
    );
  }

  @action
  Future<void> getFavouriteDishes() async {
    await (FirebaseFirestore.instance
        .collection('DishesFavouriteByUsers')
        .doc(auth.currentUser.uid).collection("Dishes").get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((dish) {
        Dish toAdd = new Dish(id: dish.id,
            name: dish.get("name"),
            category: dish.get("category"),
            qty: null,
            ingredients: null);
        yourFavouriteDishList.add(toAdd);
      });
    })
    );
  }

  @action
  void isFoodFavourite(Dish dish) {
    isFavourite = yourFavouriteDishList.contains(dish);
  }

  String fixDate(DateTime date){
    String dateSlug ="${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
    return dateSlug;
  }

  @action
  Future<void> getYourDishesOfSpecifiDay(DateTime date) async {
    String day = fixDate(date);
    yourDishesDayList.clear();
    await (FirebaseFirestore.instance
        .collection('UserDishes')
        .doc(auth.currentUser.uid).collection("DayDishes").doc(day).collection("Dishes").get()
        .then((querySnapshot){
      querySnapshot.docs.forEach((dish) {
        Dish toAdd = new Dish(id: dish.id, name: dish.get("name"), category: dish.get("category"), qty: null, ingredients: null);
        yourDishesDayList.add(toAdd);
      }

      );
      yourDishesDayList.forEach((element) {
        print(element.name);
      });
    })
    );
  }


  @action
  Future<void> removeFavouriteDish(Dish dish) async {
    firestoreInstance
        .collection("DishesFavouriteByUsers")
        .doc(auth.currentUser.uid)
        .collection("Dishes")
        .doc(dish.id)
        .delete();

    yourFavouriteDishList.remove(dish);
    isFoodFavourite(dish);
  }

  @action
  Future<void> addFavouriteDish(Dish dish) async {
    firestoreInstance
        .collection("DishesFavouriteByUsers")
        .doc(auth.currentUser.uid)
        .collection("Dishes")
        .doc(dish.id)
        .set(dish.toMapDishesCreatedByUser());

    yourFavouriteDishList.add(dish);
    isFoodFavourite(dish);
  }

  //Inizializza il database online dividendo i cibi nelle varie categorie
  //Metodo che una volta inseriti tutti i cibi si puo cancellare
  Future<void> addDishToCategory() async {
    await (FirebaseFirestore.instance
        .collection('Dishes')
        .get().then((querySnapshot) {
      querySnapshot.docs.forEach((dish) {
        firestoreInstance
            .collection("DishesCategory")
            .doc(dish.get("category"))
            .collection("Dishes")
            .doc(dish.id)
            .set(Dish(id: dish.id,
            name: dish.get("name"),
            qty: null,
            category: dish.get("category"),
            ingredients: null).toMapDishesCategory());
      });
    })
    );
  }
}
