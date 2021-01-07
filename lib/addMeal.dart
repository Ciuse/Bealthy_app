import 'package:Bealthy_app/dishPage.dart';
import 'package:Bealthy_app/searchDishesList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'Database/dish.dart';
import 'Database/enumerators.dart';
import 'Login/config/palette.dart';
import 'Models/foodStore.dart';
import 'createNewDish.dart';


class AddMeal extends StatefulWidget {
  final String title;
  AddMeal({@required this.title});
  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add new dish to"+" "+widget.title),
        ),
        body: Container(
          color: Palette.tealThreeMoreLight,
            child: Column(
                children: [
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchDishesList()),
                      )
                    },
                    child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10,right: 10 ),
                        margin: EdgeInsets.only(top: 15, left: 10,right: 10 ),
                        height: 60,
                        width:double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30), //border corner radius
                          boxShadow:[
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6), //color of shadow
                              spreadRadius: 4, //spread radius
                              blurRadius: 6, // blur radius
                              offset: Offset(0, 4), // changes position of shadow
                              //first paramerter of offset is left-right
                              //second parameter is top to down
                            ),
                            //you can set more BoxShadow() here
                          ],
                        ),
                        child: Row(children:[ Icon(Icons.search, size: 35, color: Colors.black,),
                          SizedBox(width: 10,),
                          Text("Search dish to add")
                        ]
                        )
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10,right: 10 ),
                      margin: EdgeInsets.only(top: 35, left: 10,right: 10 ),
                      width:double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10), //border corner radius
                        boxShadow:[
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6), //color of shadow
                            spreadRadius: 4, //spread radius
                            blurRadius: 6, // blur radius
                            offset: Offset(0, 4), // changes position of shadow
                            //first paramerter of offset is left-right
                            //second parameter is top to down
                          ),
                          //you can set more BoxShadow() here
                        ],
                      ),
                      child: Column(children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(right: 10, top: 15),
                          child:
                          Row(
                              children: <Widget>[
                                RawMaterialButton(
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => FavouriteDishes()))
                                  },
                                  elevation: 7.0,
                                  fillColor: Colors.white,
                                  child: Icon(
                                    Icons.favorite_border,
                                    size: 24.0,
                                    color: Colors.black,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                                SizedBox(width: 10,),
                                Text("Favourites")
                              ],
                            ),
                          ),
                        Divider(
                          thickness: 0.5,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.black,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(right: 10, top: 15),
                          child:
                          Row(
                            children: <Widget>[
                              RawMaterialButton(
                                onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CategoriesDish()))
                                },
                                elevation: 7.0,
                                fillColor: Colors.white,
                                child: Icon(
                                  Icons.category_outlined,
                                  size: 24.0,
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                              SizedBox(width: 10,),
                              Text("Category")
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.black,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(right: 10, top: 15),
                          child:
                          Row(
                            children: <Widget>[
                              RawMaterialButton(
                                onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => YourDishList()))
                                },
                                elevation: 7.0,
                                fillColor: Colors.white,
                                child: Icon(
                                  Icons.handyman_rounded,
                                  size: 24.0,
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                              SizedBox(width: 10,),
                              Text("Your Dish")
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.black,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(right: 10, top: 15,bottom:15),
                          child:
                          Row(
                            children: <Widget>[
                              RawMaterialButton(
                                onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CreateNewDish()))
                                },
                                elevation: 7.0,
                                fillColor: Colors.white,
                                child: Icon(
                                  Icons.create_outlined,
                                  size: 24.0,
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                              SizedBox(width: 10,),
                              Text("Create New Dish")
                            ],
                          ),
                        ),]
                      )
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
                            MaterialPageRoute(builder: (context) => DishPage(dish: dish,
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
                            MaterialPageRoute(builder: (context) => DishPage(dish: item, createdByUser: false,)),
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
                                    DishPage(dish: item, createdByUser: true),
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

    );
  }
}

