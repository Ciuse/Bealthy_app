import 'package:Bealthy_app/Database/symptom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../WidgetTest/firebaseMock.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  Symptom symptom = new Symptom();
  symptom.id="Symptom_1";
  Map<String, dynamic> symptomModel = { "id": symptom.id, "name": symptom.name, "description":symptom.description,"symptoms": symptom.symptoms};
  Map<String, dynamic> responseSymptomMapReturn = { "id": symptom.id, "name": symptom.name, "description":symptom.description,"symptoms": symptom.symptoms};

  MockFirestore instance;
  MockDocumentSnapshot mockDocumentSnapshot;
  MockCollectionReference mockCollectionReference;
  MockDocumentReference mockDocumentReference;

  setUp(() {
    instance = MockFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot();
  });

  test('should return data when the call to remote source is successful.', () async {
    when(instance.collection(any)).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
    when(mockDocumentReference.get()).thenAnswer((_) async => mockDocumentSnapshot);
    when(mockDocumentSnapshot.data()).thenReturn(responseSymptomMapReturn=symptomModel);
    //act



    final result = await FirebaseFirestore.instance
        .collection('Symptoms')
        .doc("Symptom_1");
    print(result.snapshots());
    //assert
    expect(result.id, responseSymptomMapReturn["id"]); //userModel is a object that is defined. Replace with you own model class object.
  });
}