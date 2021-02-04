import 'package:Bealthy_app/Models/overviewStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'Database/symptom.dart';
import 'Database/symptomOverviewGraphStore.dart';
import 'Login/config/palette.dart';
import 'Models/dateStore.dart';
import 'headerScrollStyle.dart';

class OverviewSingleSymptomMonth extends StatefulWidget {
  final String symptomId;
  final OverviewStore overviewStore;
  OverviewSingleSymptomMonth({@required this.symptomId,@required this.overviewStore});

  @override
  _OverviewSingleSymptomMonthState createState() => _OverviewSingleSymptomMonthState();
}

class _OverviewSingleSymptomMonthState extends State<OverviewSingleSymptomMonth>  {

  SymptomStore symptomStore;
  DateStore dateStore;

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

    return OKToast(child: Scaffold(
        appBar: AppBar(
          title: Text(symptomStore.getSymptomFromList(widget.symptomId).name+" Statistics"),
          actions: [
            Builder(
                builder: (ctx) => IconButton(
                  onPressed: () =>
                  {
                    showToast(
                        "Graph showing the severity trend of a symptom over the selected time period.\nYou can press on a day to view specific data",
                        position: ToastPosition.bottom,
                        context: ctx,
                        duration: Duration(seconds: 10))
                  },
                  icon: Icon(Icons.info_outline),)),
          ],
        ),
        body:MediaQuery.of(context).orientation==Orientation.portrait?SingleChildScrollView(
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
                                offset: Offset(2, 4),// changes position of shadow
                                //first paramerter of offset is left-right
                                //second parameter is top to down
                              )],
                            borderRadius: BorderRadius.all(Radius.circular(5)), //border corner radius
                          ),
                          child: BarChartSymptom(symptomId: widget.symptomId,overviewStore: widget.overviewStore,)),
                      Observer(builder: (_) =>Container(
                          height: 190,
                          margin: EdgeInsets.only(top: 10,bottom: 10 ),
                          padding: EdgeInsets.only(top:5,left: 6,right: 6 , bottom: 5 ),
                          width:double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow:[
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4), //color of shadow
                                spreadRadius: 1, //spread radius
                                blurRadius: 3, // blur radius
                                offset: Offset(2, 4),// changes position of shadow
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
                              ListTile(
                                title: Text("Ingredients related:",style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic,),textAlign: TextAlign.left,),
                                trailing:  Builder(
                                    builder: (ctx) => IconButton(
                                      onPressed: () =>
                                      {
                                        showToast(
                                            "Ingredients taken when the symptom occurred and that are likely related",
                                            position: ToastPosition.bottom,
                                            context: ctx,
                                            duration: Duration(seconds: 7))
                                      },
                                      icon: Icon(Icons.info_outline),)),
                              ),
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: buildIngredientRow()),
                              Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child:
                                  OutlinedButton(
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(
                                        Colors.white),),
                                    child:Text("Show All"),
                                    onPressed: () {
                                      graphStore.touchedIndex = -1;

                                    },))
                            ],)
                      )),

                    ]
                ))
        ):
        Row(children: [
          Expanded(child:Container(
              padding: EdgeInsets.all(16),
              child: Card(
                  child: BarChartSymptom(
                    symptomId: widget.symptomId,overviewStore: widget.overviewStore,)))),
          Expanded(child:Observer(builder: (_) =>Container(
              padding: EdgeInsets.all(16),
              child: Card(
                  child:
                  Container(
                      padding: EdgeInsets.all(16),
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text("Ingredients related:",style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic,),textAlign: TextAlign.left,),
                            trailing:  Builder(
                                builder: (ctx) => IconButton(
                                  onPressed: () =>
                                  {
                                    showToast(
                                        "Ingredients taken when the symptom occurred and that are likely related",
                                        position: ToastPosition.bottom,
                                        context: ctx,
                                        duration: Duration(seconds: 7))
                                  },
                                  icon: Icon(Icons.info_outline),)),
                          ),
                          Container(
                              height: 80,
                              child:buildIngredientRow()),
                          Container(
                              alignment: Alignment.centerRight,
                              child:
                              OutlinedButton(
                                child:Text("Show All"),
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.white),),
                                onPressed: () {
                                  graphStore.touchedIndex = -1;

                                },))
                        ],))
              )))),

        ],)

    ));
  }

  Widget buildIngredientRow(){
    Map<String,int> sortedTotalMap= widget.overviewStore.sortTotalOccurrenceIngredientBySymptom();
    Map<String,int> sortedDayMap= widget.overviewStore.sortDayOccurrenceIngredientBySymptom();
    SymptomOverviewGraphStore graphStore = Provider.of<SymptomOverviewGraphStore>(context);
    ScrollController _scrollController = new ScrollController();

    return graphStore.touchedIndex==-1?
    widget.overviewStore.totalOccurrenceIngredientBySymptom.keys.length==0
        ? Center(child: Text("NO INGREDIENT RELATED")):
    MyScrollbar(
        scrollController:_scrollController,
        child:ListView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            children: [
              for(var ingredient in sortedTotalMap.keys )
                Column(children: [ Container(
                    margin: EdgeInsets.symmetric(horizontal:6),
                    width: 50,
                    height: 50,
                    child:  ClipOval(
                        child: Image(
                          image: AssetImage("images/ingredients/" + ingredient + ".png"),
                        )
                    )),
                  Text(sortedTotalMap[ingredient].toString())
                ])

            ]))
        : widget.overviewStore.dayOccurrenceIngredientBySymptom.keys.length==0
        ? Center(child: Text("NO INGREDIENT THIS DAY"))
        :MyScrollbar(
        scrollController:_scrollController,
        child:ListView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            children: [
              for(var ingredient in sortedDayMap.keys )
                Column(children: [
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),

                      width: 50,
                      height: 50,
                      child:  ClipOval(
                          child: Image(
                            image: AssetImage("images/ingredients/" + ingredient + ".png"),
                          )
                      )),
                  Text(sortedDayMap[ingredient].toString())
                ],
                )
            ]));
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
        color: Color(0xffffe0b2),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                        child:Text("Severity Trend", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,))),

                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: Observer(builder: (_) =>Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
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
        double width = 7.5,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 0.2 : y, //todo: il 0.01 permette di cliccare quelli a 0-> lasciarlo o no?
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

    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if(groupIndex==graphStore.touchedIndex){
                String monthDay;
                monthDay = overviewStore.fixDate(dateStore.rangeDays[group.x.toInt()]);
                return BarTooltipItem(
                    monthDay + '\n' + (rod.y - 0.2).toString(), TextStyle(color: Colors.yellow));
              }else{
                return null;
              }

            }),
        allowTouchBarBackDraw: true,
        touchExtraThreshold: EdgeInsets.all(2),
        enabled: true,
        touchCallback: (barTouchResponse) {
          if(barTouchResponse.touchInput is FlPanStart) {
            if (barTouchResponse.spot != null) {
              graphStore.touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
              overviewStore.getIngredientBySymptomDayOfAPeriod(dateStore.rangeDays[graphStore.touchedIndex],widget.symptomId);
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
            if(value.toInt()%5==0){
              if(dateStore.rangeDays.length-2!=value.toInt()) {
                return dateStore.rangeDays[value.toInt()].day.toString();
              }else{
                return "";
              }
            }else{
              if(dateStore.rangeDays.length-1==value.toInt())
              return dateStore.rangeDays[value.toInt()].day.toString();
              else{
                return " ";
              }
            };
            // switch (value.toInt()) {
            // case 0:
            //     return dateStore.rangeDays[0].day.toString();
            //   case 5:
            //     return dateStore.rangeDays[5].day.toString();
            //   case 10:
            //     return dateStore.rangeDays[10].day.toString();
            //   case 15:
            //     return dateStore.rangeDays[15].day.toString();
            //   case 20:
            //     return dateStore.rangeDays[20].day.toString();
            //   case 25:
            //     return dateStore.rangeDays[25].day.toString();
            //   case 30:
            //     return dateStore.rangeDays[30].day.toString();
            //   default:
            //     return '';
            // }
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
            } else if (value == 5) {
              return '5';
            } else if (value == 10) {
              return '10';
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
