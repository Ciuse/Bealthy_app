import 'package:Bealthy_app/Database/dish.dart';
import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Database/ingredient.dart';
import 'package:Bealthy_app/Database/observableValues.dart';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/foodStore.dart';
import 'package:Bealthy_app/Models/ingredientStore.dart';
import 'package:Bealthy_app/Models/mealTimeStore.dart';
import 'package:Bealthy_app/searchDishesList.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../WidgetTest/firebaseMock.dart';


class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockAPI  {

  Future<List<Dish>> getDishes(IngredientStore ingredientStore,FoodStore foodStore) async {
    return Future.value([
    Dish(id:"Dish_1",name:"Pasta al pesto" ,qty: "Lots"),
      Dish(id:"Dish_2",name:"Pasta al sugo" ,qty: "Normal"),
      Dish(id:"Dish_3",name:"Pasta alla panna" ,qty: "Little"),
      Dish(id:"Dish_4",name:"Pasta aglio olio peperoncino" ,qty: "Normal"),
    ]);
  }

  Future<List<Ingredient>> getIngredients() async {
    return Future.value([
      Ingredient(id:"Ingr_1",name:"basil",qty:"Little" ),
      Ingredient(id:"Ingr_2",name:"tomato",qty:"Little" ),
      Ingredient(id:"Ingr_3",name:"salt",qty:"Normal" ),
    ]);
  }

  Future<void> getDishesFromDBAndUser(IngredientStore ingredientStore,FoodStore foodStore) async {
    List<Dish> dishes = await getDishes(ingredientStore,foodStore);
    dishes.forEach((element) {
      ObservableValues value = new ObservableValues(stringIngredients: "");
      foodStore.mapIngredientsStringDish.putIfAbsent(element, () => value);
      foodStore.dishesListFromDBAndUser.add(element);
      initializeIngredients(element, ingredientStore,foodStore);
    });

  }

  Future<void> initializeIngredients(Dish dish, IngredientStore ingredientStore,FoodStore foodStore)async {
    String ingredients = "";

      List<Ingredient> ingredientsDish = await getIngredients();
      ingredientsDish.forEach((element) {
        ingredients = ingredients + element.name;
        ingredients =  ingredients+", ";
      });


    foodStore.mapIngredientsStringDish[dish].stringIngredients = ingredients.substring(0, ingredients.length - 2);
  }
}

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();


  });
  final mockObserver = MockNavigatorObserver();
final mockApi = MockAPI();



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


    ], child:MaterialApp(  key: _providerKey,home: SearchDishesList(),navigatorObservers: [mockObserver],),
    ),);

    var foodStore = Provider.of<FoodStore>(_providerKey.currentContext,listen: false);
    var dateStore = Provider.of<DateStore>(_providerKey.currentContext,listen: false);
    var mealTimeStore = Provider.of<MealTimeStore>(_providerKey.currentContext,listen: false);
    var ingredientStore = Provider.of<IngredientStore>(_providerKey.currentContext,listen: false);

    //simulo il loading della pagina searchDishes list
    foodStore.loadInitSearchAllDishesList = ObservableFuture(mockApi.getDishesFromDBAndUser(ingredientStore,foodStore));
    foodStore.storeSearchAllDishInitialized=true;
    foodStore.resultsList.clear();
    mealTimeStore.selectedMealTime= MealTime.Snack;
    dateStore.calendarSelectedDate=DateTime.now();


    await  tester.pumpAndSettle();

    expect(foodStore.dishesListFromDBAndUser.length,4);
    expect(find.byKey(Key("ListView")), findsNWidgets(1));
    expect(find.byType(ListTile), findsNWidgets(4));


  });
}