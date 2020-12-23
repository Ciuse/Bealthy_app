import 'package:mobx/mobx.dart';

// Include generated file
part 'buttonStatusModel.g.dart';

// This is the class used by rest of your codebase
class ButtonStatusModel = _ButtonStatusModelBase with _$ButtonStatusModel;

// The store-class
abstract class _ButtonStatusModelBase with Store {

  _ButtonStatusModelBase({this.isActive});

  @observable
  bool isActive;

  @action
  void setBool(bool value) {
    isActive = value;
  }

}
