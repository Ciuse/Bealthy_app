import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Database/mealTimeBool.dart';
import 'package:Bealthy_app/Database/symptom.dart';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/overviewStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
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

  testWidgets('Symptom page, adding new symptom test', (WidgetTester tester) async {
    final _providerKey = GlobalKey();

    var symptom = new Symptom(id:"Symptom_1",name:"Growling",description:"lorem ipsum",symptoms:"lorem ipsum");
    symptom.intensity = 0;
    symptom.frequency = 0;
    await tester.pumpAndSettle();

    await tester.pumpWidget(MultiProvider(providers: [
      Provider<DateStore>(
        create: (_) => DateStore(),
      ),
      Provider<OverviewStore>(
        create: (_) => OverviewStore(),
      ),
      Provider<SymptomStore>(

        create: (_) => SymptomStore(),
      ),
    ], child:MaterialApp(  key: _providerKey,home: SymptomPage(symptom: symptom,),navigatorObservers: [mockObserver],),
    ),);

    var symptomStore = Provider.of<SymptomStore>(_providerKey.currentContext,listen: false);

    final elevatedButton = find.byKey(Key("buttonSaveRemove"));
    expect(elevatedButton,findsNWidgets(1));

    //setto tutti i parametri e quindi mi aspetto di trovare il bottone SAVE
    symptom.intensityTemp = 2;
    symptom.frequencyTemp = 3;
    symptom.isSymptomSelectDay=false;

    MealTime.values.forEach((element) {
      MealTimeBool mealTimeBool = new MealTimeBool(isSelected: false);
      symptom.mealTimeBoolList.add(mealTimeBool);
      MealTimeBool mealTimeBoolTemp = new MealTimeBool(isSelected: true);
      symptom.mealTimeBoolListTemp.add(mealTimeBoolTemp);
    });
    symptom.isModifyButtonActive =true;
    symptom.isModeRemove = false;
    await tester.pumpAndSettle();
    expect(find.text("SAVE"), findsNWidgets(1));

    int length =symptomStore.symptomListOfSpecificDay.length;


    await tester.tap(find.byKey(Key("buttonSaveRemove")));
    await tester.pumpAndSettle();
    expect(symptomStore.symptomListOfSpecificDay.length,length+1);
    expect(symptom.isSymptomSelectDay,true);
  });

  testWidgets('Symptom page, removing symptom test', (WidgetTester tester) async {
    final _providerKey = GlobalKey();

    //il sintomo ha questi valori
    var symptom = new Symptom(id:"Symptom_1",name:"Growling",description:"lorem ipsum",symptoms:"lorem ipsum");
    symptom.intensity = 3;
    symptom.frequency = 2;
    MealTime.values.forEach((element) {
      MealTimeBool mealTimeBool = new MealTimeBool(isSelected: true);
      symptom.mealTimeBoolList.add(mealTimeBool);
      MealTimeBool mealTimeBoolTemp = new MealTimeBool(isSelected: true);
      symptom.mealTimeBoolListTemp.add(mealTimeBoolTemp);
    });
    symptom.isSymptomSelectDay=true;
    symptom.isModifyButtonActive = false;


    //inizializzo i valori temporali del sintomo
    symptom.intensityTemp = symptom.intensity;
    symptom.frequencyTemp = symptom.frequency;
    symptom.isModeRemove=false;


    await tester.pumpWidget(MultiProvider(providers: [
      Provider<DateStore>(
        create: (_) => DateStore(),
      ),
      Provider<OverviewStore>(
        create: (_) => OverviewStore(),
      ),
      Provider<SymptomStore>(

        create: (_) => SymptomStore(),
      ),
    ], child:MaterialApp(  key: _providerKey,home: SymptomPage(symptom: symptom,),navigatorObservers: [mockObserver],),
    ),);

    var symptomStore = Provider.of<SymptomStore>(_providerKey.currentContext,listen: false);
    symptomStore.symptomListOfSpecificDay.add(symptom);
    int length =symptomStore.symptomListOfSpecificDay.length;

    //ciò che mi aspetto quando apro questa pagina
    expect(find.text("SAVE"), findsNWidgets(1));
    expect(find.text("REMOVE"), findsNWidgets(0));
    expect(find.text("RESET VALUES"), findsNWidgets(1));

    //resetto tutti i valori del sintomo presente in un giorno X
    symptom.resetTempValue();
    await tester.pumpAndSettle();


    //mi aspetto che compaia il bottone REMOVE
    expect(find.text("SAVE"), findsNWidgets(0));
    expect(find.text("REMOVE"), findsNWidgets(1));
    expect(symptom.isModifyButtonActive,true);
    expect(symptom.isModeRemove, true);
    expect(find.byKey(Key("buttonSaveRemove")), findsNWidgets(1));
    await tester.pumpAndSettle();


    //clicco il bottone REMOVE e mi aspetto che si apra l'alert dialog
    ElevatedButton button = find.widgetWithText(ElevatedButton, 'REMOVE').evaluate().first.widget;
    button.onPressed();
    await tester.pumpAndSettle();
    expect(find.byKey(Key("alertDialog")), findsNWidgets(1));

    //confermo l'eliminazione del sintomo
    FlatButton buttonRemove = find.widgetWithText(FlatButton,"REMOVE").evaluate().first.widget;
    buttonRemove.onPressed();
    await tester.pumpAndSettle();

    //mi aspetto che la lista dei sintomi di quel giorno sia diminuita di un'unità
    expect(symptomStore.symptomListOfSpecificDay.length,length-1);

  });
}
