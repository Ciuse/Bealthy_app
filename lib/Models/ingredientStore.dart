import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Include generated file
part 'ingredientStore.g.dart';

// This is the class used by rest of your codebase
class IngredientStore = _IngredientStoreBase with _$IngredientStore;

// The store-class
abstract class _IngredientStoreBase with Store {
  final firestoreInstance = FirebaseFirestore.instance;

  @observable
  ObservableList ingredientList = new ObservableList();



}


