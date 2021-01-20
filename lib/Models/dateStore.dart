import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Database/symptom.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'dateStore.g.dart';

// This is the class used by rest of your codebase
class DateStore = _DateStoreBase with _$DateStore;

// The store-class
abstract class _DateStoreBase with Store {
  FirebaseAuth auth = FirebaseAuth.instance;

  @observable
  DateTime calendarSelectedDate = DateTime.now() ;

  @computed
  int get weekDay => calendarSelectedDate.weekday;

  @observable
  DateTime overviewDefaultLastDate = DateTime.now();

  @observable
  var rangeDays= new ObservableList<DateTime>();

  @observable
  TemporalTime timeSelected = TemporalTime.Day;

  @observable
  DateTime overviewFirstDate;

  @observable
  bool calculationPeriodInProgress = false;

  @observable
  var illnesses = ObservableMap<DateTime, List>();

  @observable
  bool initializeIllnesses=false;

  void initIllnesses(){
    if(initializeIllnesses==false){
      initializeIllnesses=true;
      getAllSickDay();
    }
  }

  Future<void> getAllSickDay() async {
    await (FirebaseFirestore.instance
        .collection('UserSymptoms')
        .doc(auth.currentUser.uid).collection("DaySymptoms")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((day) async{
        await (FirebaseFirestore.instance
            .collection('UserSymptoms')
            .doc(auth.currentUser.uid).collection("DaySymptoms")
            .doc(day.id).collection("Symptoms").get() .then((querySnapshot) {
          if(querySnapshot.docs.length>0){
            illnesses.putIfAbsent(setDateFromString(day.id), () => ['']);
          };
        }));
      }
      );
    })
    );
  }

  @action
  void addIllnesses(DateTime day){
    illnesses.putIfAbsent(day, () => ['']);
  }

  @action
  void removeIllnesses(SymptomStore symptomStore,DateTime day){
    if(symptomStore.symptomListOfSpecificDay.length==1){
      illnesses.remove(day);
    }
  }

  @action
  DateTime setDateFromString(String dateTime){
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    return dateFormat.parse(dateTime);
  }

  @action
  void getDaysOfAWeekOrMonth(DateTime firstDate, DateTime lastDate) {
    rangeDays.clear();
    for (int i = 0; i <= lastDate.difference(firstDate).inDays; i++) {
      rangeDays.add(firstDate.add(Duration(days: i)));
    }

  }

  @action
  List<DateTime> returnDaysOfAWeekOrMonth(DateTime firstDate, DateTime lastDate) {
    List<DateTime> dates = new List<DateTime>();
    for (int i = 0; i <= lastDate.difference(firstDate).inDays; i++) {
      dates.add(firstDate.add(Duration(days: i)));
    }
    return dates;
  }

  @action
  void changeCurrentDate(DateTime date) {
    this.calendarSelectedDate = date;
    fixDate(date);
  }

  @action
  void fixDate(DateTime date){
    String dateSlug ="${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
    print(dateSlug);
  }

@action
  void nextDayCalendar() {
  calendarSelectedDate = DateTime(calendarSelectedDate.year, calendarSelectedDate.month, calendarSelectedDate.day+1);
  }

  @action
  void previousDayCalendar() {
    calendarSelectedDate = DateTime(calendarSelectedDate.year, calendarSelectedDate.month, calendarSelectedDate.day-1);
  }
  @action
  void nextDayOverview() {
    overviewDefaultLastDate = DateTime(overviewDefaultLastDate.year, overviewDefaultLastDate.month, overviewDefaultLastDate.day+1);
  }

  @action
  void previousDayOverview() {
    overviewDefaultLastDate = DateTime(overviewDefaultLastDate.year, overviewDefaultLastDate.month, overviewDefaultLastDate.day-1);
  }

  @action
  void nextWeekOverview() {
    overviewFirstDate = DateTime(overviewFirstDate.year, overviewFirstDate.month, overviewFirstDate.day+7);
    overviewDefaultLastDate = DateTime(overviewDefaultLastDate.year, overviewDefaultLastDate.month, overviewDefaultLastDate.day+7);
    getDaysOfAWeekOrMonth(overviewFirstDate, overviewDefaultLastDate);
  }

  @action
  void previousWeekOverview() {
    overviewFirstDate = DateTime(overviewFirstDate.year, overviewFirstDate.month, overviewFirstDate.day-7);
    overviewDefaultLastDate = DateTime(overviewDefaultLastDate.year, overviewDefaultLastDate.month, overviewDefaultLastDate.day-7);
    getDaysOfAWeekOrMonth(overviewFirstDate, overviewDefaultLastDate);
  }

  @action
  void nextMonthOverview() {
    overviewFirstDate = DateTime(overviewFirstDate.year, overviewFirstDate.month,overviewFirstDate.day+31);
    overviewDefaultLastDate = DateTime(overviewDefaultLastDate.year, overviewDefaultLastDate.month,overviewDefaultLastDate.day+31 );
    getDaysOfAWeekOrMonth(overviewFirstDate, overviewDefaultLastDate);
  }

  @action
  void previousMonthOverview() {
    overviewFirstDate = DateTime(overviewFirstDate.year, overviewFirstDate.month,overviewFirstDate.day-31);
    overviewDefaultLastDate = DateTime(overviewDefaultLastDate.year, overviewDefaultLastDate.month,overviewDefaultLastDate.day-31 );
    getDaysOfAWeekOrMonth(overviewFirstDate, overviewDefaultLastDate);
  }



  @action
  void firstDayInWeek() {
    calculationPeriodInProgress = true;
    overviewFirstDate = DateTime(overviewDefaultLastDate.year, overviewDefaultLastDate.month, overviewDefaultLastDate.day-6);
    getDaysOfAWeekOrMonth(overviewFirstDate, overviewDefaultLastDate);

  }

  @action
  void firstDayInMonth() {
    calculationPeriodInProgress = true;
    overviewFirstDate = DateTime(overviewDefaultLastDate.year, overviewDefaultLastDate.month,overviewDefaultLastDate.day-31 );
    getDaysOfAWeekOrMonth(overviewFirstDate, overviewDefaultLastDate);

  }
}

