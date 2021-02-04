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

    ingredient.ingredientMapSymptomsValueFiltered = Map.from(ingredient.ingredientMapSymptomsValue);
    ingredient.ingredientMapSymptomsValueFiltered.removeWhere((key, value) => value<0);
    ingredient.sortIngredientMapSymptoms();
    print(ingredient.ingredientMapSymptomsValue);
  }


  @override
  Widget build(BuildContext context) {
    return   Scaffold(
            appBar: AppBar(
              title: Text(ingredient.name+" Statistics"),

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
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  ListTile(
                                    leading:MediaQuery.of(context).orientation==Orientation.landscape?Image(
                                        height: 40,
                                        width: 40,
                                        image:AssetImage("images/ingredients/" +ingredient.id+".png")):null,
                                    trailing:MediaQuery.of(context).orientation==Orientation.portrait?Image(
                                        height: 40,
                                        width: 40,
                                        image:AssetImage("images/ingredients/" +ingredient.id+".png")):null,
                                    title: Text("Period: "+dateStore.returnStringDate(widget.startingDate) +"  "+dateStore.returnStringDate(widget.endingDate),style: TextStyle(fontWeight:FontWeight.w500,fontSize:19)),
                                  ),
                                  Divider(
                                    height: 24,
                                    thickness: 0.5,
                                    indent: 10,
                                    endIndent: 10,
                                    color: Colors.black38,
                                  ),
                                  Padding(padding: EdgeInsets.symmetric(vertical:8,horizontal: 16),child:Text("Symptoms correlated",style: TextStyle(fontWeight:FontWeight.w500,fontSize:19))),

                                  Observer(builder: (_) =>
                                  MediaQuery.of(context).orientation==Orientation.portrait?

                                  ListView.builder(
                                      itemCount: ingredient.ingredientMapSymptomsValueFiltered.keys.length,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          alignment: Alignment.centerLeft,
                                          child:
                                          ListTile(
                                              contentPadding: EdgeInsets.all(6),
                                              leading: ImageIcon(
                                                AssetImage("images/Symptoms/" +ingredient.ingredientMapSymptomsValueFiltered.keys.elementAt(index)+".png" ),
                                                size: 38,color: Colors.black,),
                                              title: Text(symptomStore.symptomList.firstWhere((element) => ingredient.ingredientMapSymptomsValueFiltered.keys.elementAt(index)==element.id).name),
                                              subtitle: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text("Correlation: "),
                                                  ingredient.ingredientMapSymptomsValueFiltered.values.elementAt(index)<5?
                                                  Text("Low"):ingredient.ingredientMapSymptomsValueFiltered.values.elementAt(index)>=5?
                                                  ingredient.ingredientMapSymptomsValueFiltered.values.elementAt(index)<10?Text("Medium"):
                                                  Text("High") :
                                                  Container()
                                                ],)
                                          ),
                                        );}
                                  ):


                                  GridView.builder(
                                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 8 ,
                                          crossAxisSpacing: 8,
                                          childAspectRatio: (MediaQuery.of(context).size.width/MediaQuery.of(context).size.height)*2.5
                                      ),
                                      itemCount: ingredient.ingredientMapSymptomsValueFiltered.keys.length,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          alignment: Alignment.centerLeft,
                                          child:
                                          ListTile(
                                              contentPadding: EdgeInsets.all(6),
                                              leading: ImageIcon(
                                                AssetImage("images/Symptoms/" +ingredient.ingredientMapSymptomsValueFiltered.keys.elementAt(index)+".png" ),
                                                size: 38,color: Colors.black,),
                                              title: Text(symptomStore.symptomList.firstWhere((element) => ingredient.ingredientMapSymptomsValueFiltered.keys.elementAt(index)==element.id).name),
                                              subtitle: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text("Correlation: "),
                                                  ingredient.ingredientMapSymptomsValueFiltered.values.elementAt(index)<5?
                                                  Text("Low"):ingredient.ingredientMapSymptomsValueFiltered.values.elementAt(index)>=5?
                                                  ingredient.ingredientMapSymptomsValueFiltered.values.elementAt(index)<10?Text("Medium"):
                                                  Text("High") :
                                                  Container()
                                                ],)
                                          ),
                                          );

                                          ;})),


                                ]

                            )),

                      ]))));
  }
}

