import 'package:Bealthy_app/Database/Symptom.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';


class AddSymptom extends StatefulWidget {
  @override
  __AddSymptomState createState() => __AddSymptomState();
}

class __AddSymptomState extends State<AddSymptom>{

  @override
  void initState() {
    super.initState();
    var store = Provider.of<SymptomStore>(context, listen: false);
    store.initStore();
  }


  @override
  Widget build(BuildContext context) {
    final symptomStore = Provider.of<SymptomStore>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Add Symptom"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildRowList(symptomStore.symptomList)
            )
        )
    );
  }
}
List<Widget> _buildRowList(ObservableList symptomList) {
  int i =0;
  List<Widget> lines = []; // this will hold Rows according to available lines.
  List<Widget> elementOfLine = []; // this will hold the places for each line

  for (Symptom symptom in symptomList) {
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

