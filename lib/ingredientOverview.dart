import 'package:flutter/material.dart';

class IngredientOverview extends StatefulWidget {


  IngredientOverview();

  @override
  State<StatefulWidget> createState() => IngredientOverviewState();
}

class IngredientOverviewState extends State {


  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(child: Text("ingredients"),)
        ]
    );
  }

}