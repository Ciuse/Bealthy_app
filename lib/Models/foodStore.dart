import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Database/Dish.dart';
import '../Database/Ingredient.dart';

// Include generated file
part 'foodStore.g.dart';

enum Category {
  Primo,
  Secondo,
  Contorno,
  Dolce
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
  var yourCreatedDishList = new ObservableList<Dish>();

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
    if(!storeInitialized) {
      await getYourDishes();
      await getFavouritesDishes();
      storeInitialized=true;
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
  List<Dish> getFavouritesDishes() {
    List<Dish> dishList = new List<Dish>();
    dishList.add(Dish(id:"1",name:"pasta",category: "Primo",ingredients: null));
    dishList.add(Dish(id:"2",name:"gnocchi",category: "Primo",ingredients: null));
    dishList.add(Dish(id:"3",name:"riso",category: "Primo",ingredients: null));
    return dishList;
  }

  @action
  Future<void> getYourDishes() async {
   await (FirebaseFirestore.instance
        .collection('DishesCreatedByUsers')
        .doc(auth.currentUser.uid).collection("Dishes").get()
        .then((querySnapshot){
          querySnapshot.docs.forEach((dish) {
            Dish toAdd = new Dish(id: dish.id,name: dish.get("name"), category: dish.get("category"),qty: dish.get("qty"),ingredients: null);
            yourCreatedDishList.add(toAdd);
            });
          })
   );
  }
}

