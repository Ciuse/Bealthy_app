import 'package:mobx/mobx.dart';

// Include generated file
part 'date_model.g.dart';

// This is the class used by rest of your codebase
class DateModel = _DateModel with _$DateModel;

// The store-class
abstract class _DateModel with Store {

  @observable
  DateTime date = DateTime.now() ;

  @computed
  int get weekDay => date.weekday;

  @action
  void changeCurrentDate(DateTime date) {
    this.date = date;
  }
}

