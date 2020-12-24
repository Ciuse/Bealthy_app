import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'Database/symptom.dart';
import 'Models/dateStore.dart';
import 'Models/symptomStore.dart';




class OverviewPage extends StatefulWidget {
  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> with TickerProviderStateMixin {
  TabController _tabController;
  DateTime date;
  SymptomStore symptomStore;


  void initState() {
    _tabController = getTabController();
    var storeDate = Provider.of<DateStore>(context, listen: false);
    date = storeDate.selectedDate;
    symptomStore = Provider.of<SymptomStore>(context, listen: false);
    symptomStore.initStore(date);

  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TabController getTabController() {
    return TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final symptomStore = Provider.of<SymptomStore>(context);
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Statistics",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        bottom: TabBar(
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          tabs: [
            Tab(text: "Symptoms"),
            Tab(text: "Ingredients")
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          symptomStore.symptomListOfSpecificDay.length>0? symptomsWidget(symptomStore) : Container(child: Text("no symptoms present"),),
          ingredientsWidget(),
        ],
      ),
    ));
  }

  int getNumOfSymptomsInSpecificDay(){
    int num=0;
    symptomStore.symptomList.forEach((element) {
      if(element.isSymptomSelectDay){
        num = num+1;
      }
    });
    return num;
  }

  Widget symptomsWidget(SymptomStore symptomStore) {
    return Column(children: [
      Divider(height: 30),
      PieChartSample2(),
      SizedBox( // Horizontal ListView
          height: 80,
          child: Observer(builder: (_) =>
              ListView.builder(
                itemCount: symptomStore.symptomListOfSpecificDay.length,
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
                              AssetImage("images/" +
                                  symptomStore.symptomListOfSpecificDay[index].id + ".png"),
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

  Widget ingredientsWidget() {
    return Column(
        children: [
          Container()
        ]
    );
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

class PieChartSample2 extends StatefulWidget {


  PieChartSample2();

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
                      sections: symptomStore.symptomListOfSpecificDay.length>0 ? showingSections(colorsOfChart,symptomStore) : null,
                  ),
                )),
              ),
            ),
        Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                for(var symptom in symptomStore.symptomListOfSpecificDay)
                  Indicator(
                    color: colorsOfChart[symptomStore.getIndexFromSymptomsList(symptom, symptomStore.symptomList)],
                    text: symptom.name,
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

  List<PieChartSectionData> showingSections(List colorsOfChart, SymptomStore symptomStore) {

    return List.generate(symptomStore.symptomListOfSpecificDay.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;

        return PieChartSectionData(
          color: colorsOfChart[symptomStore.getIndexFromSymptomsList(symptomStore.symptomListOfSpecificDay[i], symptomStore.symptomList)],
          value: 100/symptomStore.symptomListOfSpecificDay.length,
          title: '${(100/symptomStore.symptomListOfSpecificDay.length).toStringAsFixed(1)}%',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        );

    });
  }
}


