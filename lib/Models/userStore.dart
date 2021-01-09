import 'dart:io';

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
}
