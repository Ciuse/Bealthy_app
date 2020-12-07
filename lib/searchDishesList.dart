import 'package:Bealthy_app/Database/Disease.dart';
import 'package:Bealthy_app/Models/diseaseStore.dart';
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
    store.initDishStore();
        
  }


  @override
  void dispose(){
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  _onSearchChanged(){
    print(_searchController.text);
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
                                itemCount: foodStore.dishesListFromDBAndUser.length,
                                itemBuilder: (context, index) {
                                  return Text(foodStore.dishesListFromDBAndUser[index].name);
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
