import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Database/Dish.dart';
import '../Database/Ingredient.dart';

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

enum Quantity {
  Little, //Poca
  Normal, //Media
  Lots, //Tanta
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
  var daySelected = DateTime.now();

  @observable
  var yourCreatedDishList = new ObservableList<Dish>();

  @observable
  var yourDishesDayList = new ObservableList<Dish>();

  @observable
  var firstCourseDishList = new ObservableList<Dish>();

  @observable
  var mainCourseDishList = new ObservableList<Dish>();

  @observable
  var secondCourseDishList = new ObservableList<Dish>();

  @observable
  var sideDishList = new ObservableList<Dish>();

  @observable
  var dessertsDishList = new ObservableList<Dish>();

  @observable
  var drinksDishList = new ObservableList<Dish>();

  @observable
  ObservableFuture loadInitDishList;

  @action
  Future<void> loadInitialBho() {
    return loadInitDishList = ObservableFuture(initStore());
  }

  @action
  Future<void> initStore() async {
    if (!storeInitialized) {
      await _getYourDishes();
      await _getFavouriteDishes();
      await _addDishToCategory();
      await getYourDishesOfSpecificDay(DateTime.now());
      storeInitialized = true;
    }
  }

  @action
  Future<void> initFoodCategoryLists(int categoryIndex) async {
    switch (categoryIndex) {
      case 0:
        {
          if (firstCourseDishList.length <= 0) {
            _getCategoryDishes(categoryIndex, firstCourseDishList);
          }
        }
        break;
      case 1:
        {
          if (mainCourseDishList.length <= 0) {
            _getCategoryDishes(categoryIndex, mainCourseDishList);
          }
        }
        break;
      case 2:
        {
          if (secondCourseDishList.length <= 0) {
            _getCategoryDishes(categoryIndex, secondCourseDishList);
          }
        }
        break;
      case 3:
        {
          if (sideDishList.length <= 0) {
            _getCategoryDishes(categoryIndex, sideDishList);
          }
        }
        break;
      case 4:
        {
          if (dessertsDishList.length <= 0) {
            _getCategoryDishes(categoryIndex, dessertsDishList);
          }
        }
        break;
      case 5:
        {
          if (drinksDishList.length <= 0) {
            _getCategoryDishes(categoryIndex, drinksDishList);
          }
        }
        break;
      default:
        {
          print("Swtich case no category found");
        }
        break;
    }
  }

  ObservableList getCategoryList(int categoryIndex) {
    switch (categoryIndex) {
      case 0:
        {
          return firstCourseDishList;
        }
        break;
      case 1:
        {
          return mainCourseDishList;
        }
        break;
      case 2:
        {
          return secondCourseDishList;
        }
        break;
      case 3:
        {
          return sideDishList;
        }
        break;
      case 4:
        {
          return dessertsDishList;
        }
        break;
      case 5:
        {
          return drinksDishList;
        }
        break;
      default:
        {
          print("Swtich case no category found");
          return null;
        }
    }
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
  Future<void> _getCategoryDishes(int categoryIndex,
      ObservableList list) async {
    await (FirebaseFirestore.instance
        .collection('DishesCategory')
        .doc(Category.values[categoryIndex]
        .toString()
        .split('.')
        .last)
        .collection("Dishes").get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((dish) {
        Dish toAdd = new Dish(id: dish.id,
            name: dish.get("name"),
            category: Category.values[categoryIndex]
                .toString()
                .split('.')
                .last,
            qty: null,
            ingredients: null);
        list.add(toAdd);
      });
    })
    );
  }


  @action
  Future<void> _getYourDishes() async {
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
  Future<void> _getFavouriteDishes() async {
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

  String fixDate(DateTime date) {
    String dateSlug = "${date.year.toString()}-${date.month.toString().padLeft(
        2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return dateSlug;
  }





  @action
  Future<void> getYourDishesOfSpecificDay(DateTime date) async {
    String day = fixDate(date);
    yourDishesDayList.clear();
    await (FirebaseFirestore.instance
        .collection('UserDishes')
        .doc(auth.currentUser.uid).collection("DayDishes").doc(day).collection(
        "Dishes").get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((dish) {
        Dish toAdd = new Dish(id: dish.id,
            name: dish.get("name"),
            category: dish.get("category"),
            qty: null,
            ingredients: null);
        yourDishesDayList.add(toAdd);
      }

      );
    })
    );
  }

  @action
  Future<void> addDishToASpecificDay(Dish dish) async {
    String day = fixDate(daySelected);
    await (FirebaseFirestore.instance
        .collection('UserDishes')
        .doc(auth.currentUser.uid)
        .collection("DayDishes")
        .doc(day).set({"virtual": true}));

    await (FirebaseFirestore.instance
        .collection('UserDishes')
        .doc(auth.currentUser.uid)
        .collection("DayDishes")
        .doc(day)
        .collection("Dishes")
        .doc(dish.id)
        .set(dish.toMapUserDishes()));

        yourDishesDayList.add(dish);
      }



  @action
  Future<void> removeDishFromUserDishesOfSpecificDay(Dish dish) async {
    String dayFix = fixDate(daySelected);
    firestoreInstance
        .collection("UserDishes")
        .doc(auth.currentUser.uid)
        .collection("DayDishes")
        .doc(dayFix)
        .collection("Dishes")
        .doc(dish.id)
        .delete();

    yourDishesDayList.remove(dish);
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
  Future<void> _addDishToCategory() async {
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


  bool isSubstring(String s1, String s2) {
    int M = s1.length;
    int N = s2.length;

/* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
      int j;

/* For current index i, check for
 pattern match */
      for (j = 0; j < M; j++)
        if (s2[i + j] != s1[j])
          break;

      if (j == M)
        return true; // il piatto è stato creato dall'utente
    }

    return false; //il piatto non è stato creato dall'utente

  }

}