import 'package:Bealthy_app/Models/overviewStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'Database/symptomOverviewGraphStore.dart';
import 'Models/dateStore.dart';

class OverviewSingleSymptomWeek extends StatefulWidget {
  final String symptomId;
  OverviewSingleSymptomWeek({@required this.symptomId});
  @override
  _OverviewSingleSymptomWeekState createState() => _OverviewSingleSymptomWeekState();
}

class _OverviewSingleSymptomWeekState extends State<OverviewSingleSymptomWeek>  {
  DateStore dateStore;
  OverviewStore overviewStore;
  SymptomStore symptomStore;

  void initState() {
    super.initState();
    overviewStore = Provider.of<OverviewStore>(context, listen: false);
    dateStore = Provider.of<DateStore>(context, listen: false);
    symptomStore = Provider.of<SymptomStore>(context, listen: false);
    dateStore.rangeDays.forEach((dateTime) {
      overviewStore.initializeOverviewValue(dateTime, widget.symptomId);
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(symptomStore.getSymptomFromList(widget.symptomId).name+"\n"+"Overview"),
        ),
        body:Column(
            children: <Widget>[BarChartSymptom(symptomId: widget.symptomId,),
        Observer(builder: (_) =>Expanded(
                  child: buildIngredientRow() ))
            ]
        )
    );
  }

  Widget buildIngredientRow(){

    SymptomOverviewGraphStore graphStore = Provider.of<SymptomOverviewGraphStore>(context);
    return graphStore.touchedIndex==-1?
    ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for(var ingredient in overviewStore.totalOccurrenceIngredient.keys )
            Column(children: [ Container(
                width: 50,
                height: 50,
                child:  ClipOval(
                    child: Image(
                      image: AssetImage("images/ingredients/" + ingredient + ".png"),
                    )
                )),
              Text(overviewStore.totalOccurrenceIngredient[ingredient].toString())
            ])

        ])
        : overviewStore.dayOccurrenceIngredient.keys.length==0
        ? Text("NO INGREDIENT THIS DAY")
        :ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for(var ingredient in overviewStore.dayOccurrenceIngredient.keys )
            Column(children: [
              Container(
                  width: 50,
                  height: 50,
                  child:  ClipOval(
                      child: Image(
                        image: AssetImage("images/ingredients/" + ingredient + ".png"),
                      )
                  )),
              Text(overviewStore.dayOccurrenceIngredient[ingredient].toString())
            ],
            )
        ]);
  }
}



class BarChartSymptom extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];
  final String symptomId;
  BarChartSymptom({@required this.symptomId});

  @override
  BarChartSymptomState createState() => BarChartSymptomState();
}

class BarChartSymptomState extends State<BarChartSymptom> {
  final Color barBackgroundColor = Colors.white70;
  final Duration animDuration = const Duration(milliseconds: 250);

  bool isPlaying = false;
  DateStore dateStore;

  void initState() {
    super.initState();
    dateStore = Provider.of<DateStore>(context, listen: false);
    }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.lightBlue,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text("Dicembre" ,style: TextStyle(
                      color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),),

                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child:  Observer(builder: (_) =>Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: BarChart(
                        mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ))
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.black87,
        double width = 12,
        List<int> showTooltips = const [],
      }) {

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y+0.01, //todo: il 0.01 permette di cliccare quelli a 0-> lasciarlo o no?
          colors: isTouched ? [Colors.green] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(DateStore dateStore, OverviewStore overviewStore, SymptomOverviewGraphStore graphStore)  {
    return List.generate(dateStore.rangeDays.length, (i)
    {
      return makeGroupData(
          i, overviewStore.mapSymptomsOverviewPeriod[dateStore.rangeDays[i]]
          .firstWhere((element) => element.id == widget.symptomId)
          .overviewValue, isTouched: i == graphStore.touchedIndex);
    });
  }

  BarChartData mainBarData() {
    DateStore dateStore = Provider.of<DateStore>(context);
    OverviewStore overviewStore = Provider.of<OverviewStore>(context);
    SymptomOverviewGraphStore graphStore = Provider.of<SymptomOverviewGraphStore>(context);
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
                weekDay = overviewStore.fixDate(dateStore.rangeDays[group.x.toInt()]);

              return BarTooltipItem(
                  weekDay + '\n' + (rod.y - 1).toString(), TextStyle(color: Colors.yellow));
            }),
        allowTouchBarBackDraw: true,
        touchExtraThreshold: EdgeInsets.all(4),
        enabled: true,
        touchCallback: (barTouchResponse) {
          if(barTouchResponse.touchInput is FlPanStart) {
            if (barTouchResponse.spot != null) {
              graphStore.touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
              overviewStore.singleDayOccurrenceIngredients(dateStore.rangeDays[graphStore.touchedIndex]);
            }
            else{
              graphStore.touchedIndex = -1;
            }
          }
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) =>
          const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10,),
          margin: 8,
          getTitles: (double value) {
            return dateStore.rangeDays[value.toInt()].day.toString();
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 5,
          reservedSize: 14,
          getTitles: (value) {
            if (value == 0) {
              return '0';
            } else if (value == 10) {
              return '10';
            } else if (value == 20) {
              return '20';
            } else {
              return '';
            }
          },
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(dateStore, overviewStore, graphStore),
    );
  }
}