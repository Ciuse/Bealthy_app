import 'package:mobx/mobx.dart';

// Include generated file
part 'observableValues.g.dart';

// This is the class used by rest of your codebase
class ObservableValues = _ObservableValuesBase with _$ObservableValues;

// The store-class
abstract class _ObservableValuesBase with Store {

  _ObservableValuesBase({this.stringIngredients});

  @observable
  String stringIngredients;


}