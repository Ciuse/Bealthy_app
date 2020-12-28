import 'package:mobx/mobx.dart';

// Include generated file
part 'dateStore.g.dart';

// This is the class used by rest of your codebase
class DateStore = _DateStoreBase with _$DateStore;

// The store-class
abstract class _DateStoreBase with Store {

  @observable
  DateTime calendarSelectedDate = DateTime.now() ;

  @computed
  int get weekDay => calendarSelectedDate.weekday;

  @observable
  DateTime overviewDefaultLastDate = DateTime.now();

  @observable
  var rangeDays= new ObservableList<DateTime>();


  @observable
  DateTime overviewFirstDate;

  @action
  void getDaysOfAWeekOrMonth(DateTime firstDate, DateTime lastDate) {
    rangeDays.clear();
    for (int i = 0; i <= lastDate.difference(firstDate).inDays; i++) {
      rangeDays.add(firstDate.add(Duration(days: i)));
    }

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
    overviewFirstDate = DateTime(overviewFirstDate.year, overviewDefaultLastDate.month,overviewDefaultLastDate.day+31);
    overviewDefaultLastDate = DateTime(overviewDefaultLastDate.year, overviewDefaultLastDate.month,overviewDefaultLastDate.day+31 );
    getDaysOfAWeekOrMonth(overviewFirstDate, overviewDefaultLastDate);
  }

  @action
  void previousMonthOverview() {
    overviewFirstDate = DateTime(overviewFirstDate.year, overviewDefaultLastDate.month,overviewDefaultLastDate.day-31);
    overviewDefaultLastDate = DateTime(overviewDefaultLastDate.year, overviewDefaultLastDate.month,overviewDefaultLastDate.day-31 );
    getDaysOfAWeekOrMonth(overviewFirstDate, overviewDefaultLastDate);
  }



  @action
  void firstDayInWeek() {
    overviewFirstDate = DateTime(overviewDefaultLastDate.year, overviewDefaultLastDate.month, overviewDefaultLastDate.day-6);
    getDaysOfAWeekOrMonth(overviewFirstDate, overviewDefaultLastDate);
  }

  @action
  void firstDayInMonth() {
    overviewFirstDate = DateTime(overviewDefaultLastDate.year, overviewDefaultLastDate.month,overviewDefaultLastDate.day-31 );
    getDaysOfAWeekOrMonth(overviewFirstDate, overviewDefaultLastDate);
  }
}

