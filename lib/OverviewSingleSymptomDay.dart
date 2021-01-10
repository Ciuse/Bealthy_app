import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Models/overviewStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:async/async.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'Database/symptomOverviewGraphStore.dart';


class OverviewSingleSymptomDay extends StatefulWidget {
  final String symptomId;
  final OverviewStore overviewStore;
  OverviewSingleSymptomDay({@required this.symptomId,@required this.overviewStore});

  @override
  _OverviewSingleSymptomDayState createState() => _OverviewSingleSymptomDayState();
}

class _OverviewSingleSymptomDayState extends State<OverviewSingleSymptomDay>  {

  SymptomStore symptomStore;


  void initState() {
    super.initState();
    symptomStore = Provider.of<SymptomStore>(context, listen: false);
    SymptomOverviewGraphStore graphStore = Provider.of<SymptomOverviewGraphStore>(context, listen: false);
    graphStore.initStore();
    widget.overviewStore.initializeOverviewValueDay(widget.symptomId);
    widget.overviewStore.getTotalIngredientBySymptomOfADay(widget.symptomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(symptomStore.getSymptomFromList(widget.symptomId).name+"\n"+"Overview"),
        ),
        body: Column(
            children: <Widget>[BarChartSymptom(symptomId: widget.symptomId, overviewStore: widget.overviewStore,),
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
          for(var ingredient in widget.overviewStore.totalOccurrenceIngredientBySymptom.keys )
            Column(children: [ Container(
                width: 50,
                height: 50,
                child:  ClipOval(
                    child: Image(
                      image: AssetImage("images/ingredients/" + ingredient + ".png"),
                    )
                )),
              Text(widget.overviewStore.totalOccurrenceIngredientBySymptom[ingredient].toString())
            ])

        ])
        : widget.overviewStore.dayOccurrenceIngredientBySymptom.keys.length==0
        ? Text("NO INGREDIENT THIS DAY")
        :ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for(var ingredient in widget.overviewStore.dayOccurrenceIngredientBySymptom.keys )
            Column(children: [
              Container(
                  width: 50,
                  height: 50,
                  child:  ClipOval(
                      child: Image(
                        image: AssetImage("images/ingredients/" + ingredient + ".png"),
                      )
                  )),
              Text(widget.overviewStore.dayOccurrenceIngredientBySymptom[ingredient].toString())
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
  final OverviewStore overviewStore;
  BarChartSymptom({@required this.symptomId,@required this.overviewStore});

  @override
  BarChartSymptomState createState() => BarChartSymptomState();
}

class BarChartSymptomState extends State<BarChartSymptom> {
  final Color barBackgroundColor = Colors.white70;
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex;

  bool isPlaying = false;

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
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text("Dicembre",style: TextStyle(
                      color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),),

                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: Observer(builder: (_) =>Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: BarChart(
                        mainBarData(widget.overviewStore),
                        swapAnimationDuration: animDuration,
                      ),
                    )),
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
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y+0.01,
          colors: isTouched ? [Colors.yellow] : [barColor],
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

  List<BarChartGroupData> showingGroups(OverviewStore overviewStore, SymptomOverviewGraphStore graphStore) {
    return List.generate(MealTime.values.length, (i)
    {
      return makeGroupData(
          i, overviewStore.mapSymptomsOverviewDay[MealTime.values[i]]
          .firstWhere((element) => element.id == widget.symptomId)
          .overviewValue, isTouched: i == graphStore.touchedIndex);
    });
  }

  BarChartData mainBarData(OverviewStore overviewStore) {
    SymptomOverviewGraphStore graphStore = Provider.of<SymptomOverviewGraphStore>(context);

    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String mealTimeDay;
              mealTimeDay = MealTime.values[group.x.toInt()].toString().split('.').last;

              return BarTooltipItem(
                  mealTimeDay + '\n' + (rod.y - 1).toString(), TextStyle(color: Colors.yellow));
            }),
        allowTouchBarBackDraw: true,
        touchExtraThreshold: EdgeInsets.all(22),
        enabled: true,
        touchCallback: (barTouchResponse) {
          if(barTouchResponse.touchInput is FlPanStart) {
            if (barTouchResponse.spot != null) {
              graphStore.touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
              overviewStore.getIngredientBySymptomMealTimeOfADay(MealTime.values[graphStore.touchedIndex],widget.symptomId);
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
          const TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14,),
          margin: 8,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'Breakfast';
              case 1:
                return 'Lunch';
              case 2:
                return 'Snack';
              case 3:
                return 'Dinner';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 20,
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
      barGroups: showingGroups(overviewStore,graphStore),
    );
  }
}