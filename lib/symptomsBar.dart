import 'package:Bealthy_app/Models/ingredientStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:Bealthy_app/allSymptomsPage.dart';
import 'package:Bealthy_app/symptomPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'Login/config/palette.dart';



class SymptomsBar extends StatefulWidget {
  final DateTime day;
  SymptomsBar({@required this.day});

  @override
  _SymptomsBarState createState() => _SymptomsBarState();
}

class _SymptomsBarState extends State<SymptomsBar>{


  @override

  void initState() {
    super.initState();
    var store = Provider.of<SymptomStore>(context, listen: false);
    store.initStore(widget.day);
    var storeIngredient = Provider.of<IngredientStore>(context, listen: false);
    storeIngredient.initStore();
  }


  @override
  Widget build(BuildContext context) {
    final symptomStore = Provider.of<SymptomStore>(context);

    return
      Container(
        margin: EdgeInsets.symmetric(horizontal: 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Palette.bealthyColorScheme.background,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)), //border corner radius
          boxShadow:[
            BoxShadow(
              color: Colors.grey.withOpacity(0.9), //color of shadow
              spreadRadius: 1, //spread radius
              blurRadius: 1.5, // blur radius
              offset: Offset(2, 4),// changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
        ),
        child:Column(

            children: [

              ListTile(
                title: Text("Symptoms",style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
                leading: Icon(Icons.sick,color: Colors.black),
              ),
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 5,right: 5 ),
                  padding: EdgeInsets.only(left: 6,right: 6 ),
                  width:double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)), //border corner radius
                    border: Border.all(color: Palette.bealthyColorScheme.primaryVariant, width: 2)
                  ),
                  child: SizedBox(// Horizontal ListView
                    height: 70,
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
                                  size: 24.0,
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
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  width: 70,
                                  alignment: Alignment.center,
                                  color: Colors.transparent,
                                  child:  RawMaterialButton(
                                    constraints : const BoxConstraints(minWidth: 55.0, minHeight: 55.0),
                                    shape: CircleBorder(
                                      side: BorderSide(color:  Palette.bealthyColorScheme.primaryVariant, width: 2, style: BorderStyle.solid)
                                  ),
                                    onPressed: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SymptomPage(symptom: symptomStore.symptomList[index])
                                          )
                                      )//todo inserire qui il salvataggio
                                    },
                                    elevation: 5.0,
                                    fillColor: symptomStore.symptomList[index].isSymptomSelectDay ? Palette.bealthyColorScheme.primaryVariant : Colors.white,
                                    child: ImageIcon(
                                      AssetImage("images/Symptoms/" +symptomStore.symptomList[index].id+".png" ),
                                      color: symptomStore.symptomList[index].isSymptomSelectDay ? Palette.bealthyColorScheme.onSecondary : null,
                                      size: 35.0,
                                    ),

                                  )),
                              );
                            },
                          )
                        ]
                    )
                    ),
                  )),
              SizedBox(height: 10)

            ],
          ));
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
