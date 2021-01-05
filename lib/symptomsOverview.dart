import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'Models/overviewStore.dart';
import 'Models/symptomStore.dart';

class SymptomsOverview extends StatefulWidget {


  SymptomsOverview();

  @override
  State<StatefulWidget> createState() => SymptomsOverviewState();
}

class SymptomsOverviewState extends State {
  OverviewStore overviewStore;

  void initState() {
    super.initState();
    overviewStore = Provider.of<OverviewStore>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return overviewStore.totalOccurrenceSymptom.length>0? symptomsWidget() : noSymptomsWidget();
  }


  Widget symptomsWidget() {
    return Column(children: [
      Divider(height: 30),
      PieChartSample3(),
      SizedBox( // Horizontal ListView
          height: 80,
          child: Observer(builder: (_) =>
              ListView.builder(
                itemCount: overviewStore.totalOccurrenceSymptom.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Observer(builder: (_) =>
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
                            child: ImageIcon(
                              AssetImage("images/Symptoms/" +
                                  overviewStore.totalOccurrenceSymptom.keys.elementAt(index) + ".png"),
                              size: 28.0,
                            ),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),

                          )),
                  );
                },
              ),
          )),
      Divider(height: 30),
    ],
    );
  }

  Widget noSymptomsWidget() {
    return Container(child: Text("No symptoms present"));
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}

class PieChartSample3 extends StatefulWidget {


  PieChartSample3();

  @override
  State<StatefulWidget> createState() => PieChart2State();
}


class PieChart2State extends State {
  int touchedIndex;


  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List colorsOfChart = [Colors.red,Colors.cyanAccent,Colors.brown,Colors.yellow,Colors.blueAccent,Colors.green,Colors.teal,Colors.pinkAccent];
    SymptomStore symptomStore = Provider.of<SymptomStore>(context);
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
                    sections: overviewStore.totalOccurrenceSymptom.length>0 ? showingSections(colorsOfChart,overviewStore, symptomStore) : null,
                  ),
                )),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                for(var symptomId in overviewStore.totalOccurrenceSymptom.keys)
                  Indicator(
                    color: colorsOfChart[symptomStore.getIndexFromSymptomsList(symptomStore.getSymptomFromList(symptomId), symptomStore.symptomList)],
                    text: symptomStore.getSymptomFromList(symptomId).name,
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

  List<PieChartSectionData> showingSections(List colorsOfChart, OverviewStore overviewStore, SymptomStore symptomStore) {

    return List.generate(overviewStore.totalOccurrenceSymptom.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;


      return PieChartSectionData(
        color: colorsOfChart[symptomStore.getIndexFromSymptomsList(symptomStore.getSymptomFromList(overviewStore.totalOccurrenceSymptom.keys.elementAt(i)), symptomStore.symptomList)],
        value: (overviewStore.totalOccurrenceSymptom.values.elementAt(i)/overviewStore.totalNumOfSymptomList())*100,
        title: '${((overviewStore.totalOccurrenceSymptom.values.elementAt(i)/overviewStore.totalNumOfSymptomList())*100).toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );

    });
  }
}