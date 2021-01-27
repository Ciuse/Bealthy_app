import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/searchDishesList.dart';
import 'package:Bealthy_app/addMeal.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:Bealthy_app/Models/barCodeScannerStore.dart';
import 'firebaseMock.dart';
import 'package:Bealthy_app/Models/foodStore.dart';
import 'package:Bealthy_app/Models/ingredientStore.dart';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/mealTimeStore.dart';
import 'package:Bealthy_app/Database/dish.dart';
import 'package:Bealthy_app/Database/observableValues.dart';
import 'package:Bealthy_app/Database/ingredient.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();


  });
  final mockObserver = MockNavigatorObserver();

  testWidgets('Adding new dish with search test', (WidgetTester tester) async {
    final _providerKey = GlobalKey();


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

    ], child:MaterialApp(  key: _providerKey,home: AddMeal(title: MealTime.Snack.toString().split('.').last),navigatorObservers: [mockObserver],),
    ),);

    var foodStore = Provider.of<FoodStore>(_providerKey.currentContext,listen: false);
    var dateStore = Provider.of<DateStore>(_providerKey.currentContext,listen: false);
    var mealTimeStore = Provider.of<MealTimeStore>(_providerKey.currentContext,listen: false);

    final searchDishesPage = find.byType(SearchDishesList);
    expect(searchDishesPage,findsNothing);
    expect(find.byKey(Key("searchButton")), findsNWidgets(1));

    int length = foodStore.dishesListFromDBAndUser.length;
    int lengthResultList = foodStore.resultsList.length;

    //creo e inserisco nella lista un piatto e i suoi ingredienti
    Dish dish = new Dish(id:"Dish_1",name:"Pasta al pesto" ,qty: "",);
    ObservableValues value = new ObservableValues(stringIngredients: "");
    Ingredient i = new Ingredient(id:"Ingr_11",name:"Pasta",qty:"Lots");
    Ingredient ing = new Ingredient(id:"Ingr_13",name:"Basil",qty:"Normal");
    String ingredients =  i.name+", "+ing.name;
    await tester.runAsync(() async {
      foodStore.mapIngredientsStringDish.putIfAbsent(dish, () => value);
      foodStore.dishesListFromDBAndUser.add(dish);
      foodStore.mapIngredientsStringDish[dish].stringIngredients = ingredients;

      //simulo il loading della pagina searchDishes list
      foodStore.loadInitSearchAllDishesList = ObservableFuture.value([dish]);
      foodStore.storeSearchAllDishInitialized=true;
      foodStore.resultsList.clear();
      mealTimeStore.selectedMealTime= MealTime.Snack;
      dateStore.calendarSelectedDate=DateTime.now();
      await  tester.pumpAndSettle();
    });


    expect(foodStore.dishesListFromDBAndUser.length,length+ 1);


    // //inserisco il piatto anche nella lista degli snack così da verificare che il piatto non possa essere aggiunto
    // mealTimeStore.snackDishesList.add(dish);

    //clicco il bottone "SEARCH" e mi aspetto che si apra la pagina Search Dishes
    await tester.runAsync(() async {

      //clicco il bottone che mi apre la search dishes list
      TextButton button = find.byKey(Key("searchButton"),).evaluate().first.widget;
      button.onPressed();

      await tester.pumpAndSettle();
    });



    //aspetto che la pagina searchDishes si carichi
    expect(searchDishesPage,findsOneWidget);
    expect(find.byKey(Key("ListView")), findsNWidgets(1));
    expect(foodStore.resultsList.length,lengthResultList+ 1);
    expect(find.byType(ListTile),findsOneWidget);
    expect(mealTimeStore.checkIfDishIsPresent(dish),false);

    int snackLength= mealTimeStore.getDishesOfMealTimeList(mealTimeStore.selectedMealTime.index).length;

    //clicco il list tile del cibo e mi aspetto che si apra l'alert dialog
    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("alertDialog")), findsNWidgets(1));
    dish.valueShowDialog=1;

    //clicco il flat botton ADD e mi aspetto che la lunghezza della snack list sia aumentata di un'unità
    FlatButton button = find.widgetWithText(FlatButton, 'ADD').evaluate().first.widget;
    button.onPressed();
    await tester.pumpAndSettle();
    expect(mealTimeStore.getDishesOfMealTimeList(mealTimeStore.selectedMealTime.index).length, snackLength+1);

  });

  testWidgets('Trying to add already present dish with search test', (WidgetTester tester) async {
    final _providerKey = GlobalKey();


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

    ], child:MaterialApp(  key: _providerKey,home: AddMeal(title: MealTime.Snack.toString().split('.').last),navigatorObservers: [mockObserver],),
    ),);

    var foodStore = Provider.of<FoodStore>(_providerKey.currentContext,listen: false);
    var dateStore = Provider.of<DateStore>(_providerKey.currentContext,listen: false);
    var mealTimeStore = Provider.of<MealTimeStore>(_providerKey.currentContext,listen: false);

    final searchDishesPage = find.byType(SearchDishesList);
    expect(searchDishesPage,findsNothing);
    expect(find.byKey(Key("searchButton")), findsNWidgets(1));

    int length = foodStore.dishesListFromDBAndUser.length;
    int lengthResultList = foodStore.resultsList.length;

    //creo e inserisco nella lista un piatto e i suoi ingredienti
    Dish dish = new Dish(id:"Dish_1",name:"Pasta al pesto" ,qty: "",);
    ObservableValues value = new ObservableValues(stringIngredients: "");
    Ingredient i = new Ingredient(id:"Ingr_11",name:"Pasta",qty:"Lots");
    Ingredient ing = new Ingredient(id:"Ingr_13",name:"Basil",qty:"Normal");
    String ingredients =  i.name+", "+ing.name;
    await tester.runAsync(() async {
      foodStore.mapIngredientsStringDish.putIfAbsent(dish, () => value);
      foodStore.dishesListFromDBAndUser.add(dish);
      foodStore.mapIngredientsStringDish[dish].stringIngredients = ingredients;

      //simulo il loading della pagina searchDishes list
      foodStore.loadInitSearchAllDishesList = ObservableFuture.value([dish]);
      foodStore.storeSearchAllDishInitialized=true;
      foodStore.resultsList.clear();
      mealTimeStore.selectedMealTime= MealTime.Snack;
      dateStore.calendarSelectedDate=DateTime.now();

      //il dish risulterà già presente nella lista dei piatti nel snack mealTime
      mealTimeStore.getDishesOfMealTimeList(mealTimeStore.selectedMealTime.index).add(dish);

      await  tester.pumpAndSettle();
    });


    expect(foodStore.dishesListFromDBAndUser.length,length+ 1);


    // //inserisco il piatto anche nella lista degli snack così da verificare che il piatto non possa essere aggiunto
    // mealTimeStore.snackDishesList.add(dish);

    //clicco il bottone "SEARCH" e mi aspetto che si apra la pagina Search Dishes
    await tester.runAsync(() async {

      //clicco il bottone che mi apre la search dishes list
      TextButton button = find.byKey(Key("searchButton"),).evaluate().first.widget;
      button.onPressed();

      await tester.pumpAndSettle();
    });



    //aspetto che la pagina searchDishes si carichi
    expect(searchDishesPage,findsOneWidget);
    expect(find.byKey(Key("ListView")), findsNWidgets(1));
    expect(foodStore.resultsList.length,lengthResultList+ 1);
    expect(find.byType(ListTile),findsOneWidget);
    //il dish dovrebbe essere già presente in quel giorno nella lista snack
    expect(mealTimeStore.checkIfDishIsPresent(dish),true);



    //clicco il bottone ADD e mi aspetto che compaia un  alert dialog in quanto il dish è già presente
    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("alertDialogDishPresent")), findsNWidgets(1));




  });
}