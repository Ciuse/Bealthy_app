import 'package:mobx/mobx.dart';

// Include generated file
part 'dateStore.g.dart';

// This is the class used by rest of your codebase
class DateStore = _DateStoreBase with _$DateStore;

// The store-class
abstract class _DateStoreBase with Store {

  @observable
  DateTime selectedDate = DateTime.now() ;

  @computed
  int get weekDay => selectedDate.weekday;

  @action
  void changeCurrentDate(DateTime date) {
    this.selectedDate = date;
    fixDate(date);
  }

  @action
  void fixDate(DateTime date){
    String dateSlug ="${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
    print(dateSlug);
  }

@action
  void nextDay(DateTime day) {
      selectedDate = DateTime(day.year, day.month, day.day+1);
  }

  @action
  void previousDay(DateTime day) {
      selectedDate = DateTime(day.year, day.month, day.day-1);
  }

}

