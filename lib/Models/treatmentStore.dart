import 'package:Bealthy_app/Database/treatment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'treatmentStore.g.dart';


//flutter packages pub run build_runner build
//flutter packages pub run build_runner watch
//flutter packages pub run build_runner watch --delete-conflicting-outputs
FirebaseAuth auth = FirebaseAuth.instance;

// This is the class used by rest of your codebase
class TreatmentStore = _TreatmentStoreBase with _$TreatmentStore;

// The store-class
abstract class _TreatmentStoreBase with Store {
  final firestoreInstance = FirebaseFirestore.instance;

  @action
  Future<void> addNewTreatmentCreatedByUser(Treatment treatment) async {
    await firestoreInstance
        .collection("UserTreatments")
        .doc(auth.currentUser.uid)
        .collection("Treatments")
        .doc(treatment.id)
        .set(treatment.toMapTreatment());

  }

  Future<int> getLastTreatmentId() async {
    return await FirebaseFirestore.instance .collection("UserTreatments")
        .doc(auth.currentUser.uid)
        .collection("Treatments")
        .orderBy("number")
        .limitToLast(1)
        .get()
        .then((querySnapshot) {
      int toReturn;
      if(querySnapshot.size>0){
        querySnapshot.docs.forEach((treatment) {
          toReturn = treatment.get("number")+1;
        });
      }
      else{
        toReturn = 0;
      }
      return toReturn;
    });

  }

}