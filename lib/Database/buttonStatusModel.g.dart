// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buttonStatusModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ButtonStatusModel on _ButtonStatusModelBase, Store {
  final _$isActiveAtom = Atom(name: '_ButtonStatusModelBase.isActive');

  @override
  bool get isActive {
    _$isActiveAtom.reportRead();
    return super.isActive;
  }

  @override
  set isActive(bool value) {
    _$isActiveAtom.reportWrite(value, super.isActive, () {
      super.isActive = value;
    });
  }

  final _$_ButtonStatusModelBaseActionController =
      ActionController(name: '_ButtonStatusModelBase');

  @override
  void setBool(bool value) {
    final _$actionInfo = _$_ButtonStatusModelBaseActionController.startAction(
        name: '_ButtonStatusModelBase.setBool');
    try {
      return super.setBool(value);
    } finally {
      _$_ButtonStatusModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isActive: ${isActive}
    ''';
  }
}
