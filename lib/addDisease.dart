import 'package:Bealthy_app/Database/Disease.dart';
import 'package:Bealthy_app/Models/diseaseStore.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
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
  void initState() {
    super.initState();
    var store = Provider.of<DiseaseStore>(context, listen: false);
    store.initStore();
  }


  @override
  Widget build(BuildContext context) {
    final diseaseStore = Provider.of<DiseaseStore>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Add Disease"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildRowList(diseaseStore.diseaseList)
            )
        )
    );
  }
}
List<Widget> _buildRowList(ObservableList diseaseList) {
  int i =0;
  List<Widget> lines = []; // this will hold Rows according to available lines.
  List<Widget> elementOfLine = []; // this will hold the places for each line

  for (Disease disease in diseaseList) {
    if(i%3==0 && i!=0){
      lines.add(
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:elementOfLine
          ));
      elementOfLine =[];
    }

    elementOfLine.add(Icon(
      Icons.favorite,
      color: Colors.pink,
      size: 50.0,
      semanticLabel: 'Text to announce in accessibility modes',
    ),);
    i++;

  }
  if(i%3!=0){
    for (int j=0; j<3-(i%3); j++) {
      elementOfLine.add(Icon(
        Icons.add,
        color: Colors.pink,
        size: 50.0,
        semanticLabel: 'Text to announce in accessibility modes',
      ),);
    }
  }
  lines.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly   ,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:elementOfLine));

  return lines;
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

