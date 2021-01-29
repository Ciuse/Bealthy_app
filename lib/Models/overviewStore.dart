import 'dart:async';
import 'dart:collection';

import 'package:Bealthy_app/Database/dish.dart';
import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Database/ingredient.dart';
import 'package:Bealthy_app/Database/symptom.dart';
import 'package:Bealthy_app/Database/ingredient.dart';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sortedmap/sortedmap.dart';

// Include generated file
part 'overviewStore.g.dart';


FirebaseAuth auth = FirebaseAuth.instance;

// This is the class used by rest of your codebase
class OverviewStore = _OverviewBase with _$OverviewStore;

// The store-class
abstract class _OverviewBase with Store {

  final firestoreInstance = FirebaseFirestore.instance;
  bool storeInitialized = false;

  TemporalTime timeSelected;

  _OverviewBase({
    this.timeSelected,

  });


  @observable
  var mapSymptomsOverviewPeriod = new ObservableMap<DateTime,List<Symptom>>();

  @observable
  var mapSymptomsOverviewDay = new ObservableMap<MealTime, List<Symptom>>();

  @observable
  var overviewSymptomList = new ObservableList<Symptom>();

  @observable
  var totalOccurrenceSymptom = new ObservableMap<String, int>();

  @observable
  Map<String,int> sortedTotalOccurrenceSymptom = new Map<String,int>();

  @observable
  var dayOccurrenceSymptom = new SortedMap<String, int>();

  @observable
  var mapIngredientsOverviewPeriod = new ObservableMap<DateTime,List<Ingredient>>();

  @observable
  var mapIngredientsOverviewDay = new ObservableMap<MealTime,List<Ingredient>>();

  @observable
  var overviewDishList = new ObservableList<Dish>();

  @observable
  var overviewIngredientList = new ObservableList<Ingredient>();

  @observable
  var totalOccurrenceIngredient = new ObservableMap<String, int>();

  @observable
  Map<String,int> sortedTotalOccurrenceIngredient = new Map<String,int>();

  @observable
  var dayOccurrenceIngredientBySymptom = new ObservableMap<String, int>();

  @observable
  var totalOccurrenceIngredientBySymptom = new ObservableMap<String, int>();


  @observable
  ObservableFuture loadInitSymptomGraph;

  @observable
  ObservableFuture loadInitIngredientGraph;

  @action
  Future<void> initStore(DateTime day) async {
    if (!storeInitialized) {
      storeInitialized = true;
    }
  }

@action
Ingredient initIngredientMapSymptomsValue(String ingredientId,List<DateTime> dates,SymptomStore symptomStore){
  Ingredient toReturn = new Ingredient();
  toReturn.id=ingredientId;
    symptomStore.symptomList.forEach((symptom) {
      toReturn.ingredientMapSymptomsValue.putIfAbsent(symptom.id, () => 0);
    });

dates.forEach((day) {
  mapSymptomsOverviewPeriod[day].forEach((symptom) {
    bool found = false;
    mapIngredientsOverviewPeriod[day].forEach((ingredient) {
      found= false;
      if(ingredient.id==ingredientId){
        if(symptom.mealTime.contains(ingredient.mealTime)){
          found=true;
          toReturn.ingredientMapSymptomsValue[symptom.id] = toReturn.ingredientMapSymptomsValue[symptom.id]+1;
        }

      }

    });

  });
});
return toReturn;
}

@action
void initIngredientMapSymptomsValue2 (List<DateTime> dates,Ingredient ingredient,SymptomStore symptomStore){
  dates.forEach((day) {
    mapIngredientsOverviewPeriod[day].forEach((ingr) {
    if(ingr.id==ingredient.id){
      symptomStore.symptomList.forEach((sym) {
        int count=0;
        mapSymptomsOverviewPeriod[day].forEach((element) {
          if(element.id!=sym.id){
            count = count+1;
          }
        });
        //il sintomo non è presente proprio in questo giorno quindi gli tolgo -0.25
        if(count==mapSymptomsOverviewPeriod[day].length){
          ingredient.ingredientMapSymptomsValue[sym.id] = ingredient.ingredientMapSymptomsValue[sym.id]-0.25;
        }else{
          if(!mapSymptomsOverviewPeriod[day].firstWhere((element) => sym.id==element.id).mealTime.contains(ingr.mealTime)){
            ingredient.ingredientMapSymptomsValue[sym.id] = ingredient.ingredientMapSymptomsValue[sym.id]-0.25;
          }
        }
      });

    };
    });
  });}

