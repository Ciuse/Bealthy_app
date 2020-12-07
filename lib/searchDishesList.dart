import 'package:Bealthy_app/Database/Symptom.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:Bealthy_app/Models/ingredientStore.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'Database/Dish.dart';
import 'Models/foodStore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:Bealthy_app/dishPageAddToDay.dart';


class searchDishesList extends StatefulWidget {
  @override
  _searchDishesListState createState() => _searchDishesListState();
}

class _searchDishesListState extends State<searchDishesList>{


  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    var store = Provider.of<FoodStore>(context, listen: false);
    store.initDishList();
    store.resultsList.clear();
    _onSearchChanged();
  }


  @override
  void dispose(){
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  _onSearchChanged(){
    searchResultList();
    print(_searchController.text);
  }
  void searchResultList() {

    var showResults = [];
    var store = Provider.of<FoodStore>(context, listen: false);

    if(_searchController.text != ""){

      for(Dish dish in store.dishesListFromDBAndUser){
        var name = dish.name.toLowerCase();
        if(name.contains(_searchController.text.toLowerCase())){
          showResults.add(dish);
        }
      }

    }else{
      showResults.addAll(store.dishesListFromDBAndUser);
    }
    store.resultsList.clear();
    showResults.forEach((element) {
      store.resultsList.add(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    final foodStore = Provider.of<FoodStore>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Search Dish"),
        ),
        body: Container(
            child: Column(
              children: <Widget>[
                Text("search Dish to add",style: TextStyle(fontSize: 20)),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search)
                  ),
                ),
                Container(
                    child: Observer(
                      builder: (_) {
                        switch (foodStore.loadInitDishesList.status) {
                          case FutureStatus.rejected:
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Oops something went wrong'),
                                  RaisedButton(
                                    child: Text('Retry'),
                                    onPressed: () async {
                                      await foodStore.retryForDishesTotal();
                                    },
                                  ),
                                ],
                              ),
                            );
                          case FutureStatus.fulfilled:
                            return Expanded(child: ListView.builder(
                                itemCount: foodStore.resultsList.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                      onTap: ()=> { Navigator.push(
                                        context, MaterialPageRoute(builder: (context) =>
                                          DishPageAddToDay(dish: foodStore.resultsList[index],
                                              createdByUser: foodStore.isSubstring("User", foodStore.resultsList[index].id),canBeAddToADay:true)
                                      ),
                                      )
                                      },
                                      title: Text(foodStore.resultsList[index].name,style: TextStyle(fontSize: 22.0)),
                                      subtitle: Text(foodStore.resultsList[index].category,style: TextStyle(fontSize: 18.0)),
                                      leading: FlutterLogo(),
                                    ),
                                  );
                                }));
                          case FutureStatus.pending:
                          default:
                            return CircularProgressIndicator();
                        }
                      },
                    ))
              ],
            )
        )
    );
  }


}
