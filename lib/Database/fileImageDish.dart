import 'package:mobx/mobx.dart';
import 'dart:io';
// Include generated file
part 'fileImageDish.g.dart';

// This is the class used by rest of your codebase
class FileImageDish = _FileImageDishBase with _$FileImageDish;

// The store-class
abstract class _FileImageDishBase with Store {

  _FileImageDishBase({this.isActive});

  @observable
  bool isActive;

  @observable
  File imageFile = null;


  @action
  void setBool(bool value) {
    isActive = value;
  }

}
