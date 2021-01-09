import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'Database/dish.dart';
import 'Models/foodStore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:Bealthy_app/dishPage.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';

class SearchDishesList extends StatefulWidget {
  @override
  _SearchDishesListState createState() => _SearchDishesListState();
}

class _SearchDishesListState extends State<SearchDishesList>{


  TextEditingController _searchController = TextEditingController();
  var storage = FirebaseStorage.instance;
  FoodStore foodStore;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    foodStore = Provider.of<FoodStore>(context, listen: false);
    foodStore.initSearchAllDishList();
    foodStore.resultsList.clear();
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
  }
  void searchResultList() {

    var showResults = [];

    if(_searchController.text != ""){

      for(Dish dish in foodStore.dishesListFromDBAndUser){
        var name = dish.name.toLowerCase();
        if(name.contains(_searchController.text.toLowerCase())){
          showResults.add(dish);
        }
      }

    }else{
      showResults.addAll(foodStore.dishesListFromDBAndUser);
    }
    foodStore.resultsList.clear();
    showResults.forEach((element) {
      foodStore.resultsList.add(element);
    });
  }

  Future getImage(String dishId) async {
    String userUid;
    final litUser = context.getSignedInUser();
    litUser.when(
          (user) => userUid=user.uid,
      empty: () => Text('Not signed in'),
      initializing: () => Text('Loading'),
    );
    try {
      return await storage.ref(userUid+"/DishImage/" + dishId + ".jpg").getDownloadURL();
    }
    catch (e) {
      return await Future.error(e);
    }
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
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.black,)
                  ),
                ),
                Container(
                    child: Observer(
                      builder: (_) {
                        switch (foodStore.loadInitSearchAllDishesList.status) {
                          case FutureStatus.rejected:
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Oops something went wrong'),
                                  RaisedButton(
                                    child: Text('Retry'),
                                    onPressed: () async {
                                      await foodStore.retrySearchAllDishesList();
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
                                          DishPage(dish: foodStore.resultsList[index],
                                              createdByUser: foodStore.isSubstring("User", foodStore.resultsList[index].id))
                                      ),
                                      )
                                      },
                                      title: Text(foodStore.resultsList[index].name,style: TextStyle(fontSize: 22.0)),
                                      subtitle: Text(foodStore.resultsList[index].category,style: TextStyle(fontSize: 18.0)),
                                      leading: foodStore.isSubstring("User", foodStore.resultsList[index].id)?
                                      FutureBuilder(
                                          future: getImage(foodStore.resultsList[index].id),
                                          builder: (context, remoteString) {
                                            if (remoteString.connectionState != ConnectionState.waiting) {
                                              if (remoteString.hasError) {
                                                return Text("Image not found");
                                              }
                                              else {
                                                return Observer(builder: (_) =>Container
                                                  (width: 45,
                                                    height: 45,
                                                    decoration: new BoxDecoration(
                                                      borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                                                      border: new Border.all(
                                                        color: Colors.black,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    child: ClipOval(
                                                        child: foodStore.resultsList[index].imageFile==null? Image.network(remoteString.data, fit: BoxFit.fill)
                                                            :Image.file(foodStore.resultsList[index].imageFile)
                                                    )));
                                              }
                                            }
                                            else {
                                              return CircularProgressIndicator();
                                            }
                                          }
                                      )
                                          :
                                      Container
                                        (width: 45,
                                          height: 45,
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                                            border: new Border.all(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                          ),
                                          child:  ClipOval(
                                              child: Image(
                                                image: AssetImage("images/Dishes/" +foodStore.resultsList[index].id+".png" ),
                                              )
                                          )),
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
