import 'package:Bealthy_app/Models/overviewStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'Database/symptomOverviewGraphStore.dart';
import 'Models/dateStore.dart';

class OverviewSingleSymptomMonth extends StatefulWidget {
  final String symptomId;
  OverviewSingleSymptomMonth({@required this.symptomId});

  @override
  _OverviewSingleSymptomMonthState createState() => _OverviewSingleSymptomMonthState();
}

class _OverviewSingleSymptomMonthState extends State<OverviewSingleSymptomMonth>  {

  SymptomStore symptomStore;
  DateStore dateStore;
  OverviewStore overviewStore;
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
            children: <Widget>[BarChartSymptom(symptomId: widget.symptomId)
            ]
        )
    );
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

  int touchedIndex;

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
                  Text("Dicembre",style: TextStyle(
                  color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),),

                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: BarChart(
                        mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
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
        double width = 7.5,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
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

  List<BarChartGroupData> showingGroups(DateStore dateStore, OverviewStore overviewStore, SymptomOverviewGraphStore graphStore)  {
    return List.generate(dateStore.rangeDays.length, (i)
    {
      return makeGroupData(
          i, overviewStore.mapSymptomsOverview[dateStore.rangeDays[i]]
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
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                case 7:
                  weekDay = 'Sunday';
                  break;
                  case 8:
                    weekDay = 'Sunday';
                    break;
                case 9:
                  weekDay = 'Sunday';
                  break;
                case 10:
                  weekDay = 'Sunday';
                  break;
                case 11:
                  weekDay = 'Sunday';
                  break;
                case 12:
                  weekDay = 'Sunday';
                  break;
                case 13:
                  weekDay = 'Sunday';
                  break;
                case 14:
                  weekDay = 'Sunday';
                  break;
                case 15:
                  weekDay = 'Sunday';
                  break;
                case 16:
                  weekDay = 'Sunday';
                  break;
                case 17:
                  weekDay = 'Sunday';
                  break;
                case 18:
                  weekDay = 'Sunday';
                  break;
                case 19:
                  weekDay = 'Sunday';
                  break;
                case 20:
                  weekDay = 'Sunday';
                  break;
                case 21:
                  weekDay = 'Sunday';
                  break;
                case 22:
                  weekDay = 'Sunday';
                  break;
                case 23:
                  weekDay = 'Sunday';
                  break;
                case 24:
                  weekDay = 'Sunday';
                  break;
                case 25:
                  weekDay = 'Sunday';
                  break;
                case 26:
                  weekDay = 'Sunday';
                  break;
                case 27:
                  weekDay = 'Sunday';
                  break;
                case 28:
                  weekDay = 'Sunday';
                  break;
                case 29:
                  weekDay = 'Sunday';
                  break;
                case 30:
                  weekDay = 'Sunday';
                  break;
                case 31:
                  weekDay = 'Sunday';
                  break;
              }
              return BarTooltipItem(
                  weekDay + '\n' + (rod.y - 1).toString(), TextStyle(color: Colors.yellow));
            }),
        touchCallback: (barTouchResponse) {
          if(barTouchResponse.touchInput is FlPanStart) {
            if (barTouchResponse.spot != null) {
              graphStore.touchedIndex =
                  barTouchResponse.spot.touchedBarGroupIndex;
              print(barTouchResponse.spot );

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
                return '1';
              case 4:
                return '5';
              case 9:
                return '10';
              case 14:
                return '15';
              case 19:
                return '20';
              case 24:
                return '25';
              case 29:
                return '30';
              default:
                return '';
            }
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
