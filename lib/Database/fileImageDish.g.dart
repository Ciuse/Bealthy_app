// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fileImageDish.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FileImageDish on _FileImageDishBase, Store {
  final _$isActiveAtom = Atom(name: '_FileImageDishBase.isActive');

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

  final _$imageFileAtom = Atom(name: '_FileImageDishBase.imageFile');

  @override
  File get imageFile {
    _$imageFileAtom.reportRead();
    return super.imageFile;
  }

  @override
  set imageFile(File value) {
    _$imageFileAtom.reportWrite(value, super.imageFile, () {
      super.imageFile = value;
    });
  }

  final _$_FileImageDishBaseActionController =
      ActionController(name: '_FileImageDishBase');

  @override
  void setBool(bool value) {
    final _$actionInfo = _$_FileImageDishBaseActionController.startAction(
        name: '_FileImageDishBase.setBool');
    try {
      return super.setBool(value);
    } finally {
      _$_FileImageDishBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isActive: ${isActive},
imageFile: ${imageFile}
    ''';
  }
}
