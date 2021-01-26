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

  final _$fractionSeverityOccurrenceAtom =
      Atom(name: '_ObservableValuesBase.fractionSeverityOccurrence');

  @override
  double get fractionSeverityOccurrence {
    _$fractionSeverityOccurrenceAtom.reportRead();
    return super.fractionSeverityOccurrence;
  }

  @override
  set fractionSeverityOccurrence(double value) {
    _$fractionSeverityOccurrenceAtom
        .reportWrite(value, super.fractionSeverityOccurrence, () {
      super.fractionSeverityOccurrence = value;
    });
  }

  final _$percentageSymptomAtom =
      Atom(name: '_ObservableValuesBase.percentageSymptom');

  @override
  double get percentageSymptom {
    _$percentageSymptomAtom.reportRead();
    return super.percentageSymptom;
  }

  @override
  set percentageSymptom(double value) {
    _$percentageSymptomAtom.reportWrite(value, super.percentageSymptom, () {
      super.percentageSymptom = value;
    });
  }

  final _$disappearedAtom = Atom(name: '_ObservableValuesBase.disappeared');

  @override
  bool get disappeared {
    _$disappearedAtom.reportRead();
    return super.disappeared;
  }

  @override
  set disappeared(bool value) {
    _$disappearedAtom.reportWrite(value, super.disappeared, () {
      super.disappeared = value;
    });
  }

  final _$appearedAtom = Atom(name: '_ObservableValuesBase.appeared');

  @override
  bool get appeared {
    _$appearedAtom.reportRead();
    return super.appeared;
  }

  @override
  set appeared(bool value) {
    _$appearedAtom.reportWrite(value, super.appeared, () {
      super.appeared = value;
    });
  }

  final _$mapSymptomPercentageAtom =
      Atom(name: '_ObservableValuesBase.mapSymptomPercentage');

  @override
  ObservableMap<String, ObservableValues> get mapSymptomPercentage {
    _$mapSymptomPercentageAtom.reportRead();
    return super.mapSymptomPercentage;
  }

  @override
  set mapSymptomPercentage(ObservableMap<String, ObservableValues> value) {
    _$mapSymptomPercentageAtom.reportWrite(value, super.mapSymptomPercentage,
        () {
      super.mapSymptomPercentage = value;
    });
  }

  @override
  String toString() {
    return '''
stringIngredients: ${stringIngredients},
severitySymptom: ${severitySymptom},
occurrenceSymptom: ${occurrenceSymptom},
fractionSeverityOccurrence: ${fractionSeverityOccurrence},
percentageSymptom: ${percentageSymptom},
disappeared: ${disappeared},
appeared: ${appeared},
mapSymptomPercentage: ${mapSymptomPercentage}
    ''';
  }
}
