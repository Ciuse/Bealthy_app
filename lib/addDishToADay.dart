import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';


class addDishToADay extends StatefulWidget {

  @override
  _addDishToADayState createState() => _addDishToADayState();
}

class _addDishToADayState extends State<addDishToADay>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add dish to this day"),
      ),
    );
  }
}