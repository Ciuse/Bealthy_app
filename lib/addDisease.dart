import 'package:flutter/material.dart';
import 'Database/Dish.dart';
import 'Models/foodStore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:Bealthy_app/dishPageAddToDay.dart';
class AddDisease extends StatefulWidget {
  @override
  __AddDiseaseState createState() => __AddDiseaseState();
}

class __AddDiseaseState extends State<AddDisease>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Disease"),
        ),
        body: Center(
            child: Column(
                children: [
                  FlatButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavouriteDisease()),
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
                        MaterialPageRoute(builder: (context) => CategoriesDisease()),
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
                ]
            )
        )
    );
  }
}


class FavouriteDisease extends StatefulWidget {
  @override
  _FavouriteDiseaseState createState() => _FavouriteDiseaseState();

}

class _FavouriteDiseaseState extends State<FavouriteDisease>{
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
          title: Text("Favourites"),
        ),
        body: Center(
            child:   Observer(
                builder: (_) => Column(
                    children: [
                      for(Dish item in store.yourFavouriteDishList ) FlatButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DishPageAddToDay(dish: item,)),
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


class CategoriesDisease extends StatefulWidget {
  @override
  _CategoriesDiseaseState createState() => _CategoriesDiseaseState();
}

class _CategoriesDiseaseState extends State<CategoriesDisease>{

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
                            MaterialPageRoute(builder: (context) => DishPageAddToDay(dish: item,)),
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

