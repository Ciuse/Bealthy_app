// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:Bealthy_app/Database/symptomOverviewGraphStore.dart';
import 'package:Bealthy_app/Models/barCodeScannerStore.dart';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/foodStore.dart';
import 'package:Bealthy_app/Models/ingredientStore.dart';
import 'package:Bealthy_app/Models/mealTimeStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:Bealthy_app/Models/treatmentStore.dart';
import 'package:Bealthy_app/Models/userStore.dart';
import 'package:Bealthy_app/calendar.dart';
import 'package:Bealthy_app/homePage.dart';
import 'package:Bealthy_app/listDishesOfDay.dart';
import 'package:Bealthy_app/main.dart';
import 'package:Bealthy_app/overviewPage.dart';
import 'package:Bealthy_app/personalPage.dart';
import 'package:Bealthy_app/symptomsBar.dart';
import 'package:Bealthy_app/treatmentPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'firebaseMock.dart';

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Home page bottom nav bar', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MultiProvider(providers: [
      Provider<DateStore>(
        create: (_) => DateStore(),
      ),
      Provider<FoodStore>(
        create: (_) => FoodStore(),
      ),
      Provider<IngredientStore>(
        create: (_) => IngredientStore(),
      ),
      Provider<SymptomStore>(
        create: (_) => SymptomStore(),
      ),
      Provider<MealTimeStore>(
        create: (_) => MealTimeStore(),
      ),
      Provider<UserStore>(
        create: (_) => UserStore(),
      ),
      Provider<SymptomOverviewGraphStore>(
        create: (_) => SymptomOverviewGraphStore(),
      ),
      Provider<TreatmentStore>(
        create: (_) => TreatmentStore(),
      ),
      Provider<BarCodeScannerStore>(
        create: (_) => BarCodeScannerStore(),
      ),
    ], child:MaterialApp( home: HomePage()),
    ),);


    final addIconFinder = find.byIcon(Icons.add);
    final addIconFinder2 = find.byIcon(Icons.breakfast_dining);
    final listViewForAMealTime = find.byKey(Key("listViewForAMealTime"));
    final homePageWidget = find.byType(HomePageWidget);
    final calendarFinder = find.byType(CalendarHomePage);
    final symptomBarFinder = find.byType(SymptomsBar);
    final listDishes = find.byType(ListDishesOfDay);
    final bottomNavBar = find.byType(BottomNavigationBar);

    expect(addIconFinder, findsNWidgets(5));
    expect(addIconFinder2, findsNWidgets(1));
    expect(calendarFinder, findsOneWidget);
    expect(symptomBarFinder, findsOneWidget);
    expect(homePageWidget,findsOneWidget);
    expect(listDishes,findsOneWidget);
    expect(bottomNavBar,findsOneWidget);
    expect(listViewForAMealTime,findsNWidgets(4));

    final statisticsPage = find.byType(OverviewPage);
    expect(statisticsPage,findsNothing);
    
    await tester.tap(find.byIcon(Icons.stacked_bar_chart));
    await tester.pumpAndSettle();
    expect(statisticsPage,findsOneWidget);

    await tester.tap(find.byIcon(Icons.calendar_today_sharp));
    await tester.pumpAndSettle();
    expect(find.byType(CalendarHomePage),findsOneWidget);

    await tester.tap(find.byIcon(Icons.medical_services_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(TreatmentPage),findsOneWidget);

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(find.byType(PersonalPage),findsOneWidget);

    //
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);
    // //
    // // // Tap the '+' icon and trigger a frame.
    // // await tester.tap(find.byIcon(Icons.add));
    // // await tester.pump();
    //
    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
