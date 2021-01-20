import 'package:Bealthy_app/Models/ingredientStore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'Models/dateStore.dart';
import 'Models/overviewStore.dart';
import 'overviewPage.dart';

class IngredientOverview extends StatefulWidget {
  final OverviewStore overviewStore;

  IngredientOverview({@required this.overviewStore});

  @override
  State<StatefulWidget> createState() => IngredientOverviewState();
}

class IngredientOverviewState extends State<IngredientOverview> {
  DateStore dateStore;
  double animationStartPos=0;

  void initState() {
    super.initState();
    dateStore = Provider.of<DateStore>(context, listen: false);


  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        switch (widget.overviewStore.loadInitIngredientGraph.status) {
          case FutureStatus.rejected:
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Oops something went wrong'),
                  RaisedButton(
                    child: Text('Retry'),
                    onPressed: () async {
                    },
                  ),
                ],
              ),
            );
          case FutureStatus.fulfilled:
            return widget.overviewStore.totalOccurrenceIngredient.length>0? ingredientsWidget() : noIngredientsWidget();
          case FutureStatus.pending:
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }

  Widget ingredientsWidget(){
      return Column(
        children: [
          PieChartIngredient(overviewStore: widget.overviewStore,),
          SizedBox( // Horizontal ListView
              height: 80,
              child: Observer(builder: (_) =>
                  ListView.builder(
                    itemCount: widget.overviewStore.totalOccurrenceIngredient.length<9 ? widget.overviewStore.totalOccurrenceIngredient.length : 8,
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
                                child:
                                Container(
                                    height: 28.0,
                                    child:  ClipOval(
                                        child: Image(
                                          fit: BoxFit.fill,
                                          image: AssetImage("images/ingredients/" + widget.overviewStore.totalOccurrenceIngredient.keys.elementAt(index) + ".png"),
                                        )
                                    )),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),

                              ));
                    },
                  ),
              )),
        ],
      );
    }



  Widget noIngredientsWidget(){
    return Text("No Ingredients");
  }
}
class PieChartIngredient extends StatefulWidget {

  final OverviewStore overviewStore;

  PieChartIngredient({@required this.overviewStore});


  @override
  State<StatefulWidget> createState() => PieChartIngredientState();
}

class PieChartIngredientState extends State<PieChartIngredient> {
  int touchedIndex;


  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IngredientStore ingredientStore = Provider.of<IngredientStore>(context);
    return Observer(builder: (_) => Card(
      elevation: 1,
      margin: EdgeInsets.all(4),
      child: Column(children: [
      ListTile(
      title: const Text('% Ingredients eaten'),
    ),
         Row(
          children: <Widget>[

            Expanded(
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
                    sectionsSpace: 5,
                    centerSpaceRadius: 45,
                    sections: widget.overviewStore.totalOccurrenceIngredient.length>0 ? showingSections(widget.overviewStore,ingredientStore) : null,
                  ),
                )),
              ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children:[
                for(var ingredientId in widget.overviewStore.totalOccurrenceIngredient.keys.take(8))
                  Indicator2(
                    color: ingredientStore.colorIngredientMap[ingredientId],
                    text: ingredientStore.getIngredientFromList(ingredientId).name,
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
      ]),
    ));
  }

  List<PieChartSectionData> showingSections(OverviewStore overviewStore,IngredientStore ingredientStore ) {

    return List.generate(widget.overviewStore.totalOccurrenceIngredient.length<9 ? widget.overviewStore.totalOccurrenceIngredient.length : 8, (i) {
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
