import 'package:Bealthy_app/Models/overviewStore.dart';
import 'package:Bealthy_app/headerScrollStyle.dart';
import 'package:Bealthy_app/ingredientOverview.dart';
import 'package:Bealthy_app/overviewSingleSymptomMonth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'Database/enumerators.dart';
import 'Login/config/palette.dart';
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
    listToReturn.add(TemporalTime.Picker.toString().split('.').last);

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
        appBar: MediaQuery.of(context).orientation==Orientation.portrait?AppBar(
          title: Text("Statistics",),
          actions: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(right: 5),
                child:
                PopupMenuButton(
                  offset: Offset(0,10),
                    onSelected:  choiceAction,
                    child: Container(
                      padding: EdgeInsets.all(10),
                        child: Observer(builder: (context) =>
                            Row(children: [
                              Text(dateStore.timeSelected.toString().split('.').last,textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18,),),
                              Icon(Icons.arrow_drop_down)
                            ],)
                        )
                    ),
                    itemBuilder: (BuildContext context)
                    {
                      return temporalList.map((String choice) {
                        return PopupMenuItem<String>(
                            value: choice,
                            textStyle:TextStyle(fontSize: 17,color: Colors.black),
                            child: Text(choice),);
                      }).toList();
                    }
                ))
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: "Symptoms"),
              Tab(text: "Ingredients")
            ],
          controller: _tabController,
        ),
      ):null,
        body:Container(
            margin: MediaQuery.of(context).orientation==Orientation.portrait?
            EdgeInsets.symmetric(horizontal: 4,vertical: 8):null,
            child:
            Observer(builder: (context) =>
            dateStore.timeSelected==TemporalTime.Day? dayOverviewBuild():
            dateStore.timeSelected==TemporalTime.Week? weekOverviewBuild():
            dateStore.timeSelected==TemporalTime.Month? monthOverviewBuild():
            dateStore.timeSelected==TemporalTime.Picker? pickerOverviewBuild():Container()
            )

        ))
    );
  }

  void choiceAction(String choice){
    TemporalTime.values.forEach((element) {
        if(element.toString().split('.').last==choice){
          dateStore.timeSelected = element;
        }
      }

      );

    if(choice== TemporalTime.Day.toString().split('.').last){
      overviewStore = new OverviewStore(timeSelected: dateStore.timeSelected);

      overviewStore.initializeSymptomsMap(dateStore);
    }
    if(choice== TemporalTime.Week.toString().split('.').last){


      //calcolo il primo giorno della settimana e trovo i giorni del range
      dateStore.firstDayInWeek();

      //trovo le statistiche di quel range di giorni
      overviewStore = new OverviewStore(timeSelected: dateStore.timeSelected);
      overviewStore.initializeSymptomsMap(dateStore);
    }
    if(choice== TemporalTime.Month.toString().split('.').last){


    //calcolo il primo giorno del mese e trovo i giorni del range
      dateStore.firstDayInMonth();

      overviewStore = new OverviewStore(timeSelected: dateStore.timeSelected);
      //trovo le statistiche di quel range di giorni
      overviewStore.initializeSymptomsMap(dateStore);
    }

    if(choice==TemporalTime.Picker.toString().split('.').last){
      showDateRangePicker(
        context: context,
        currentDate: DateTime.now(),
        initialDateRange: DateTimeRange(start: DateTime.now().subtract(Duration(days: 7)), end: DateTime.now()),
        firstDate: DateTime.now().subtract(Duration(days: 200)),
        lastDate: DateTime.now().add(Duration(days: 0)),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
            ),
            child: child,
          );
        },
      ).then((value) => {
        if(value!=null)
          {
            dateStore.overviewDefaultLastDate = value.end,
            dateStore.getPickerRangeDate(value),
            overviewStore =
            new OverviewStore(timeSelected: dateStore.timeSelected),
            overviewStore.initializeSymptomsMap(dateStore)
          }
      });


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
        child: MediaQuery.of(context).orientation==Orientation.portrait?
        _buildHorizontalSwipeWrapper(child:overviewContent()):overviewContentLandscape()
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
        child: MediaQuery.of(context).orientation==Orientation.portrait?
        _buildHorizontalSwipeWrapper(child:overviewContent()):overviewContentLandscape()
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

  Widget overviewContentLandscape(){

    return Container(
        padding: EdgeInsets.only(top:16),
    child: SingleChildScrollView(
        child:ConstrainedBox(
        constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height-
        AppBar().preferredSize.height-120
    ),
    child:Container(
      padding: EdgeInsets.all(16),
        child: Observer(
          builder: (_) {
            switch (overviewStore.loadInitSymptomGraph.status) {
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
                return
                Row(children: [
                  Expanded(child: overviewStore.totalOccurrenceSymptom.length>0?
                  symptomsWidget(): Center(child:noSymptomsWidget()),),
                  SizedBox(width: 14,),
                  Expanded(child:IngredientOverview(overviewStore: overviewStore,) ,),
                ],);

              case FutureStatus.pending:
              default:
                return Center(child:CircularProgressIndicator());
            }
          },
        )))));
  }
  Widget overviewContent (){

    return TabBarView(
      controller: _tabController,
      children: [
        Container(
    margin: EdgeInsets.symmetric(vertical: 4),
            child: Observer(
              builder: (_) {
                switch (overviewStore.loadInitSymptomGraph.status) {
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
                    return
                      overviewStore.totalOccurrenceSymptom.length>0?
                      symptomsWidget(): Center(child:noSymptomsWidget());
                  case FutureStatus.pending:
                  default:
                    return Center(child:CircularProgressIndicator());
                }
              },
            )),
        Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: IngredientOverview(overviewStore: overviewStore,)
        )
      ],
    );
  }
  Widget noSymptomsWidget() {
    return Padding(
        padding: EdgeInsets.all(16),
        child:Text("There are no statistics about symptoms for this range of days",style: TextStyle(fontSize: 22),));
  }

  void selectPreviousDay() {
    animationStartPos= -1.2;
    context.read<DateStore>().previousDayOverview();
    overviewStore = new OverviewStore(timeSelected: dateStore.timeSelected);
    overviewStore.initializeSymptomsMap(dateStore);
  }

  void selectNextDay() {
    animationStartPos= 1.2;
    context.read<DateStore>().nextDayOverview();
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
    return Observer(builder: (context) =>Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MediaQuery.of(context).orientation==Orientation.portrait?
        _buildHeaderWeek(dateStore.overviewFirstDate,dateStore.overviewDefaultLastDate):
            _headerWeekLandscape(),
        Expanded(child: _buildContent())

        //Add this to give height
      ],
    ));
  }

  Widget monthOverviewBuild(){
    return Observer(builder: (_) =>Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MediaQuery.of(context).orientation==Orientation.portrait?
        _buildHeaderMonth(dateStore.overviewFirstDate,dateStore.overviewDefaultLastDate):
        _headerMonthLandscape(),
        Expanded(child: _buildContent())
        //Add this to give height
      ],
    ));
  }

  Widget pickerOverviewBuild(){
    return Observer(builder: (_) =>Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MediaQuery.of(context).orientation==Orientation.portrait?
        _buildHeaderPicker(dateStore.overviewFirstDate,dateStore.overviewDefaultLastDate):
        _headerPickerLandscape(),
        Expanded(child: _buildContent())
        //Add this to give height
      ],
    ));
  }

  Widget _headerWeekLandscape(){
    return Row(children: [
      Flexible(
          flex: 1,
          child:Container()),
      Expanded(
          flex: 4,
          child:_buildHeaderWeek
            (dateStore.overviewFirstDate,dateStore.overviewDefaultLastDate)),
      Flexible(
          flex: 1,
          child:Card(
              margin: EdgeInsets.only(left: 16,right: 16),
              elevation: 2,
              child:
              PopupMenuButton(
                  offset: Offset(0,10),
                  onSelected:  choiceAction,
                  child: Container(

                      padding: EdgeInsets.all(16),
                      child: Observer(builder: (context) =>
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text(dateStore.timeSelected.toString().split('.').last,textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18,),),
                            Icon(Icons.arrow_drop_down)
                          ],)
                      )
                  ),
                  itemBuilder: (BuildContext context)
                  {
                    return temporalList.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        textStyle:TextStyle(fontSize: 17,color: Colors.black),
                        child: Text(choice),);
                    }).toList();
                  }
              )))

    ],);
  }
  Widget _headerMonthLandscape(){
    return Row(children: [
      Flexible(
          flex: 1,
          child:Container()),
      Expanded(
          flex: 4,
          child:_buildHeaderMonth
            (dateStore.overviewFirstDate,dateStore.overviewDefaultLastDate)),
      Flexible(
          flex: 1,
          child:Card(
              margin: EdgeInsets.only(left: 16,right: 16),
              elevation: 2,
              child:
              PopupMenuButton(
                  offset: Offset(0,10),
                  onSelected:  choiceAction,
                  child: Container(

                      padding: EdgeInsets.all(16),
                      child: Observer(builder: (context) =>
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(dateStore.timeSelected.toString().split('.').last,textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18,),),
                              Icon(Icons.arrow_drop_down)
                            ],)
                      )
                  ),
                  itemBuilder: (BuildContext context)
                  {
                    return temporalList.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        textStyle:TextStyle(fontSize: 17,color: Colors.black),
                        child: Text(choice),);
                    }).toList();
                  }
              )))

    ],);
  }
  Widget _headerPickerLandscape(){
    return Row(children: [
      Flexible(
          flex: 1,
          child:Container()),
      Expanded(
          flex: 4,
          child:_buildHeaderPicker
            (dateStore.overviewFirstDate,dateStore.overviewDefaultLastDate)),
      Flexible(
          flex: 1,
          child:Card(
              margin: EdgeInsets.only(left: 16,right: 16),
              elevation: 2,
              child:
              PopupMenuButton(
                  offset: Offset(0,10),
                  onSelected:  choiceAction,
                  child: Container(

                      padding: EdgeInsets.all(16),
                      child: Observer(builder: (context) =>
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(dateStore.timeSelected.toString().split('.').last,textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18,),),
                              Icon(Icons.arrow_drop_down)
                            ],)
                      )
                  ),
                  itemBuilder: (BuildContext context)
                  {
                    return temporalList.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        textStyle:TextStyle(fontSize: 17,color: Colors.black),
                        child: Text(choice),);
                    }).toList();
                  }
              )))

    ],);
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

  Widget _buildHeaderPicker(DateTime firstDay, DateTime lastDay) {
    final children = [
      SizedBox(width: 50,),
      Expanded(
        child: GestureDetector(
          onTap: ()=>{

          },
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
        icon: Icon(Icons.today,size: 24,),
        onTap: ()=> showDateRangePicker(
          context: context,
          currentDate: DateTime.now(),
          initialDateRange: DateTimeRange(start: DateTime.now().subtract(Duration(days: 7)), end: DateTime.now()),
          firstDate: DateTime.now().subtract(Duration(days: 200)),
          lastDate: DateTime.now().add(Duration(days: 0)),
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData(
              ),
              child: child,
            );
          },
        ).then((value) => {
          if(value!=null)
            {dateStore.overviewDefaultLastDate = value.end,
              dateStore.getPickerRangeDate(value),
              overviewStore =
              new OverviewStore(timeSelected: dateStore.timeSelected),
              overviewStore.initializeSymptomsMap(dateStore)}
        }),
        margin: widget.headerScrollStyle.leftChevronMargin,
        padding: EdgeInsets.only(right:16, bottom: 12,top: 12),
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
      Container( // Horizontal ListView
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Observer(builder: (_) =>
              ListView.builder(
                itemCount: overviewStore.totalOccurrenceSymptom.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Observer(builder: (_) =>

                      Container(
                        padding: EdgeInsets.only(right: 16),
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
                                  dateStore.timeSelected==TemporalTime.Month? OverviewSingleSymptomMonth(symptomId: overviewStore.totalOccurrenceSymptom.keys.elementAt(index),overviewStore: overviewStore):
                                  dateStore.timeSelected==TemporalTime.Picker? OverviewSingleSymptomMonth(symptomId: overviewStore.totalOccurrenceSymptom.keys.elementAt(index),overviewStore: overviewStore):
                                      Container()
                                  ))
                            },
                            elevation: 4,
                            fillColor: Colors.white,
                            child: ImageIcon(
                              AssetImage("images/Symptoms/" +
                                  overviewStore.totalOccurrenceSymptom.keys.elementAt(index) + ".png"),
                              size: 28.0,
                            ),
                            constraints : const BoxConstraints(minWidth: 55.0, minHeight: 55.0),
                            shape:RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                            ),

                          )),
                  );
                },
              ),
          )),
    ],
    )
    ;
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

        elevation: 0,
        margin: EdgeInsets.all(4),
        child:  Column(
            children: [
          ListTile(
            leading: Icon(Icons.pie_chart),
            title: const Text('Symptom occurrences (%)'),
          ),
      ConstrainedBox(
          constraints: MediaQuery.of(context).orientation==Orientation.portrait?BoxConstraints(
          ):BoxConstraints(
              maxHeight: 380
          ),
          child:Row(
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
              width: 16,
            ),

          ],
        )),
    ]),
    ));
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
