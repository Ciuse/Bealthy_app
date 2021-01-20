// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scrollControllerStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ScrollControllerStore on _ScrollControllerBase, Store {
  final _$scrollControllerAtom =
      Atom(name: '_ScrollControllerBase.scrollController');

  @override
  ScrollController get scrollController {
    _$scrollControllerAtom.reportRead();
    return super.scrollController;
  }

  @override
  set scrollController(ScrollController value) {
    _$scrollControllerAtom.reportWrite(value, super.scrollController, () {
      super.scrollController = value;
    });
  }

  final _$scaleAtom = Atom(name: '_ScrollControllerBase.scale');

  @override
  double get scale {
    _$scaleAtom.reportRead();
    return super.scale;
  }

  @override
  set scale(double value) {
    _$scaleAtom.reportWrite(value, super.scale, () {
      super.scale = value;
    });
  }

  final _$offsetAtom = Atom(name: '_ScrollControllerBase.offset');

  @override
  double get offset {
    _$offsetAtom.reportRead();
    return super.offset;
  }

  @override
  set offset(double value) {
    _$offsetAtom.reportWrite(value, super.offset, () {
      super.offset = value;
    });
  }

  @override
  String toString() {
    return '''
scrollController: ${scrollController},
scale: ${scale},
offset: ${offset}
    ''';
  }
}
