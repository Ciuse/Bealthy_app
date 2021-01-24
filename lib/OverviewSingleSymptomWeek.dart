import 'package:Bealthy_app/Login/config/palette.dart';
import 'package:Bealthy_app/Models/overviewStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'Database/symptom.dart';
import 'Database/symptomOverviewGraphStore.dart';
import 'Models/dateStore.dart';

class OverviewSingleSymptomWeek extends StatefulWidget {
  final String symptomId;
  final OverviewStore overviewStore;
  OverviewSingleSymptomWeek({@required this.symptomId, @required this.overviewStore});
  @override
  _OverviewSingleSymptomWeekState createState() => _OverviewSingleSymptomWeekState();
}

class _OverviewSingleSymptomWeekState extends State<OverviewSingleSymptomWeek>  {
  DateStore dateStore;
  SymptomStore symptomStore;
  void initState() {
    super.initState();
    SymptomOverviewGraphStore graphStore = Provider.of<SymptomOverviewGraphStore>(context, listen: false);
    graphStore.initStore();
    dateStore = Provider.of<DateStore>(context, listen: false);
    symptomStore = Provider.of<SymptomStore>(context, listen: false);
    dateStore.rangeDays.forEach((dateTime) {
      widget.overviewStore.initializeOverviewValuePeriod(dateTime, widget.symptomId);
    });
    widget.overviewStore.getTotalIngredientBySymptomOfAPeriod(widget.symptomId);
  }

  @override
  Widget build(BuildContext context) {
    SymptomOverviewGraphStore graphStore = Provider.of<SymptomOverviewGraphStore>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(symptomStore.getSymptomFromList(widget.symptomId).name+" Overview"),
        ),
        body:SingleChildScrollView(
            child:Container(
                margin: EdgeInsets.all(8),
                child:
                Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          width:double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow:[
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4), //color of shadow
                                spreadRadius: 1, //spread radius
                                blurRadius: 3, // blur radius
                                offset: Offset(2, 4), // changes position of shadow
                                //first paramerter of offset is left-right
                                //second parameter is top to down
                              )],
                            borderRadius: BorderRadius.all(Radius.circular(5)), //border corner radius
                          ),
                          child: BarChartSymptom(symptomId: widget.symptomId,overviewStore: widget.overviewStore,)),
                      Observer(builder: (_) =>Container(
                          height: 130,
                          margin: EdgeInsets.only(top: 10,bottom: 10 ),
                          padding: EdgeInsets.only(top:8,left: 8,right: 8 , bottom: 8 ),
                          width:double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow:[
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.0), //color of shadow
                                spreadRadius: 1, //spread radius
                                blurRadius: 3, // blur radius
                                offset: Offset(2, 4), // changes position of shadow
                                //first paramerter of offset is left-right
                                //second parameter is top to down
                              )],
                            borderRadius: BorderRadius.all(Radius.circular(5)), //border corner radius
                          ),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Ingredients related to the symptom:",style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic,),textAlign: TextAlign.left,),
                              SizedBox(height: 10),
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: buildIngredientRow()),
                            ],)
                      )),
                      Container(
                          alignment: Alignment.centerRight,
                          child:
                          OutlinedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white),),
                            child:Text("Show All"),
                            onPressed: () {
                              graphStore.touchedIndex = -1;

                            },)),
                    ]
                ))
        ));
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
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                      child:Text("Severity Trend", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child:  Observer(builder: (_) =>Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: BarChart(
                        mainBarData(widget.overviewStore),
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
          colors: isTouched ? [Theme.of(context).accentColor] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 10,
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
          .firstWhere((element) => element.id == widget.symptomId,
          orElse: () {
            return Symptom(id: widget.symptomId, intensity: 0, frequency: 0, mealTime: [], overviewValue: 0);})
          .overviewValue, isTouched: i == graphStore.touchedIndex);
    });
  }

  BarChartData mainBarData(OverviewStore overviewStore) {
    DateStore dateStore = Provider.of<DateStore>(context);
    SymptomOverviewGraphStore graphStore = Provider.of<SymptomOverviewGraphStore>(context);
    SymptomStore symptomStore = Provider.of<SymptomStore>(context);
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
        touchExtraThreshold: EdgeInsets.all(22),
        enabled: true,
        touchCallback: (barTouchResponse) {
          if(barTouchResponse.touchInput is FlPanStart) {
            if (barTouchResponse.spot != null) {
              graphStore.touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
              overviewStore.getIngredientBySymptomDayOfAPeriod(dateStore.rangeDays[graphStore.touchedIndex], widget.symptomId);
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