import 'package:Bealthy_app/Models/overviewStore.dart';
import 'package:Bealthy_app/headerScrollStyle.dart';
import 'package:Bealthy_app/ingredientOverview.dart';
import 'package:Bealthy_app/overviewSingleSymptomMonth.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'Database/enumerators.dart';
import 'Models/dateStore.dart';
import 'Models/symptomStore.dart';
import 'OverviewSingleSymptomDay.dart';
import 'OverviewSingleSymptomWeek.dart';


class OverviewPage extends StatefulWidget {
  final headerScrollStyle = const HeaderScrollStyle();
  final formatAnimation = FormatAnimation.slide;
  DateTime lastDayOfWeek;
  OverviewPage({this.lastDayOfWeek});

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> with TickerProviderStateMixin {
  TabController _tabController;
  DateStore dateStore;
  OverviewStore overviewStore;
  double animationStartPos=0;
  final temporalCt = TextEditingController();
  List<String> temporalList = [];


  void initState() {
  temporalList= getTemporalName();
    super.initState();

    _tabController = getTabController();
    dateStore = Provider.of<DateStore>(context, listen: false);
    //trovo l'ultimo giorno della settimana
  if(widget.lastDayOfWeek==null){
    dateStore.overviewDefaultLastDate=DateTime.now();
  }else{
    dateStore.overviewDefaultLastDate=widget.lastDayOfWeek;
  }


    //trovo il primo giorno della settimana
    dateStore.firstDayInWeek();
    dateStore.timeSelected = TemporalTime.Week;

    overviewStore = new OverviewStore(timeSelected: dateStore.timeSelected);
    overviewStore.initializeSymptomsMap(dateStore);


  }

  List<String> getTemporalName(){

    List<String> listToReturn = new List<String>();
    listToReturn.add(TemporalTime.Week.toString().split('.').last);
    listToReturn.add(TemporalTime.Month.toString().split('.').last);
    return listToReturn;
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
    return DefaultTabController(length: 2, child: Scaffold(
        appBar: AppBar(
          title: Text("Statistics",),
          actions: <Widget>[
       PopupMenuButton(
                onSelected:  choiceAction,
                icon: Icon(Icons.calendar_today),
                itemBuilder: (BuildContext context)
                {
                  return temporalList.map((String choice) {
                    return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice));
                  }).toList();
                }
            )
        ],
          bottom: TabBar(
          tabs: [
            Tab(text: "Symptoms"),
            Tab(text: "Ingredients")
          ],
          controller: _tabController,
        ),
      ),
        body:Container(
    margin: EdgeInsets.all(8),
    child:
            Observer(builder: (_) =>
            dateStore.timeSelected==TemporalTime.Day? dayOverviewBuild():
            dateStore.timeSelected==TemporalTime.Week? weekOverviewBuild():
            dateStore.timeSelected==TemporalTime.Month? monthOverviewBuild(): null
            )

      ))
    );
  }

  void choiceAction(String choice){
    TemporalTime.values.forEach((element) {
        if(element.toString().split('.').last==choice){
          dateStore.timeSelected = element;
        }
      });
    if(choice== TemporalTime.Day.toString().split('.').last){
      overviewStore = new OverviewStore(timeSelected: dateStore.timeSelected);

      overviewStore.initializeSymptomsMap(dateStore);
    }
    if(choice== TemporalTime.Week.toString().split('.').last){


      //calcolo il primo giorno della settimana e trovo i giorni del range
      context.read<DateStore>().firstDayInWeek();

      //trovo le statistiche di quel range di giorni
      overviewStore = new OverviewStore(timeSelected: dateStore.timeSelected);
      overviewStore.initializeSymptomsMap(dateStore);
    }
    if(choice== TemporalTime.Month.toString().split('.').last){


    //calcolo il primo giorno del mese e trovo i giorni del range
      context.read<DateStore>().firstDayInMonth();

      overviewStore = new OverviewStore(timeSelected: dateStore.timeSelected);
      //trovo le statistiche di quel range di giorni
      overviewStore.initializeSymptomsMap(dateStore);
    }
  }

  Widget _buildContent() {
    if (widget.formatAnimation == FormatAnimation.slide) {
      return AnimatedSize(
        duration: Duration(
            milliseconds: 330
        ),
        curve: Curves.fastOutSlowIn,
        vsync: this,
        alignment: Alignment(0, -1),
        child: _buildHorizontalSwipeWrapper(
            child: overviewContent())
      );
    } else {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          return SizeTransition(
            sizeFactor: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: _buildHorizontalSwipeWrapper(
            child: overviewContent())
      );
    }
  }

  Widget _buildHorizontalSwipeWrapper({Widget child}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 850),
      switchInCurve: Curves.decelerate,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
              begin: Offset(animationStartPos, 0),
              end: Offset(0, 0))
              .animate(animation),
          child: child,
        );
      },
      layoutBuilder: (currentChild, _) => currentChild,
      child: Dismissible(
        key: ValueKey(dateStore.overviewDefaultLastDate),
        resizeDuration: null,
        direction: DismissDirection.horizontal,
        child: child,
      ),
    );
  }


  Widget overviewContent (){

    return TabBarView(
    controller: _tabController,
      children: [
    SingleChildScrollView(child: Container(
      padding: EdgeInsets.symmetric(vertical: 10),
            child: Observer(
              builder: (_) {
                switch (overviewStore.loadInitSymptomGraph.status) {
                  case FutureStatus.rejected:
                    return Center(
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
                    return overviewStore.totalOccurrenceSymptom.length>0? symptomsWidget() : noSymptomsWidget();
                  case FutureStatus.pending:
                  default:
                    return Center(
                        child:CircularProgressIndicator());
                }
              },
            ))),
            SingleChildScrollView(child: IngredientOverview(overviewStore: overviewStore,)),
      ],
    );
  }
  Widget noSymptomsWidget() {
    return Center(child: Text("No Symptoms"));
  }

  void selectPreviousDay() {
    print("current day: ${dateStore.overviewDefaultLastDate}");
    animationStartPos= -1.2;
    context.read<DateStore>().previousDayOverview();
    print("previous day: ${dateStore.overviewDefaultLastDate}");
    overviewStore = new OverviewStore(timeSelected: dateStore.timeSelected);
    overviewStore.initializeSymptomsMap(dateStore);
  }

  void selectNextDay() {
    print("current day: ${dateStore.overviewDefaultLastDate}");
    animationStartPos= 1.2;
    context.read<DateStore>().nextDayOverview();
    print("next day: ${dateStore.overviewDefaultLastDate}");
    overviewStore = new OverviewStore(timeSelected: dateStore.timeSelected);
    overviewStore.initializeSymptomsMap(dateStore);
  }

  void selectPreviousWeek() {
    animationStartPos= -1.2;
    context.read<DateStore>().previousWeekOverview();
    overviewStore = new OverviewStore(timeSelected: dateStore.timeSelected);
    overviewStore.initializeSymptomsMap(dateStore);

  }

  void selectNextWeek() {
    animationStartPos= 1.2;
    context.read<DateStore>().nextWeekOverview();
    overviewStore = new OverviewStore(timeSelected: dateStore.timeSelected);
    overviewStore.initializeSymptomsMap(dateStore);
  }

  void selectPreviousMonth() {
    animationStartPos= -1.2;
    context.read<DateStore>().previousMonthOverview();
    overviewStore = new OverviewStore(timeSelected: dateStore.timeSelected);
    overviewStore.initializeSymptomsMap(dateStore);
  }

  void selectNextMonth() {
    animationStartPos= 1.2;
    context.read<DateStore>().nextMonthOverview();
    overviewStore = new OverviewStore(timeSelected: dateStore.timeSelected);
    overviewStore.initializeSymptomsMap(dateStore);
  }

  Widget dayOverviewBuild(){
    return Observer(builder: (_) =>Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderDay(dateStore.overviewDefaultLastDate),
        Expanded(child: _buildContent()),
        //Add this to give height
      ],
    ));
  }

  Widget weekOverviewBuild(){
    return Observer(builder: (_) =>Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderWeek(dateStore.overviewFirstDate,dateStore.overviewDefaultLastDate),
        Expanded(child: _buildContent())

        //Add this to give height
      ],
    ));
  }

  Widget monthOverviewBuild(){
    return Observer(builder: (_) =>Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderMonth(dateStore.overviewFirstDate,dateStore.overviewDefaultLastDate),
        Expanded(child: _buildContent())
        //Add this to give height
      ],
    ));
  }


  Widget _buildHeaderDay(DateTime day) {
    final children = [
      CustomIconButtonOur(
        icon: widget.headerScrollStyle.leftChevronIcon,
        onTap: selectPreviousDay,
        margin: widget.headerScrollStyle.leftChevronMargin,
        padding: widget.headerScrollStyle.leftChevronPadding,
      ),
      Expanded(
        child: GestureDetector(
          onTap: null,
          onLongPress: null,
          child: Text(DateFormat.yMMMMEEEEd("en_US").format(day),
            style: widget.headerScrollStyle.titleTextStyle,
            textAlign: widget.headerScrollStyle.centerHeaderTitle
                ? TextAlign.center
                : TextAlign.start,
          ),
        ),
      ),
      CustomIconButtonOur(
        icon: widget.headerScrollStyle.rightChevronIcon,
        onTap: selectNextDay,
        margin: widget.headerScrollStyle.leftChevronMargin,
        padding: widget.headerScrollStyle.leftChevronPadding,
      ),
    ];

    return Container(
      decoration: widget.headerScrollStyle.decoration,
      margin: widget.headerScrollStyle.headerMargin,
      padding: widget.headerScrollStyle.headerPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );

  }

  Widget _buildHeaderWeek(DateTime firstDay, DateTime lastDay) {
    final children = [
      CustomIconButtonOur(
        icon: widget.headerScrollStyle.leftChevronIcon,
        onTap: selectPreviousWeek,
        margin: widget.headerScrollStyle.leftChevronMargin,
        padding: widget.headerScrollStyle.leftChevronPadding,
      ),
      Expanded(
        child: GestureDetector(
          onTap: null,
          onLongPress: null,
          child: Text(DateFormat.yMMMMEEEEd("en_US").format(firstDay) +"\n"+ DateFormat.yMMMMEEEEd("en_US").format(lastDay),
            style: widget.headerScrollStyle.titleTextStyle,
            textAlign: widget.headerScrollStyle.centerHeaderTitle
                ? TextAlign.center
                : TextAlign.start,
          ),
        ),
      ),
      CustomIconButtonOur(
        icon: widget.headerScrollStyle.rightChevronIcon,
        onTap: selectNextWeek,
        margin: widget.headerScrollStyle.leftChevronMargin,
        padding: widget.headerScrollStyle.leftChevronPadding,
      ),
    ];

    return Container(
      decoration: widget.headerScrollStyle.decoration,
      margin: widget.headerScrollStyle.headerMargin,
      padding: widget.headerScrollStyle.headerPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );

  }

  Widget _buildHeaderMonth(DateTime firstDay, DateTime lastDay) {
    final children = [
      CustomIconButtonOur(
        icon: widget.headerScrollStyle.leftChevronIcon,
        onTap: selectPreviousMonth,
        margin: widget.headerScrollStyle.leftChevronMargin,
        padding: widget.headerScrollStyle.leftChevronPadding,
      ),
      Expanded(
        child: GestureDetector(
          onTap: null,
          onLongPress: null,
          child: Text(DateFormat.yMMMMEEEEd("en_US").format(firstDay)  +"\n"+ DateFormat.yMMMMEEEEd("en_US").format(lastDay),
            style: widget.headerScrollStyle.titleTextStyle,
            textAlign: widget.headerScrollStyle.centerHeaderTitle
                ? TextAlign.center
                : TextAlign.start,
          ),
        ),
      ),
      CustomIconButtonOur(
        icon: widget.headerScrollStyle.rightChevronIcon,
        onTap: selectNextMonth,
        margin: widget.headerScrollStyle.leftChevronMargin,
        padding: widget.headerScrollStyle.leftChevronPadding,
      ),
    ];

    return Container(
      decoration: widget.headerScrollStyle.decoration,
      margin: widget.headerScrollStyle.headerMargin,
      padding: widget.headerScrollStyle.headerPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );

  }

  Widget symptomsWidget() {
    return Column(
      children: [
      PieChartSample2(overviewStore: overviewStore),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                  dateStore.timeSelected==TemporalTime.Day? OverviewSingleSymptomDay(symptomId: overviewStore.totalOccurrenceSymptom.keys.elementAt(index),overviewStore: overviewStore):
                                  dateStore.timeSelected==TemporalTime.Week? OverviewSingleSymptomWeek(symptomId: overviewStore.totalOccurrenceSymptom.keys.elementAt(index),overviewStore: overviewStore):
                                  dateStore.timeSelected==TemporalTime.Month? OverviewSingleSymptomMonth(symptomId: overviewStore.totalOccurrenceSymptom.keys.elementAt(index),overviewStore: overviewStore): null
                                  ))
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
    ],
    );
  }

}

