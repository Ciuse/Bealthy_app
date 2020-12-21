import 'package:Bealthy_app/Database/symptom.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:Bealthy_app/allSymptomsPage.dart';
import 'package:Bealthy_app/calendar.dart';
import 'package:Bealthy_app/symptomPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'Models/dateStore.dart';


class SymptomBar extends StatefulWidget {
  final DateTime day;
  SymptomBar({@required this.day});

  @override
  _SymptomBarState createState() => _SymptomBarState();
}

class _SymptomBarState extends State<SymptomBar>{


  @override

  void initState() {
    super.initState();
    var store = Provider.of<SymptomStore>(context, listen: false);
    store.initStore();
    store.getSymptomsOfADay(widget.day);
  }


  @override
  Widget build(BuildContext context) {
    final symptomStore = Provider.of<SymptomStore>(context);

    return SizedBox( // Horizontal ListView
      height: 80,
      child:  Observer(builder: (_) => ListView(
          scrollDirection: Axis.horizontal,
          children:[
            Container(
                width: 70,
                alignment: Alignment.center,
                color: Colors.transparent,
                child:  RawMaterialButton(
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllSymptomsPage())).then((value) =>
                    {})
                  },
                  elevation: 5.0,
                  fillColor: Colors.white,
                  child: Icon(
                    Icons.apps_rounded,
                    size: 28.0,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),

                )),
            ListView.builder(
              itemCount: symptomStore.symptomList.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return Observer(builder: (_) => Container(
                    width: 70,
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child:  RawMaterialButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SymptomPage(symptom: symptomStore.symptomList[index])
                          )
                        )//todo inserire qui il salvataggio
                      },
                      elevation: 5.0,
                      fillColor: symptomStore.symptomList[index].isSymptomSelectDay ? Colors.blue : Colors.white,
                      child: Icon(
                        symptomStore.symptomList[index].isSymptomSelectDay ? Icons.favorite : Icons.favorite_border,
                        color: symptomStore.symptomList[index].isSymptomSelectDay ? Colors.pinkAccent : null,
                        size: 28.0,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),

                    )),
                  );
                },
              )
      ]
      )
      ),

    );
  }
}

/*
List<Widget> _buildRowList(SymptomStore symptomStore) {

  int i =0;
  List<Widget> lines = []; // this will hold Rows according to available lines.
  List<Widget> elementOfLine = []; // this will hold the places for each line

  for (Symptom symptom in symptomStore.symptomList) {
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
*/
