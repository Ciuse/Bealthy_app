import 'package:mobx/mobx.dart';
import 'package:intl/intl.dart';

// Include generated file
part 'mealTimeBool.g.dart';

// This is the class used by rest of your codebase
class MealTimeBool = _MealTimeBoolBase with _$MealTimeBool;

// The store-class
abstract class _MealTimeBoolBase with Store {

  _MealTimeBoolBase({this.isSelected});

  @observable
  bool isSelected;

  @action
  void setIsSelected(bool value) {
    isSelected = value;
  }

}