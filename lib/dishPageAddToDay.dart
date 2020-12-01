import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'Database/Dish.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io' as io;
import 'package:flutter/services.dart' show rootBundle;
class DishPageAddToDay extends StatefulWidget {

  final Dish dish;
  DishPageAddToDay({@required this.dish});

  @override
  _DishPageAddToDayState createState() => _DishPageAddToDayState();
}

class _DishPageAddToDayState extends State<DishPageAddToDay>{
  AssetImage dishImage;
  bool isLoading = false;
  bool clicked = false;
  bool isLocal = false;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dish.name),
      ),
      body: Container(
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
                              return Image.network(remoteString.data);
                            }
                          }
                          else {
                            return CircularProgressIndicator();
                          }
                        }
                    );
                  }
                  else {
                    return Image(
                        image: AssetImage("images/" + widget.dish.id + ".jpg"));
                  }
                } else{

                  return CircularProgressIndicator();
                }
              }

          )
      ),
    );
  }
}