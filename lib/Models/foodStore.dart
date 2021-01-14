import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import '../Database/dish.dart';
import '../Database/ingredient.dart';

// Include generated file
part 'foodStore.g.dart';


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
  bool storeSearchAllDishInitialized = false;
  bool storeFavouriteDishInitialized = false;
  bool storeCreatedYourDishInitialized = false;

  bool booleanQuantityDishInitialized = false;

  @observable
  var yourFavouriteDishList = new ObservableList<Dish>();


  @observable
  var yourCreatedDishList = new ObservableList<Dish>();

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
  var dishesListFromDBAndUser = new ObservableList<Dish>(); //lista usata nella search bar

  @observable
  var resultsList = new ObservableList<Dish>();  //lista usata nella search bar per filtrare

  @observable
  var isSelected = new ObservableList<bool>();



  @observable
  ObservableFuture loadInitFavouriteDishesList;

  @action
  Future<void> initFavouriteDishList() async {

    if (!storeFavouriteDishInitialized) {
      storeFavouriteDishInitialized = true;
      return loadInitFavouriteDishesList = ObservableFuture(_getFavouriteDishes());
    }
  }

  @action
  Future<void> retryFavouriteDishesList() {
    return loadInitFavouriteDishesList = ObservableFuture(_getFavouriteDishes());
  }

  @observable
  ObservableFuture loadInitCreatedYourDishesList;

  @action
  Future<void> initCreatedYourDishList() async {

    if (!storeCreatedYourDishInitialized) {
      storeCreatedYourDishInitialized = true;
      return loadInitCreatedYourDishesList = ObservableFuture(_getYourDishes());
    }
  }
  @action
  Future<void> retryCreatedYourDishesList() {
    return loadInitCreatedYourDishesList = ObservableFuture(_getYourDishes());
  }

  @action
  Future<void> initStore() async {
    if (!storeInitialized) {
      storeInitialized = true;
      await _addDishToCategory();
    }
  }

  @action
  Future<void> initBooleanDishQuantity() async {
    if (!booleanQuantityDishInitialized) {
      booleanQuantityDishInitialized = true;
     setBooleanQuantityDish();

    }
  }
@action
void setBooleanQuantityDish(){
  for(int i = 0; i< Quantity.values.length; i++){
    isSelected.add(false);
  }
}

  @observable
  ObservableFuture loadInitSearchAllDishesList;

  @action
  Future<void> initSearchAllDishList() async {

    if (!storeSearchAllDishInitialized) {
      storeSearchAllDishInitialized = true;
      return loadInitSearchAllDishesList = ObservableFuture(_getDishesFromDBAndUser());
    }
  }

  @action
  Future<void> retrySearchAllDishesList() {
    return loadInitSearchAllDishesList = ObservableFuture(_getDishesFromDBAndUser());
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
            qty: null,);
        list.add(toAdd);
      });
    })
    );
  }

  @action
  Future<void> _getDishesFromDBAndUser() async {

    await (FirebaseFirestore.instance
        .collection('Dishes')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {

        Dish i = new Dish(id:result.id,name:result.get("name"),category:result.get("category") ,qty: "",);
        dishesListFromDBAndUser.add(i);
      }
      );
    }));
    await (FirebaseFirestore.instance
        .collection('DishesCreatedByUsers')
        .doc(auth.currentUser.uid).collection("Dishes").get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((dish) {
        Dish toAdd = new Dish(id: dish.id,
            name: dish.get("name"),
            category: dish.get("category"),
            qty: null,
            );
        dishesListFromDBAndUser.add(toAdd);
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
            );
        yourCreatedDishList.add(toAdd);
      });
    })
    );
  }

  Future<int> getLastCreatedDishId() async {
    return await FirebaseFirestore.instance.collection('DishesCreatedByUsers')
        .doc(auth.currentUser.uid).collection("Dishes")
        .orderBy("number")
        .limitToLast(1)
        .get()
        .then((querySnapshot) {
          int toReturn=0;
          if(querySnapshot.size>0){
            querySnapshot.docs.forEach((dish) {
              toReturn = dish.get("number")+1;
            });
          }
          else{
            toReturn = 0;
          }
          return toReturn;
    });

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
            );
        toAdd.setIsFavourite(true);
        yourFavouriteDishList.add(toAdd);
      });
    })
    );
  }

  @action
  void isFoodFavourite(Dish dish) {
    bool found= false;
    yourFavouriteDishList.forEach((element) {
      if(element.name.compareTo(dish.name)==0){
        found =true;
      }
    });
    dish.isFavourite=found;
  }

  String fixDate(DateTime date) {
    String dateSlug = "${date.year.toString()}-${date.month.toString().padLeft(
        2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return dateSlug;
  }

  @action
  Future<void> removeFavouriteDish(Dish dish) async {
    dish.setIsFavourite(false);
    firestoreInstance
        .collection("DishesFavouriteByUsers")
        .doc(auth.currentUser.uid)
        .collection("Dishes")
        .doc(dish.id)
        .delete();

    yourFavouriteDishList.removeWhere((element) => element.id == dish.id);
  }

  @action
  Future<void> addFavouriteDish(Dish dish) async {
    dish.setIsFavourite(true);
    firestoreInstance
        .collection("DishesFavouriteByUsers")
        .doc(auth.currentUser.uid)
        .collection("Dishes")
        .doc(dish.id)
        .set(dish.toMapDishesCreatedByUser());

    yourFavouriteDishList.add(dish);
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
            ).toMapDishesCategory());
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
