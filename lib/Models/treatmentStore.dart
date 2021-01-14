import 'package:Bealthy_app/Database/treatment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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

  @observable
  var treatmentsInProgressList = new ObservableList<Treatment>();
  @observable
  var treatmentsCompletedList = new ObservableList<Treatment>();

  @action
  Future<void> initTreatmentsList(DateTime day) async {
      _getTreatmentsList(day);
  }

  String fixDate(DateTime date) {
    String dateSlug = "${date.year.toString()}-${date.month.toString().padLeft(
        2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return dateSlug;
  }

  @action
  DateTime setDateFromString(String dateTime){
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    return dateFormat.parse(dateTime);
  }

  @action
  Future<void> _getTreatmentsList(DateTime date) async {

    treatmentsInProgressList.clear();
    treatmentsCompletedList.clear();
    await (firestoreInstance
        .collection("UserTreatments")
        .doc(auth.currentUser.uid)
        .collection("Treatments")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((treatment) {
        Treatment toAdd = new Treatment(id: treatment.id,
          title: treatment.get("title"),
          startingDay: treatment.get("startingDay"),
          endingDay: treatment.get("endingDay"),
          descriptionText: treatment.get("descriptionText"),
          dietInfoText: treatment.get("dietInfoText"),
          medicalInfoText: treatment.get("medicalInfoText"),
        );
        DateTime endingDay = setDateFromString(treatment.get("endingDay"));
        if(date.isBefore(endingDay)){
          treatmentsInProgressList.add(toAdd);
        }else{
          treatmentsCompletedList.add(toAdd);
        }
      });
    })
    );
  }

  @action
  Future<void> addNewTreatmentCreatedByUser(Treatment treatment) async {
    await (firestoreInstance
        .collection("UserTreatments")
        .doc(auth.currentUser.uid)
        .collection("Treatments")
        .doc(treatment.id)
        .set(treatment.toMapTreatment()));
    treatmentsInProgressList.add(treatment);
  }

  @action
  Future<void> removeTreatmentCreatedByUser(Treatment treatment) async {
    await (firestoreInstance
        .collection("UserTreatments")
        .doc(auth.currentUser.uid)
        .collection("Treatments")
        .doc(treatment.id)
        .delete());
    treatmentsInProgressList.removeWhere((element) => element.id == treatment.id);
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