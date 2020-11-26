import 'package:flutter/material.dart';
import 'Database/Dish.dart';
import 'Models/foodStore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'createNewDishWidget.dart';
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

  List<Dish> favouriteDishes(){
   return context.read<FoodStore>().getFavouritesDishes();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Favourites"),
        ),
        body: Center(
            child:   Observer(
                builder: (_) => Column(
                    children: [
                      for(Dish item in  favouriteDishes() ) FlatButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DishPage(dish: item,)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category
            .toString()
            .split('.')
            .last),
      ),
    );
  }
}

class YourDishList extends StatefulWidget {
  @override
  _YourDishListState createState() => _YourDishListState();
}

class _YourDishListState extends State<YourDishList> {


  List<Dish> yourDishes() {
    return context.read<FoodStore>().getYourDishes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Dish"),
        ),
        body: Column(children:[
          Observer(
                builder: (_) =>
                    Column(
                        children: [
                          for(Dish item in yourDishes() ) FlatButton(
                            onPressed: () =>
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    DishPage(dish: item,)),
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


class DishPage extends StatefulWidget {
  final Dish dish;

  // In the constructor, require a Category.
  DishPage({@required this.dish});

  @override
  _DishPageState createState() => _DishPageState();
}

class _DishPageState extends State<DishPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(widget.dish.name),
    ),
    );
  }
}