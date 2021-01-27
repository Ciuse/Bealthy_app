import 'package:Bealthy_app/Database/ingredient.dart';
import 'package:Bealthy_app/Models/ingredientStore.dart';
import 'package:Bealthy_app/Models/overviewStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'Models/dateStore.dart';



class OverviewSingleIngredient extends StatefulWidget {

  final String ingredientId;
  final DateTime startingDate;
  final DateTime endingDate;
  final OverviewStore overviewStore;
  OverviewSingleIngredient({@required this.ingredientId,@required this.startingDate,@required this.endingDate,@required this.overviewStore});

  @override
  _OverviewSingleIngredientState createState() => _OverviewSingleIngredientState();
}

class _OverviewSingleIngredientState extends State<OverviewSingleIngredient>{
  DateStore dateStore;
  IngredientStore ingredientStore;
  Ingredient ingredient;
  SymptomStore symptomStore;

  void initState() {
    super.initState();
    dateStore = Provider.of<DateStore>(context, listen: false);
    ingredientStore = Provider.of<IngredientStore>(context, listen: false);
    symptomStore = Provider.of<SymptomStore>(context, listen: false);
    ingredient= widget.overviewStore.initIngredientMapSymptomsValue(widget.ingredientId, dateStore.returnDaysOfAWeekOrMonth(widget.startingDate, widget.endingDate),symptomStore);
    ingredient.name = ingredientStore.getIngredientFromList(widget.ingredientId).name;
    widget.overviewStore.initIngredientMapSymptomsValue2(dateStore.returnDaysOfAWeekOrMonth(widget.startingDate, widget.endingDate),ingredient,symptomStore);
    widget.overviewStore.initIngredientMapSymptomsValue3(dateStore.returnDaysOfAWeekOrMonth(widget.startingDate, widget.endingDate),ingredient,symptomStore);
  }


  @override
  Widget build(BuildContext context) {
    return   Scaffold(
            appBar: AppBar(
              title: Text(ingredient.name),

            ),
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              child:   Container(
                  padding: EdgeInsets.all(4),
                  child:Column(
                      children: [

                        Card(
                            elevation: 0,
                            child: Column(
                                children:[
                                  ListTile(
                                    title: Text("Ingredient Overview",style: TextStyle(fontWeight:FontWeight.bold,fontSize:19)),
                                    subtitle: Text(dateStore.returnStringDate(widget.startingDate) +" "+dateStore.returnStringDate(widget.endingDate),style: TextStyle(fontWeight:FontWeight.bold,fontSize:19)),
                                  ),
                                  Divider(
                                    thickness: 0.8,
                                    color: Colors.black54,
                                  ),
                                  Observer(builder: (_) => ListView.builder
                                    (
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemCount: ingredient.ingredientMapSymptomsValue.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Column(
                                          children: [

                                            Container(
                                                child:
                                                ListTile(
                                                  title: Text(symptomStore.symptomList.firstWhere((element) => ingredient.ingredientMapSymptomsValue.keys.elementAt(index)==element.id).name),
                                                  subtitle: Text(ingredient.ingredientMapSymptomsValue.values.elementAt(index).toStringAsFixed(2)),
                                                   )),
                                            index!=ingredient.ingredientMapSymptomsValue.length-1?
                                            Divider(
                                              height: 0,
                                              thickness: 0.5,
                                              indent: 20,
                                              endIndent: 20,
                                              color: Colors.black38,
                                            ):Container(),
                                          ],
                                        );
                                      }
                                  ))
                                ]
                            )
                        ),

                        SizedBox(height: 20,)

                      ]

                  )),

            ));
  }
}