  @action
  void initIngredientMapSymptomsValue3 (List<DateTime> dates,Ingredient ingredient,SymptomStore symptomStore){
    dates.forEach((day) {
      mapSymptomsOverviewPeriod[day].forEach((symptom) {
        int count = 0;
        bool found = false;
        symptom.mealTime.forEach((element) {
          found=false;
        mapIngredientsOverviewPeriod[day].forEach((ingr){

            if(ingredient.id==ingr.id && !found && element==ingr.mealTime){
              count = count+1;
              found = true;      //numero di volte che sono stato male e ho mangiato in quel mealtime il cibo X
            }
          });

        });
        ingredient.ingredientMapSymptomsValue[symptom.id] = ingredient.ingredientMapSymptomsValue[symptom.id]-0.5*(symptom.mealTime.length-count);
      });
    });
  }

  @action
  Future<void> initializeSymptomsMap(DateStore dateStore) async {
    initializeIngredientMap(dateStore);
    mapSymptomsOverviewDay.clear();
    mapSymptomsOverviewPeriod.clear();
    totalOccurrenceSymptom.clear();
    overviewSymptomList.clear();
    switch(timeSelected.index){
      case 0: loadInitSymptomGraph =  ObservableFuture(getSymptomsOfADay(dateStore.overviewDefaultLastDate)
          .then((value) => setMealTimeSymptomMap())
          .then((value) => totalOccurrenceSymptomsDay())); break;
      case 1:loadInitSymptomGraph =  ObservableFuture(Future.wait(dateStore.rangeDays.map(getSymptomSingleDayOfAPeriod))
            .then((value) =>  totalOccurrenceSymptomsPeriod()));
        break;
      case 2: loadInitSymptomGraph =  ObservableFuture(Future.wait(dateStore.rangeDays.map(getSymptomSingleDayOfAPeriod))
          .then((value) =>  totalOccurrenceSymptomsPeriod()));
      break;
      case 3: loadInitSymptomGraph =  ObservableFuture(Future.wait(dateStore.rangeDays.map(getSymptomSingleDayOfAPeriod))
          .then((value) =>  totalOccurrenceSymptomsPeriod()));
      break;
    }

  }

  @action
  Future<void> initializeIngredientMap(DateStore dateStore) async {
    mapIngredientsOverviewDay.clear();
    mapIngredientsOverviewPeriod.clear();
    overviewIngredientList.clear();
    totalOccurrenceIngredient.clear();
    overviewDishList.clear();
    switch(timeSelected.index){
      case 0: loadInitIngredientGraph =  ObservableFuture(asyncGetDish(dateStore.overviewDefaultLastDate));
      break;
      case 1: loadInitIngredientGraph =  ObservableFuture(initializePeriodIngredientAsync(dateStore));
      break;
      case 2: loadInitIngredientGraph =  ObservableFuture(initializePeriodIngredientAsync(dateStore));
      break;
      case 3: loadInitIngredientGraph =  ObservableFuture(initializePeriodIngredientAsync(dateStore));
      break;
    }

  }

  Future<void>initializePeriodIngredientAsync(DateStore dateStore) async {
    await  Future.forEach(dateStore.rangeDays, (day) async
    {await asyncGetDish(day);}).then((value) => totalOccurrenceIngredientsPeriod());
  }

  Future<void>asyncGetDish(DateTime day) async {
    await Future.wait(MealTime.values.map((e) => getDishMealTime(e, day)))
        .then((value) => asyncGetIngredient(day));
  }

