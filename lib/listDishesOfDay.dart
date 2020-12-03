import 'package:Bealthy_app/dishPageAddToDay.dart';
import 'package:flutter/material.dart';
import 'Models/foodStore.dart';
import 'package:provider/provider.dart';
import 'package:Bealthy_app/dishPageAddToDay.dart';


import 'package:flutter_mobx/flutter_mobx.dart';


class ListDishesOfDay extends StatefulWidget {

  final String day;
  ListDishesOfDay({@required this.day});


  @override
  _ListDishesOfDayState createState() => _ListDishesOfDayState();
}

class _ListDishesOfDayState extends State<ListDishesOfDay>{


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
            return Dismissible(
                key: Key(foodStore.yourDishesDayList[index].name),
                background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),

              child: Card(
                child: ListTile(
                  onTap: ()=> { Navigator.push(
                  context, MaterialPageRoute(builder: (context) =>
                      DishPageAddToDay(dish: foodStore.yourDishesDayList[index],))),},
                  title: Text(foodStore.yourDishesDayList[index].name,style: TextStyle(fontSize: 22.0)),
                  subtitle: Text(foodStore.yourDishesDayList[index].category,style: TextStyle(fontSize: 18.0)),
                  leading: FlutterLogo(),
                  trailing: Row (
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        PopupMenuButton<String>(
                          onSelected: (String choice) {

                            String prova = "User";
                            bool res = isSubstring(prova, foodStore.yourDishesDayList[index].id);
                            print(res);


                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DishPageAddToDay(dish: foodStore.yourDishesDayList[index], createdByUser: res)));

                            },
                            itemBuilder: (BuildContext context){
                              return ConstantsList.choices.map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),


                                      );
                                      }).toList();
                            },
                        ),
                        /*
                        IconButton(
                            icon: Icon(Icons.more_vert),
                            tooltip: "More info",
                            onPressed: ()=> Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DishPageAddToDay(dish: foodStore.yourDishesDayList[index])),
                            )),*/
                      ]),
                ),
              ),
              onDismissed: (direction){
                foodStore.removeDishFromUserDishesOfSpecificDay(foodStore.yourDishesDayList[index]);
              },
            );

          }
      ),


    ),);


  }
}

//check if s1 is a substring of s2
bool isSubstring(String s1, String s2)
{
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

  return false;//il piatto non è stato creato dall'utente
}



class ConstantsList  {

  static const String Informations = "informations";


  static const List<String> choices = <String>[
    Informations

  ];

}
