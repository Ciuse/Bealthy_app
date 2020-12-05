import 'dart:async';

import 'package:Bealthy_app/Database/Disease.dart';
import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Include generated file
part 'diseaseStore.g.dart';


FirebaseAuth auth = FirebaseAuth.instance;

// This is the class used by rest of your codebase
class DiseaseStore = _DiseaseStoreBase with _$DiseaseStore;

// The store-class
abstract class _DiseaseStoreBase with Store {
  final firestoreInstance = FirebaseFirestore.instance;
  bool storeInitialized = false;

  @observable
  var diseaseList = new ObservableList<Disease>();

  @action
  Future<void> initStore() async {
    if (!storeInitialized) {
      await _getDiseaseList();
      storeInitialized = true;
    }
  }

  @action
  Future<void> _getDiseaseList() async {
    diseaseList.add(new Disease(id:"1",name: "Mal di pancia", intensity: null));
    diseaseList.add(new Disease(id:"1",name: "Mal di Testa", intensity: null));
    diseaseList.add(new Disease(id:"1",name: "Mal di Stomaco", intensity: null));
    diseaseList.add(new Disease(id:"1",name: "Vomito", intensity: null));
    diseaseList.add(new Disease(id:"1",name: "Dissenteria", intensity: null));
    diseaseList.add(new Disease(id:"1",name: "Irritazione", intensity: null));
    diseaseList.add(new Disease(id:"1",name: "Irritazione", intensity: null));

  }
}