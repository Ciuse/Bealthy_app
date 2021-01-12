import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'dart:io';

part 'treatment.g.dart';

String clientToMap1(_TreatmentBase data) => json.encode(data.toMapTreatment());



// This is the class used by rest of your codebase
class Treatment = _TreatmentBase with _$Treatment;

// The store-class
abstract class _TreatmentBase with Store {
  _TreatmentBase({
    this.id,
    this.title,
    this.startingDay,
    this.endingDay,
    this.descriptionText,
    this.dietInfoText,
    this.medicalInfoText,
  });

  @observable
  String id;
  @observable
  String title;
  @observable
  String startingDay;
  @observable
  String endingDay;
  @observable
  String descriptionText;
  @observable
  String dietInfoText;
  @observable
  String medicalInfoText;


  @action
  String fixDate(DateTime date){
    return "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";

  }

  @action
  DateTime setDateFromString(String dateTime){
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    return dateFormat.parse(dateTime);
  }

  Map<String, dynamic> toMapTreatment() =>
      {
        "title": title,
        "startingDay": startingDay,
        "endingDay": endingDay,
        "descriptionText": descriptionText,
        "dietInfoText": dietInfoText,
        "medicalInfoText": medicalInfoText,
      };


}