  Future<void>asyncGetIngredient(DateTime day) async
  {
    await Future.wait(overviewDishList.map(getIngredientOfADish)).then((value) => asyncMapIngredient(day));
  }

  Future<void>asyncMapIngredient(DateTime day)async{
    if(timeSelected==TemporalTime.Day){
      List<Ingredient> mealTimeList = new List<Ingredient>();
      MealTime.values.forEach((mealTime) {
        overviewIngredientList.forEach((ingredient) {
          if(ingredient.mealTime.contains(mealTime.toString().split('.').last)){
            mealTimeList.add(ingredient);
          }
        });
        mapIngredientsOverviewDay.putIfAbsent(mealTime, () => mealTimeList.toList());
        mealTimeList.clear();
      });
      totalOccurrenceIngredientsDay();

      overviewDishList.clear();
      overviewIngredientList.clear();
    }else{
      mapIngredientsOverviewPeriod.update(day, (value) => overviewIngredientList.toList(), ifAbsent: ()=> overviewIngredientList.toList());
      overviewDishList.clear();
      overviewIngredientList.clear();
    }

  }


  @action
  int totalNumOfSymptomList(){
    int count = 0;
    if(timeSelected==TemporalTime.Day){
      mapSymptomsOverviewDay.values.forEach((symptomsList) {
        count = count + symptomsList.length;
      });
    }else{
      mapSymptomsOverviewPeriod.values.forEach((symptomsList) {
        count = count + symptomsList.length;
      });
    }


    return count;
  }

  @action
  int totalNumOfIngredientList(){
    int count = 0;
    if(timeSelected==TemporalTime.Day){
      mapIngredientsOverviewDay.values.forEach((ingredientList) {
        count = count + ingredientList.length;
      });
    }else
    mapIngredientsOverviewPeriod.values.forEach((ingredientList) {
      count = count + ingredientList.length;
    });
    return count;
  }

  @action
  void totalOccurrenceSymptomsDay(){
    mapSymptomsOverviewDay.values.forEach((symptomsList) {
      symptomsList.forEach((symptom) {
        if(!totalOccurrenceSymptom.keys.contains(symptom.id)){
          totalOccurrenceSymptom.putIfAbsent(symptom.id, () => 1);
        }else{
          totalOccurrenceSymptom.update(symptom.id, (value) => value+1);
        }
      });
    });
  }

  @action
  void totalOccurrenceSymptomsPeriod(){
    mapSymptomsOverviewPeriod.values.forEach((symptomsList) {
      symptomsList.forEach((symptom) {
        if(!totalOccurrenceSymptom.keys.contains(symptom.id)){
          totalOccurrenceSymptom.putIfAbsent(symptom.id, () => 1);
      }else{
          totalOccurrenceSymptom.update(symptom.id, (value) => value+1);
        }
      });
    });
  }

  @action
  void totalOccurrenceIngredientsPeriod(){
    mapIngredientsOverviewPeriod.values.forEach((ingredientList) {
      ingredientList.forEach((ingredient) {
        if(!totalOccurrenceIngredient.keys.contains(ingredient.id)){
          totalOccurrenceIngredient.putIfAbsent(ingredient.id, () => 1);
        }else{
          totalOccurrenceIngredient.update(ingredient.id, (value) => value+1);
        }
      });
    });
  }

  @action
  void totalOccurrenceIngredientsDay(){
    mapIngredientsOverviewDay.values.forEach((ingredientList) {
      ingredientList.forEach((ingredient) {
        if(!totalOccurrenceIngredient.keys.contains(ingredient.id)){
          totalOccurrenceIngredient.putIfAbsent(ingredient.id, () => 1);
        }else{
          totalOccurrenceIngredient.update(ingredient.id, (value) => value+1);
        }
      });
    });
  }

