import 'package:flutter/material.dart';
import 'Database/Dish.dart';
import 'Models/foodStore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'createNewDishWidget.dart';
import 'package:Bealthy_app/dishPageAddToDay.dart';
import 'package:Bealthy_app/searchDishesList.dart';


class AddMeal extends StatefulWidget {
  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add meal"),
          bottom: PreferredSize(
            preferredSize: Size(50,50),
            child: Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => searchDishesList()),
                  )
                },
                icon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        body: Center(
            child: Column(
                children: [
                  FlatButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavouriteDishes()),
                      )
                    },
                    color: Colors.orange,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.add),
                        Text("Favourites")
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CategoriesDish()),
                      )
                    },
                    color: Colors.orange,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.add),
                        Text("Category")
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => YourDishList()),
                      )
                    },
                    color: Colors.orange,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.add),
                        Text("Your Dish")
                      ],
                    ),
                  ),
                ]
            )
        )
    );
  }
}


class FavouriteDishes extends StatefulWidget {
  @override
  _FavouriteDishesState createState() => _FavouriteDishesState();

}

class _FavouriteDishesState extends State<FavouriteDishes>{
  @override
  void initState() {
    super.initState();
    var store = Provider.of<FoodStore>(context, listen: false);
    store.initStore();
  }

  @override
  Widget build(BuildContext context) {
    final foodStore = Provider.of<FoodStore>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Favourites"),
        ),
        body: Center(
            child:   Observer(
                builder: (_) => Column(
                    children: [
                      for(Dish dish in foodStore.yourFavouriteDishList ) FlatButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DishPageAddToDay(dish: dish,
                        createdByUser: foodStore.isSubstring("User", dish.id,)),
                          ))
                        },
                        color: Colors.orange,
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.fastfood),
                            Text(dish.name.toString())
                          ],
                        ),
                      ),
                    ]
                )
        )
    )
    );
  }
}


class CategoriesDish extends StatefulWidget {
  @override
  _CategoriesDishState createState() => _CategoriesDishState();
}

class _CategoriesDishState extends State<CategoriesDish>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Category"),
        ),
        body: Center(
            child: Column(
                children: [
                  for(var item in Category.values ) FlatButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CategoryDishList(category: item)),
                      )
                    },
                    color: Colors.orange,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.fastfood),
                        Text(item.toString().split('.').last)
                      ],
                    ),
                  ),
                ]
            )
        )
    );
  }

}


class CategoryDishList extends StatefulWidget {
  final Category category;

  // In the constructor, require a Category.
  CategoryDishList({@required this.category});

  @override
  _CategoryDishListState createState() => _CategoryDishListState();
}

class _CategoryDishListState extends State<CategoryDishList> {
  
  void initState() {
    super.initState();
    var store = Provider.of<FoodStore>(context, listen: false);
    store.initFoodCategoryLists(widget.category.index);
  }
  
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FoodStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category
            .toString()
            .split('.')
            .last),
      ),
        body: Center(
            child:   Observer(
                builder: (_) => Column(
                    children: [
                      for(Dish item in store.getCategoryList(widget.category.index) ) FlatButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DishPageAddToDay(dish: item, createdByUser: false,canBeAddToADay: true)),
                          )
                        },
                        color: Colors.orange,
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.fastfood),
                            Text(item.name.toString())
                          ],
                        ),
                      ),
                    ]
                )
            )
        )
    );
  }
}

class YourDishList extends StatefulWidget {
  @override
  _YourDishListState createState() => _YourDishListState();



}

class _YourDishListState extends State<YourDishList> {

  @override
  void initState() {
    super.initState();
    var store = Provider.of<FoodStore>(context, listen: false);

    store.initStore();

  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FoodStore>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Your Dish"),
        ),
        body: ListView(children:[
          Observer(
                builder: (_) =>
                    Column(
                        children: [
                          for(Dish item in store.yourCreatedDishList) FlatButton(
                            onPressed: () =>
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    DishPageAddToDay(dish: item, createdByUser: true, canBeAddToADay: true),
                                )
                              )
                            },
                            color: Colors.orange,
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.fastfood),
                                Text(item.name.toString())
                              ],
                            ),
                          ),
                        ]
                    )

            )],),
        floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddDishForm()),
                );
                // Validate returns true if the form is valid, or false
                // otherwise.
              },
          child: Icon(Icons.add),
            ),

    );
  }
}

