import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
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
  ReactionDisposer reaction1;

  void initState() {
    super.initState();
    dateStore = Provider.of<DateStore>(context, listen: false);
    overviewStore = Provider.of<OverviewStore>(context, listen: false);
    reaction1=reactToDataChange();

  }
  ReactionDisposer reactToDataChange(){
    return reaction((changeDay) => dateStore.overviewDefaultLastDate, (value) => {
      overviewStore.initializeIngredientList(dateStore),
    });
  }

  @override
  void dispose() {
    reaction1.reaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) =>overviewStore.ingredientPresentMap.length>0? ingredientsWidget() : noIngredientsWidget());
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
                    itemCount: overviewStore.ingredientPresentMap.length,
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
                                onPressed: () =>
                                {
                                },
                                elevation: 5.0,
                                fillColor: Colors.white,
                                child:  Icon(Icons.fastfood),
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

    List colorsOfChart = [Colors.red,Colors.cyanAccent,Colors.brown,Colors.yellow,Colors.blueAccent,Colors.green,Colors.teal,Colors.pinkAccent];
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
                    sections: overviewStore.ingredientPresentMap.length>0 ? showingSections(colorsOfChart,overviewStore) : null,
                  ),
                )),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                for(var ingredientId in overviewStore.ingredientPresentMap.keys)
                  Indicator(
                    color: colorsOfChart[1],
                    text: ingredientId,
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

  List<PieChartSectionData> showingSections(List colorsOfChart, OverviewStore overviewStore, ) {

    return List.generate(overviewStore.ingredientPresentMap.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;


      return PieChartSectionData(
        color: colorsOfChart[1],
        value: overviewStore.totalNumOfIngredientList()>0 ? (overviewStore.ingredientPresentMap.values.elementAt(i)/overviewStore.totalNumOfIngredientList())*100 :1,
        title: overviewStore.totalNumOfIngredientList()>0 ? '${((overviewStore.ingredientPresentMap.values.elementAt(i)/overviewStore.totalNumOfIngredientList())*100).toStringAsFixed(1)}%' : '',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );

    });
  }
}