  @action
  void getTotalIngredientBySymptomOfAPeriod(String symptomId){
    totalOccurrenceIngredientBySymptom.clear();
    mapSymptomsOverviewPeriod.keys.forEach((dateTime) {
      Symptom currentSymptom = mapSymptomsOverviewPeriod[dateTime].firstWhere((element) => element.name!=null && element.id == symptomId,orElse: () => null);
      if (currentSymptom!=null) {
        if (mapIngredientsOverviewPeriod.containsKey(dateTime) && mapIngredientsOverviewPeriod[dateTime].isNotEmpty) {
          mapIngredientsOverviewPeriod[dateTime].forEach((ingredient) {
            if (currentSymptom.mealTime.contains(ingredient.mealTime)) {
              print(ingredient.mealTime);
              if (!totalOccurrenceIngredientBySymptom.keys.contains(
                  ingredient.id)) {
                totalOccurrenceIngredientBySymptom.putIfAbsent(
                    ingredient.id, () => 1);
              } else {
                totalOccurrenceIngredientBySymptom.update(
                    ingredient.id, (value) => value + 1);
              }
            }
          });
        }
      }
    });

  }

  @action
  void getTotalIngredientBySymptomOfADay(String symptomId){
    totalOccurrenceIngredientBySymptom.clear();
    mapSymptomsOverviewDay.keys.forEach((mealTime) {
      Symptom currentSymptom = mapSymptomsOverviewDay[mealTime].firstWhere((element) => element.name!=null && element.id == symptomId,orElse: () => null);
      if (currentSymptom!=null) {
        if (mapIngredientsOverviewDay.containsKey(mealTime) && mapIngredientsOverviewDay[mealTime].isNotEmpty) {
          mapIngredientsOverviewDay[mealTime].forEach((ingredient) {
            if (!totalOccurrenceIngredientBySymptom.keys.contains(
                ingredient.id)) {
              totalOccurrenceIngredientBySymptom.putIfAbsent(
                  ingredient.id, () => 1);
            } else {
              totalOccurrenceIngredientBySymptom.update(
                  ingredient.id, (value) => value + 1);
            }
          }
          );
        }
      }
    });
  }

  @action
  void getIngredientBySymptomDayOfAPeriod(DateTime dateTime, String symptomId) {
    dayOccurrenceIngredientBySymptom.clear();
    Symptom currentSymptom = mapSymptomsOverviewPeriod[dateTime].firstWhere((element) => element.name!=null && element.id == symptomId,orElse: () => null);
    if (currentSymptom!=null) {

      if(mapIngredientsOverviewPeriod.containsKey(dateTime) && mapIngredientsOverviewPeriod[dateTime].isNotEmpty) {
        mapIngredientsOverviewPeriod[dateTime].forEach((ingredient) {
          if (currentSymptom.mealTime.contains(ingredient.mealTime)) {
            
            if (!dayOccurrenceIngredientBySymptom.keys
                .contains(ingredient.id)) {
              dayOccurrenceIngredientBySymptom.putIfAbsent(
                  ingredient.id, () => 1);
            } else {
              dayOccurrenceIngredientBySymptom.update(
                  ingredient.id, (value) => value + 1);
            }
          }
        });
      }
    }
  }

  @action
  void getIngredientBySymptomMealTimeOfADay(MealTime mealTime, String symptomId) {
    dayOccurrenceIngredientBySymptom.clear();
    if (mapSymptomsOverviewDay[mealTime].firstWhere((element) => element.name!=null && element.id == symptomId, orElse: () => null)!=null) {
      if(mapIngredientsOverviewDay.containsKey(mealTime) && mapIngredientsOverviewDay[mealTime].isNotEmpty) {
        mapIngredientsOverviewDay[mealTime].forEach((ingredient) {
          if (!dayOccurrenceIngredientBySymptom.keys.contains(ingredient.id)) {
            dayOccurrenceIngredientBySymptom.putIfAbsent(
                ingredient.id, () => 1);
          } else {
            dayOccurrenceIngredientBySymptom.update(
                ingredient.id, (value) => value + 1);
          }
        });
      }
    }
  }

