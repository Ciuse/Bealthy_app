import 'package:Bealthy_app/eatenDishPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:Bealthy_app/Models/barCodeScannerStore.dart';
import 'firebaseMock.dart';
import 'package:Bealthy_app/Models/foodStore.dart';
import 'package:Bealthy_app/Models/ingredientStore.dart';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/mealTimeStore.dart';
import 'package:Bealthy_app/Database/dish.dart';
import 'package:Bealthy_app/Database/ingredient.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();


  });
  final mockObserver = MockNavigatorObserver();


  testWidgets('Delete eaten dish created by user ', (WidgetTester tester) async {
    final _providerKey = GlobalKey();
    //il dish ha questi valori
    var dish = new Dish(id:"Dish_User_21",name:"Torta Cioccolato e Pere",mealTime:"Lunch",qty:"Little");
    Ingredient i = new Ingredient(id:"Ingr_1",name:"Cacao",qty:"Lots");
    Ingredient ing = new Ingredient(id:"Ingr_10",name:"Chocolate",qty:"Normal");
    Ingredient ingr = new Ingredient(id:"Ingr_2",name:"Pear",qty:"Normal");

    await tester.pumpWidget(MultiProvider(providers: [
      Provider<IngredientStore>(
        create: (_) => IngredientStore(),
      ),
      Provider<FoodStore>(
        create: (_) => FoodStore(),
      ),
      Provider<MealTimeStore>(
        create: (_) => MealTimeStore(),
      ),
      Provider<DateStore>(
        create: (_) => DateStore(),
      ),
      Provider<BarCodeScannerStore>(
        create: (_) => BarCodeScannerStore(),
      ),

    ], child:MaterialApp(  key: _providerKey,home: EatenDishPage(dish: dish,createdByUser: true,),navigatorObservers: [mockObserver],),
    ),);

    var ingredientStore = Provider.of<IngredientStore>(_providerKey.currentContext,listen: false);
    var dateStore = Provider.of<DateStore>(_providerKey.currentContext,listen: false);
    var mealTimeStore = Provider.of<MealTimeStore>(_providerKey.currentContext,listen: false);

    dateStore.calendarSelectedDate=DateTime.now();
    mealTimeStore.lunchDishesList.add(dish);
    int lunchLength = mealTimeStore.lunchDishesList.length;

    expect(find.text(dish.name), findsNWidgets(1));
    expect(find.byKey(Key("DeleteDishButton")), findsNWidgets(1));

    int length = ingredientStore.ingredientListOfDish.length;
    ingredientStore.ingredientListOfDish.add(i);
    ingredientStore.ingredientListOfDish.add(ing);
    ingredientStore.ingredientListOfDish.add(ingr);
    await  tester.pumpAndSettle();

    expect(ingredientStore.ingredientListOfDish.length,length+ 3);

    //clicco il bottone DELETE e mi aspetto che compaia un  alert dialog
    await tester.tap(find.byKey(Key("DeleteDishButton")));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("AlertDialog")), findsNWidgets(1));
    expect(find.byKey(Key("RemoveFlatButton")), findsNWidgets(1));

    //confermo l'eliminazione del piatto cliccando il Flat button "REMOVE"
    await tester.tap(find.byKey(Key("RemoveFlatButton")));
    expect(mealTimeStore.lunchDishesList.length,lunchLength-1);

  });
}