class Indicator2 extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator2({
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

        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        ),
        const SizedBox(
          width: 4,
        ),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
      ],
    );
  }
}

class PieChartSample2 extends StatefulWidget {

  final OverviewStore overviewStore;
  PieChartSample2({@required this.overviewStore});


  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex;


  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SymptomStore symptomStore = Provider.of<SymptomStore>(context);
    return Observer(builder: (_) => Card(

        elevation: 1,
        margin: EdgeInsets.all(4),
        child: Column(children: [
          ListTile(
            title: const Text('% Symptoms experienced'),
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


                    sections: widget.overviewStore.totalOccurrenceSymptom.length>0 ? showingSections(widget.overviewStore, symptomStore) : 0,
                  ),
                )),
              ),
        Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children:[
                for(String symptomId in widget.overviewStore.totalOccurrenceSymptom.keys)
                  Indicator2(
                    color: symptomStore.colorSymptomsMap[symptomId],
                    text: symptomStore.getSymptomFromList(symptomId).name,
                    isSquare: true,
                  ),
              ],
            ),  const SizedBox(
              width: 28,
            ),

          ],
        ),]),
      ),
    );
  }

  List<PieChartSectionData> showingSections(OverviewStore overviewStore, SymptomStore symptomStore) {

    return List.generate(overviewStore.totalOccurrenceSymptom.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;


        return PieChartSectionData(
          color: symptomStore.colorSymptomsMap[overviewStore.totalOccurrenceSymptom.keys.elementAt(i)],
          value: overviewStore.totalNumOfSymptomList()>0 ? (overviewStore.totalOccurrenceSymptom.values.elementAt(i)/overviewStore.totalNumOfSymptomList())*100 :1,
          title: overviewStore.totalNumOfSymptomList()>0 ? '${((overviewStore.totalOccurrenceSymptom.values.elementAt(i)/overviewStore.totalNumOfSymptomList())*100).toStringAsFixed(1)}%' : '',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        );

    });
  }
}



class CustomIconButtonOur extends StatelessWidget {
  final Icon icon;
  final VoidCallback onTap;
  final EdgeInsets margin;
  final EdgeInsets padding;

  const CustomIconButtonOur({
    Key key,
    @required this.icon,
    @required this.onTap,
    this.margin,
    this.padding,
  })  : assert(icon != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100.0),
        child: Padding(
          padding: padding,
          child: icon,
        ),
      ),
    );
  }
}
