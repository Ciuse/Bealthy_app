
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'Database/Dish.dart';
import 'Models/foodStore.dart';
class DishPageAddToDay extends StatefulWidget {

  final Dish dish;
  final bool createdByUser;
  DishPageAddToDay({@required this.dish, @required this.createdByUser});

  @override
  _DishPageAddToDayState createState() => _DishPageAddToDayState();
}

class _DishPageAddToDayState extends State<DishPageAddToDay>{
  var storage = FirebaseStorage.instance;
  final FirebaseFirestore fb = FirebaseFirestore.instance;

  void initState() {
    super.initState();
    getImage();
  }


  Future getImage() async {

    try {
      
      return await storage.ref("DishImage/" + widget.dish.id + ".jpg").getDownloadURL();
    }

    catch (e) {
      return await Future.error(e);
    }
    
  }

  Future findIfLocal() {

     return rootBundle.load("images/"+widget.dish.id+".jpg");

  }

  @override
  Widget build(BuildContext context) {
    FoodStore foodStore = Provider.of<FoodStore>(context);
    foodStore.isFoodFavourite(widget.dish);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dish.name),
        actions: <Widget>[
          Observer(builder: (_) =>IconButton(
              icon: Icon(
                foodStore.isFavourite ? Icons.favorite : Icons.favorite_border,
                color: foodStore.isFavourite ? Colors.pinkAccent : null,

              ),
              onPressed: () {

                if (foodStore.isFavourite) {
                  foodStore.removeFavouriteDish(widget.dish);
                } else {
                  foodStore.addFavouriteDish(widget.dish);
                }

                // do something
              }
          ))
        ],
      ),
      body: Column(
    children: [Container(
          padding: EdgeInsets.all(10.0),
          child: FutureBuilder (
              future: findIfLocal(),
              builder: (context,  AsyncSnapshot localData) {
                if(localData.connectionState != ConnectionState.waiting ) {
                  if (localData.hasError) {
                    return FutureBuilder(
                        future: getImage(),
                        builder: (context, remoteString) {
                          if (remoteString.connectionState != ConnectionState.waiting) {
                            if (remoteString.hasError) {
                              return Text("Image not found");
                            }
                            else {
                              print("IMAGE NET");
                              return Container(
                                  width: 200,
                                  height: 200,
                                  child: ClipOval(
                                    child: Image.network(remoteString.data, fit: BoxFit.fill),
                                  ));

                            }
                          }
                          else {
                            return CircularProgressIndicator();
                          }
                        }
                    );
                  }
                  else {
                    return Container(
                        width: 200,
                        height: 200,
                        child:  ClipOval(
                            child: Image(
                              image: AssetImage("images/" + widget.dish.id + ".jpg"),
                            )
                        ));

                  }
                } else{

                  return CircularProgressIndicator();
                }
              }

          )
    ),
      Text(widget.createdByUser.toString())
    ]
      )
    );
  }
}