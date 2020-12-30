import 'package:Bealthy_app/Models/overviewStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class OverviewSingleSymptomMonth extends StatefulWidget {
  final String symptomId;
  OverviewSingleSymptomMonth({@required this.symptomId});

  @override
  _OverviewSingleSymptomMonthState createState() => _OverviewSingleSymptomMonthState();
}

class _OverviewSingleSymptomMonthState extends State<OverviewSingleSymptomMonth>  {
  @override
  Widget build(BuildContext context) {
    final overviewStore = Provider.of<OverviewStore>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Symptom Overview"),
        ),
        body: Observer(builder: (_) => Column(
            children: <Widget>[BarChartSymptom(),
            ]
        )
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

    SymptomStore symptomStore = Provider.of<SymptomStore>(context);
    OverviewStore overviewStore = Provider.of<OverviewStore>(context);

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

  List<BarChartGroupData> showingGroups() => List.generate(31, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, 5, isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, 5, isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
      case 4:
        return makeGroupData(4, 9, isTouched: i == touchedIndex);
      case 5:
        return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
      case 6:
        return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
      case 7:
        return makeGroupData(7, 5, isTouched: i == touchedIndex);
      case 8:
        return makeGroupData(8, 6.5, isTouched: i == touchedIndex);
      case 9:
        return makeGroupData(9, 5, isTouched: i == touchedIndex);
      case 10:
        return makeGroupData(10, 7.5, isTouched: i == touchedIndex);
      case 11:
        return makeGroupData(11, 9, isTouched: i == touchedIndex);
      case 12:
        return makeGroupData(12, 11.5, isTouched: i == touchedIndex);
      case 13:
        return makeGroupData(13, 6.5, isTouched: i == touchedIndex);
      case 14:
        return makeGroupData(14, 5, isTouched: i == touchedIndex);
      case 15:
        return makeGroupData(15, 6.5, isTouched: i == touchedIndex);
      case 16:
        return makeGroupData(16, 5, isTouched: i == touchedIndex);
      case 17:
        return makeGroupData(17, 7.5, isTouched: i == touchedIndex);
      case 18:
        return makeGroupData(18, 9, isTouched: i == touchedIndex);
      case 19:
        return makeGroupData(19, 11.5, isTouched: i == touchedIndex);
      case 20:
        return makeGroupData(20, 6.5, isTouched: i == touchedIndex);
      case 21:
        return makeGroupData(21, 5, isTouched: i == touchedIndex);
      case 22:
        return makeGroupData(22, 6.5, isTouched: i == touchedIndex);
      case 23:
        return makeGroupData(23, 5, isTouched: i == touchedIndex);
      case 24:
        return makeGroupData(24, 7.5, isTouched: i == touchedIndex);
      case 25:
        return makeGroupData(25, 9, isTouched: i == touchedIndex);
      case 26:
        return makeGroupData(26, 11.5, isTouched: i == touchedIndex);
      case 27:
        return makeGroupData(27, 6.5, isTouched: i == touchedIndex);
      case 28:
        return makeGroupData(28, 6.5, isTouched: i == touchedIndex);
      case 29:
        return makeGroupData(29, 5, isTouched: i == touchedIndex);
      case 30:
        return makeGroupData(30, 7.5, isTouched: i == touchedIndex);
      case 31:
        return makeGroupData(31, 9, isTouched: i == touchedIndex);
      default:
        return null;
    }
  });

  BarChartData mainBarData() {
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
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
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
      barGroups: showingGroups(),
    );
  }
}