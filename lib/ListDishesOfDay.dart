import 'package:flutter/material.dart';
import 'Models/foodStore.dart';
import 'package:provider/provider.dart';



import 'package:flutter_mobx/flutter_mobx.dart';


class ListDishesOfDay extends StatefulWidget {

  final String day;
  ListDishesOfDay({@required this.day});


  @override
  _ListDishesOfDayState createState() => _ListDishesOfDayState();
}

class _ListDishesOfDayState extends State<ListDishesOfDay>{

  List<String> dishesOfDay = new List<String>();

  @override
  void initState() {

    super.initState();
    var store = Provider.of<FoodStore>(context, listen: false);
    store.initStore();
  }

  @override
  Widget build(BuildContext context) {
    final foodStore = Provider.of<FoodStore>(context);
    return Observer(builder: (_) => new Expanded(
        child:
        new ListView.builder
          (
            itemCount: foodStore.yourDishesDayList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Text(foodStore.yourDishesDayList[index].name,style: TextStyle(fontSize: 22.0)),
                  subtitle: Text(foodStore.yourDishesDayList[index].category,style: TextStyle(fontSize: 18.0)),
                  leading: FlutterLogo(),
                  trailing: Icon(Icons.more_vert),
                ),
              );
            }
        ),


      ),);


  }
}