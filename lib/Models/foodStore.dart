import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Include generated file
part 'foodStore.g.dart';

// This is the class used by rest of your codebase
class FoodStore = _FoodStoreBase with _$FoodStore;

// The store-class
abstract class _FoodStoreBase with Store {
  final firestoreInstance = FirebaseFirestore.instance;

@action
  void addDish() {
    firestoreInstance.collection("dishes").add(
        {
          "name" : "Pasta alla carbonara",
          "day" : DateTime.now(),
        }).then((value){
      firestoreInstance
          .collection("dishes")
          .doc(value.id)
          .collection("ingredients")
          .add({"name": "egg"});
    });
  }

  @action
  void getDishes() {
    firestoreInstance.collection("dishes").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
        firestoreInstance
            .collection("dishes")
            .doc(result.id)
            .collection("ingredients")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            print(result.data());
          });
      });
    });
  });
  }


}


