import 'package:Bealthy_app/Models/ingredientStore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'Models/dateStore.dart';
import 'Models/overviewStore.dart';
import 'overviewPage.dart';

class IngredientOverview extends StatefulWidget {


  IngredientOverview();

  @override
  State<StatefulWidget> createState() => IngredientOverviewState();
}

class IngredientOverviewState extends State {
  DateStore dateStore;
  OverviewStore overviewStore;
  double animationStartPos=0;

  void initState() {
    super.initState();
    dateStore = Provider.of<DateStore>(context, listen: false);
    overviewStore = Provider.of<OverviewStore>(context, listen: false);

  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) =>overviewStore.totalOccurrenceIngredient.length>0? ingredientsWidget() : noIngredientsWidget());
  }

  Widget ingredientsWidget(){
      return Column(
        children: [
          Divider(height: 30),
          PieChartIngredient(),
          SizedBox( // Horizontal ListView
              height: 80,
              child: Observer(builder: (_) =>
                  ListView.builder(
                    itemCount: overviewStore.totalOccurrenceIngredient.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return
                          Container(
                              width: 70,
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              child: RawMaterialButton(
                                elevation: 5.0,
                                fillColor: Colors.white,
                                child:  Container(
                                    width: 50,
                                    height: 50,
                                    child:  ClipOval(
                                        child: Image(
                                          image: AssetImage("images/ingredients/" + overviewStore.totalOccurrenceIngredient.keys.elementAt(index) + ".png"),
                                        )
                                    )),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),

                              ));
                    },
                  ),
              )),
          Divider(height: 30),
        ],
      );
    }



  Widget noIngredientsWidget(){
    return Text("no ingredients");
  }
}
class PieChartIngredient extends StatefulWidget {


  PieChartIngredient();

  @override
  State<StatefulWidget> createState() => PieChartIngredientState();
}

class PieChartIngredientState extends State {
  int touchedIndex;


  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IngredientStore ingredientStore = Provider.of<IngredientStore>(context);
    OverviewStore overviewStore = Provider.of<OverviewStore>(context);
    return Observer(builder: (_) => AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Observer(builder: (_) =>PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                      setState(() {
                        if (pieTouchResponse.touchInput is FlLongPressEnd ||
                            pieTouchResponse.touchInput is FlPanEnd) {
                          touchedIndex = -1;
                        } else {
                          touchedIndex = pieTouchResponse.touchedSectionIndex;
                        }
                      });
                    }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: overviewStore.totalOccurrenceIngredient.length>0 ? showingSections(overviewStore,ingredientStore) : null,
                  ),
                )),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                for(var ingredientId in overviewStore.totalOccurrenceIngredient.keys)
                  Indicator2(
                    color: ingredientStore.colorIngredientMap[ingredientId],
                    text: ingredientStore.getSymptomFromList(ingredientId).name,
                    isSquare: true,
                  ),
                SizedBox(
                  height: 4,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    ));
  }

  List<PieChartSectionData> showingSections(OverviewStore overviewStore,IngredientStore ingredientStore ) {

    return List.generate(overviewStore.totalOccurrenceIngredient.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;


      return PieChartSectionData(
        color: ingredientStore.colorIngredientMap[overviewStore.totalOccurrenceIngredient.keys.elementAt(i)],
        value: overviewStore.totalNumOfIngredientList()>0 ? (overviewStore.totalOccurrenceIngredient.values.elementAt(i)/overviewStore.totalNumOfIngredientList())*100 :1,
        title: overviewStore.totalNumOfIngredientList()>0 ? '${((overviewStore.totalOccurrenceIngredient.values.elementAt(i)/overviewStore.totalNumOfIngredientList())*100).toStringAsFixed(1)}%' : '',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );

    });
  }
}
