import 'dart:async';

import 'package:Bealthy_app/Database/Symptom.dart';
import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Include generated file
part 'symptomStore.g.dart';


FirebaseAuth auth = FirebaseAuth.instance;

// This is the class used by rest of your codebase
class SymptomStore = _SymptomStoreBase with _$SymptomStore;

// The store-class
abstract class _SymptomStoreBase with Store {
  final firestoreInstance = FirebaseFirestore.instance;
  bool storeInitialized = false;

  @observable
  var symptomList = new ObservableList<Symptom>();

  @action
  Future<void> initStore() async {
    if (!storeInitialized) {
      await _getsymptomList();
      storeInitialized = true;
    }
  }

  @action
  Future<void> _getsymptomList() async {
    symptomList.add(new Symptom(id:"1",name: "Mal di pancia", intensity: null));
    symptomList.add(new Symptom(id:"1",name: "Mal di Testa", intensity: null));
    symptomList.add(new Symptom(id:"1",name: "Mal di Stomaco", intensity: null));
    symptomList.add(new Symptom(id:"1",name: "Vomito", intensity: null));
    symptomList.add(new Symptom(id:"1",name: "Dissenteria", intensity: null));
    symptomList.add(new Symptom(id:"1",name: "Irritazione", intensity: null));
    symptomList.add(new Symptom(id:"1",name: "Irritazione", intensity: null));

  }
}