// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observableValues.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ObservableValues on _ObservableValuesBase, Store {
  final _$stringIngredientsAtom =
      Atom(name: '_ObservableValuesBase.stringIngredients');

  @override
  String get stringIngredients {
    _$stringIngredientsAtom.reportRead();
    return super.stringIngredients;
  }

  @override
  set stringIngredients(String value) {
    _$stringIngredientsAtom.reportWrite(value, super.stringIngredients, () {
      super.stringIngredients = value;
    });
  }

  final _$severitySymptomAtom =
      Atom(name: '_ObservableValuesBase.severitySymptom');

  @override
  double get severitySymptom {
    _$severitySymptomAtom.reportRead();
    return super.severitySymptom;
  }

  @override
  set severitySymptom(double value) {
    _$severitySymptomAtom.reportWrite(value, super.severitySymptom, () {
      super.severitySymptom = value;
    });
  }

  final _$occurrenceSymptomAtom =
      Atom(name: '_ObservableValuesBase.occurrenceSymptom');

  @override
  int get occurrenceSymptom {
    _$occurrenceSymptomAtom.reportRead();
    return super.occurrenceSymptom;
  }

  @override
  set occurrenceSymptom(int value) {
    _$occurrenceSymptomAtom.reportWrite(value, super.occurrenceSymptom, () {
      super.occurrenceSymptom = value;
    });
  }

  @override
  String toString() {
    return '''
stringIngredients: ${stringIngredients},
severitySymptom: ${severitySymptom},
occurrenceSymptom: ${occurrenceSymptom}
    ''';
  }
}
