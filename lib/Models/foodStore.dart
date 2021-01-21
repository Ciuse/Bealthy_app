import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Database/observableValues.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import '../Database/dish.dart';
import '../Database/ingredient.dart';
import 'ingredientStore.dart';

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
  var mapIngredientsStringDish = new ObservableMap<Dish,ObservableValues>();

  @observable
  var resultsList = new ObservableList<Dish>();  //lista usata nella search bar per filtrare

  @observable
  var isSelected = new ObservableList<bool>();



  @observable
  ObservableFuture loadInitFavouriteDishesList;

  @action
  Future<void> initFavouriteDishList(IngredientStore ingredientStore) async {

    if (!storeFavouriteDishInitialized) {
      storeFavouriteDishInitialized = true;
      yourFavouriteDishList.clear();
      return loadInitFavouriteDishesList = ObservableFuture(_getFavouriteDishes(ingredientStore));
    }
  }

  @action
  Future<void> retryFavouriteDishesList(IngredientStore ingredientStore) {
    return loadInitFavouriteDishesList = ObservableFuture(_getFavouriteDishes(ingredientStore));
  }

  @observable
  ObservableFuture loadInitCreatedYourDishesList;

  @action
  Future<void> initCreatedYourDishList(IngredientStore ingredientStore) async {

    if (!storeCreatedYourDishInitialized) {
      storeCreatedYourDishInitialized = true;
      yourCreatedDishList.clear();
      return loadInitCreatedYourDishesList = ObservableFuture(_getYourDishes(ingredientStore));
    }
  }
  @action
  Future<void> retryCreatedYourDishesList(IngredientStore ingredientStore) {
    return loadInitCreatedYourDishesList = ObservableFuture(_getYourDishes(ingredientStore));
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
  Future<void> initSearchAllDishList(IngredientStore ingredientStore) async {

    if (!storeSearchAllDishInitialized) {
      dishesListFromDBAndUser.clear();
      storeSearchAllDishInitialized = true;
      return loadInitSearchAllDishesList = ObservableFuture(_getDishesFromDBAndUser(ingredientStore));
    }
  }

  @action
  Future<void> retrySearchAllDishesList(IngredientStore ingredientStore) {
    return loadInitSearchAllDishesList = ObservableFuture(_getDishesFromDBAndUser(ingredientStore));
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
    dishesListFromDBAndUser.add(dish);
    yourCreatedDishList.add(dish);
  }

  @action
  void addNewDishScannedByUser(Dish dish, List<Ingredient> ingredients) {
    firestoreInstance
        .collection("DishesCreatedByUsers")
        .doc(auth.currentUser.uid)
        .collection("Dishes")
        .doc(dish.id)
        .set(dish.toMapDayDishScannedByUser());

    ingredients.forEach((element) {
      firestoreInstance
          .collection("DishesCreatedByUsers")
          .doc(auth.currentUser.uid)
          .collection("Dishes")
          .doc(dish.id)
          .collection("Ingredients").doc(element.id).set(element.toMap());
    });
    dishesListFromDBAndUser.add(dish);
    yourCreatedDishList.add(dish);
  }


  @action
  Future<void> initializeIngredients(Dish dish, IngredientStore ingredientStore)async {
    String ingredients = "";
    if(isSubstring("User", dish.id)){
      ingredients= await ingredientStore.getIngredientsStringFromUserDish(dish);
    }else{
      ingredients = await ingredientStore.getIngredientsStringFromDatabaseDish(dish);
    }
    mapIngredientsStringDish[dish].stringIngredients = ingredients;
  }

  @action
  Future<void> _getDishesFromDBAndUser(IngredientStore ingredientStore) async {
    await (FirebaseFirestore.instance
        .collection('Dishes').orderBy("name")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {

        Dish i = new Dish(id:result.id,name:result.get("name") ,qty: "",);
        ObservableValues value = new ObservableValues(stringIngredients: "");
        mapIngredientsStringDish.putIfAbsent(i, () => value);
        dishesListFromDBAndUser.add(i);
        initializeIngredients(i,ingredientStore);
      }
      );
    }));
    await (FirebaseFirestore.instance
        .collection('DishesCreatedByUsers')
        .doc(auth.currentUser.uid).collection("Dishes").orderBy("name").get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((dish) {
        Dish toAdd = new Dish(id: dish.id,
            name: dish.get("name"),
            qty: null,
            );
        ObservableValues value = new ObservableValues(stringIngredients: "");
        mapIngredientsStringDish.putIfAbsent(toAdd, () => value);
        dishesListFromDBAndUser.add(toAdd);
        initializeIngredients(toAdd,ingredientStore);
      });
    })
    );
  }

  @action
  Future<void> _getYourDishes(IngredientStore ingredientStore) async {
    await (FirebaseFirestore.instance
        .collection('DishesCreatedByUsers')
        .doc(auth.currentUser.uid).collection("Dishes").orderBy("name").get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((dish) {
        Dish toAdd = new Dish(id: dish.id,
            name: dish.get("name"),
            qty: null,
            );
        ObservableValues value = new ObservableValues(stringIngredients: "");
        mapIngredientsStringDish.putIfAbsent(toAdd, () => value);
        yourCreatedDishList.add(toAdd);
        initializeIngredients(toAdd,ingredientStore);
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
  Future<void> _getFavouriteDishes(IngredientStore ingredientStore) async {
    await (FirebaseFirestore.instance
        .collection('DishesFavouriteByUsers')
        .doc(auth.currentUser.uid).collection("Dishes").orderBy("name").get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((dish) {
        Dish toAdd = new Dish(id: dish.id,
            name: dish.get("name"),
            qty: null,
            );
        toAdd.setIsFavourite(true);
        ObservableValues value = new ObservableValues(stringIngredients: "");
        mapIngredientsStringDish.putIfAbsent(toAdd, () => value);
        yourFavouriteDishList.add(toAdd);
        initializeIngredients(toAdd,ingredientStore);
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
        .set(dish.toMapDishes());

    yourFavouriteDishList.add(dish);
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
