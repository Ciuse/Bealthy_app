import 'package:mobx/mobx.dart';

// Include generated file
part 'date_model.g.dart';

// This is the class used by rest of your codebase
class DateModel = _DateModel with _$DateModel;

// The store-class
abstract class _DateModel with Store {
  _DateModel({this.date});
  @observable
  DateTime date = DateTime(0, 0, 0000) ;

  @computed
  int get weekDay => date.weekday;
}

