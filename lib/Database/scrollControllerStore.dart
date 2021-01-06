import 'package:mobx/mobx.dart';
import 'dart:io';
import 'package:flutter/material.dart';

// Include generated file
part 'scrollControllerStore.g.dart';

// This is the class used by rest of your codebase
class ScrollControllerStore = _ScrollControllerBase with _$ScrollControllerStore;

// The store-class
abstract class _ScrollControllerBase with Store {

  @observable
  ScrollController scrollController = new ScrollController();

  @observable
  double scale= 0.0;

}