  @action
  Future<void> getSymptomsOfADay(DateTime date) async {
    await (FirebaseFirestore.instance
        .collection('UserSymptoms')
        .doc(auth.currentUser.uid).collection("DaySymptoms").doc(fixDate(date))
        .collection("Symptoms")
        .get()
        .then((querySnapshot) {
      overviewSymptomList.clear();
      querySnapshot.docs.forEach((symptom) {
        Symptom toAdd = new Symptom(id:symptom.id, name: symptom.get("name"));
        toAdd.initStore();
        toAdd.setIsSymptomInADay(true);
        toAdd.setIntensity(symptom.get("intensity"));
        toAdd.setFrequency(symptom.get("frequency"));
        toAdd.setMealTime(symptom.get("mealTime"));
        toAdd.setMealTimeBoolList();
        //lista dei sintomi di un giorno specifico
        overviewSymptomList.add(toAdd);
      }
      );
    })
    );
  }

  @action
  void setMealTimeSymptomMap(){
    List<Symptom> mealTimeList = new List<Symptom>();
    MealTime.values.forEach((mealTime) {
      overviewSymptomList.forEach((symptom) { 
        if(symptom.mealTime.contains(mealTime.toString().split('.').last)){
          mealTimeList.add(symptom);
        }
      });
      mapSymptomsOverviewDay.putIfAbsent(mealTime, () => mealTimeList.toList());
      mealTimeList.clear();
    });
  }

  @action
  Future<void> getSymptomSingleDayOfAPeriod(DateTime dateTime) async {
      await getSymptomsOfADay(dateTime)
          .then((value) =>
           {
             mapSymptomsOverviewPeriod.update(dateTime, (value) => overviewSymptomList.toList(), ifAbsent: ()=> overviewSymptomList.toList())});
  }

  int getIndexFromSymptomsList(Symptom symptom,List<Symptom> symptoms){
    return symptoms.indexOf(symptom,0);
  }

