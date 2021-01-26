import 'package:Bealthy_app/Database/symptom.dart';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:Bealthy_app/allSymptomsPage.dart';
import 'package:Bealthy_app/symptomPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'firebaseMock.dart';
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();


  });
  final mockObserver = MockNavigatorObserver();

  testWidgets('All symptoms page test', (WidgetTester tester) async {
    final _providerKey = GlobalKey();
    final _childKey = GlobalKey();
    await tester.pumpWidget(MultiProvider(providers: [
      Provider<DateStore>(
        create: (_) => DateStore(),
      ),

      Provider<SymptomStore>(

        create: (_) => SymptomStore(),
      ),
    ], child:MaterialApp(  key: _providerKey,home: AllSymptomsPage(),navigatorObservers: [mockObserver],),
    ),);

    var symptomStore = Provider.of<SymptomStore>(_providerKey.currentContext,listen: false);
    var symptom = new Symptom(id:"Symptom_1",name:"Growling",description:"lorem ipsum",symptoms:"lorem ipsum");
    symptom.intensity = 0;
    symptom.frequency = 0;
    symptomStore.symptomList.add(symptom);
    await tester.pumpAndSettle();

    final addIconFinder = find.byIcon(Icons.info_outline);
    expect(addIconFinder, findsNWidgets(1));

    final listViewForAMealTime = find.byKey(Key("symptomsContent"));
    expect(listViewForAMealTime,findsNWidgets(1));

    expect(find.byKey(Key(symptom.id)), findsNWidgets(1));
    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();
    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));
    /// You'd also want to be sure that your page is now
    /// present in the screen.
    expect(find.byType(SymptomPage),findsOneWidget);
    expect(find.text('Growling'), findsOneWidget);
  });
}
