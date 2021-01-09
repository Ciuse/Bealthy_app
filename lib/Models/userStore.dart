import 'dart:io';

import 'package:Bealthy_app/Database/symptom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'userStore.g.dart';


//flutter packages pub run build_runner build
//flutter packages pub run build_runner watch
//flutter packages pub run build_runner watch --delete-conflicting-outputs
FirebaseAuth auth = FirebaseAuth.instance;

// This is the class used by rest of your codebase
class UserStore = _UserStoreBase with _$UserStore;

// The store-class
abstract class _UserStoreBase with Store {
  final firestoreInstance = FirebaseFirestore.instance;

  @observable
  File profileImage;

  var personalPageSymptomsList = new List<Symptom>();

  @observable
  ObservableFuture loadInitOccurrenceSymptomsList;

  Future<void> initUserDb() async{
    profileImage=null;
    await Future.wait([_initDishCreated(),
      _initDishFavourite(),
      _initUserSymptom(),
      _initUserDish(),
      _initUserSymptomsOccurrence(),
    ]);
  }

  Future<void> _initDishCreated() async{
    await  FirebaseFirestore.instance
        .collection("DishesCreatedByUsers")
        .doc(auth.currentUser.uid)
        .set({"virtual": true});
  }

  Future<void> _initDishFavourite() async{
    await  FirebaseFirestore.instance
        .collection("DishesFavouriteByUsers")
        .doc(auth.currentUser.uid)
        .set({"virtual": true});
  }

  Future<void> _initUserSymptom() async{
    await  FirebaseFirestore.instance
        .collection("UserSymptoms")
        .doc(auth.currentUser.uid)
        .set({"virtual": true});
  }

  Future<void> _initUserDish() async{
    await  FirebaseFirestore.instance
        .collection("UserDishes")
        .doc(auth.currentUser.uid)
        .set({"virtual": true});
  }

  Future<void> _initUserSymptomsOccurrence() async{
    await  FirebaseFirestore.instance
        .collection("UserSymptomsOccurrence")
        .doc(auth.currentUser.uid)
        .set({"virtual": true});
  }

  @action
  Future<void> initPersonalPage()async{
    return loadInitOccurrenceSymptomsList = ObservableFuture(occurrenceInit());

  }

  @action
  Future<void> retryForOccurrenceSymptoms() {
    return loadInitOccurrenceSymptomsList = ObservableFuture(occurrenceInit());
  }

  @action
  Future<void> occurrenceInit() async{
    await _getSymptomListForPersonalPage()
        .then((value) =>
        personalPageSymptomsList.sort((a, b) => a.occurrence.compareTo(b.occurrence)));
  }


  @action
  Future<void> _getSymptomListForPersonalPage() async {
    personalPageSymptomsList.clear();
    await (FirebaseFirestore.instance
        .collection("UserSymptomsOccurrence")
        .doc(auth.currentUser.uid)
        .collection("Symptoms")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Symptom i = new Symptom(id:result.id,name:result.get("name") );
        i.occurrence = result.get("occurrence");
        personalPageSymptomsList.add(i);
      }
      );
    }));
  }
}
