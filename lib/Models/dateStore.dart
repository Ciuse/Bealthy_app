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
  DateTime overviewSelectedDate = DateTime.now() ;

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
    overviewSelectedDate = DateTime(overviewSelectedDate.year, overviewSelectedDate.month, overviewSelectedDate.day+1);
  }

  @action
  void previousDayOverview() {
    overviewSelectedDate = DateTime(overviewSelectedDate.year, overviewSelectedDate.month, overviewSelectedDate.day-1);
  }
}