  @action
  Future<dynamic> getDishMealTime(MealTime mealTime, DateTime dateTime) async {
    await (FirebaseFirestore.instance
        .collection('UserDishes')
        .doc(auth.currentUser.uid)
        .collection("DayDishes")
        .doc(fixDate(dateTime))
        .collection(mealTime.toString().toString().split('.').last)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((dish) {
        Dish toAdd = new Dish(
          id: dish.id,
          qty: dish.get("qty"),
          mealTime: mealTime.toString().toString().split('.').last,
        );
        overviewDishList.add(toAdd);
      }
      );
    }));
  }

  @action
  double mealTimeValueSymptom(Symptom symptom){
    double value;
    int count=0;
    symptom.mealTimeBoolList.forEach((element) {
      if(element.isSelected==true){
        count=count+1;
      }
    });
    if(count==0){
      value = 0;
    }
    if(count==1){
      value = 0.6;
    }
    if(count==2){
      value = 0.8;
    }
    if(count==3){
      value = 0.95;
    }
    if(count==4){
      value = 1.0;
    }
    return value;
  }

  @action
  void initializeOverviewValueDay(String symptomId){
    MealTime.values.forEach((mealTime) {
      if( mapSymptomsOverviewDay[mealTime].any((element) => element.id==symptomId)){
        Symptom toUpdate = mapSymptomsOverviewDay[mealTime].firstWhere((element) => element.id==symptomId);
        toUpdate.overviewValue = ((toUpdate.intensity)*(toUpdate.frequency)*mealTimeValueSymptom(toUpdate))*0.4;
        toUpdate.overviewValue = toUpdate.overviewValue.roundToDouble();
      }
    });
  }

  @action
  void initializeOverviewValuePeriod(DateTime dateTime, String symptomId){

    if( mapSymptomsOverviewPeriod[dateTime].any((element) => element.id==symptomId)){
      Symptom toUpdate = mapSymptomsOverviewPeriod[dateTime].firstWhere((element) => element.id==symptomId);
      toUpdate.overviewValue = ((toUpdate.intensity*1.25)*(toUpdate.frequency*0.75)*mealTimeValueSymptom(toUpdate))*0.4;
      toUpdate.overviewValue = toUpdate.overviewValue.roundToDouble();
    }
  }


  @action
  Future<void> getIngredientOfADish(Dish dish) async {
    if(isSubstring("User", dish.id,)){
      await (FirebaseFirestore.instance
          .collection("DishesCreatedByUsers")
          .doc(auth.currentUser.uid)
          .collection("Dishes").doc(dish.id).collection("Ingredients")
          .get().then((querySnapshot) {
        querySnapshot.docs.forEach((ingredient) {
          int totalQty= 0;
              //ingredient.get("qty")*dish.qty; //TODO CONVERTIRE STRINGHE AD INTERI CON GLI ENUM
          Ingredient i = new Ingredient(id:ingredient.id,name:ingredient.get("name"),qty:ingredient.get("qty"), mealTime: dish.mealTime, totalQuantity: totalQty );
          overviewIngredientList.add(i);
        }
        );
      }));
    }
    else{
      await (FirebaseFirestore.instance
          .collection('Dishes').doc(dish.id).collection("Ingredients")
          .get().then((querySnapshot) {
        querySnapshot.docs.forEach((ingredient) {
          int totalQty= 0;
              //ingredient.get("qty")*dish.qty; //TODO CONVERTIRE STRINGHE AD INTERI CON GLI ENUM
          Ingredient i = new Ingredient(id:ingredient.id,name:ingredient.get("name"),qty:ingredient.get("qty"), mealTime: dish.mealTime, totalQuantity: totalQty);
          overviewIngredientList.add(i);
        }
        );
      }));
    }
  }

  Map<String,int> sortTotalOccurrenceIngredientBySymptom(){
    SplayTreeMap<String,int> sortedMap = SplayTreeMap<String,int>
        .from(totalOccurrenceIngredientBySymptom, (b, a) => totalOccurrenceIngredientBySymptom[a] > totalOccurrenceIngredientBySymptom[b] ? 1 : -1 );
    Map<String,int> returnMap = Map.from(sortedMap);
    return returnMap;
  }

  Map<String,int> sortDayOccurrenceIngredientBySymptom(){
    SplayTreeMap<String,int> sortedMap = SplayTreeMap<String,int>
        .from(dayOccurrenceIngredientBySymptom, (b, a) => dayOccurrenceIngredientBySymptom[a] > dayOccurrenceIngredientBySymptom[b] ? 1 : -1 );
    Map<String,int> returnMap = Map.from(sortedMap);
    return returnMap;
  }

  void sortSymptomByOccurrence(){
    SplayTreeMap<String,int> sortedMap = SplayTreeMap<String,int>
        .from(totalOccurrenceSymptom, (b, a) => totalOccurrenceSymptom[a] > totalOccurrenceSymptom[b] ? 1 : -1 );
    sortedTotalOccurrenceSymptom = Map.from(sortedMap);
    print(sortedTotalOccurrenceSymptom);
  }

  void sortIngredientByOccurrence(){
    SplayTreeMap<String,int> sortedMap = SplayTreeMap<String,int>
        .from(totalOccurrenceIngredient, (b, a) => totalOccurrenceIngredient[a] > totalOccurrenceIngredient[b] ? 1 : -1 );
    sortedTotalOccurrenceIngredient = Map.from(sortedMap);
    print(sortedTotalOccurrenceIngredient);
  }

  String fixDate(DateTime date) {
    String dateSlug = "${date.year.toString()}-${date.month.toString().padLeft(
        2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return dateSlug;
  }


  bool isSubstring(String s1, String s2) {
    int M = s1.length;
    int N = s2.length;

/* A loop to slide pat[] one by one */
    for (int i = 0; i <= N - M; i++) {
      int j;

/* For current index i, check for
 pattern match */
      for (j = 0; j < M; j++)
        if (s2[i + j] != s1[j])
          break;

      if (j == M)
        return true; // il piatto è stato creato dall'utente
    }

    return false; //il piatto non è stato creato dall'utente

  }
}
