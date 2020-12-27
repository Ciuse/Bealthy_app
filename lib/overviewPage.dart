import 'dart:math';

import 'package:Bealthy_app/Models/overviewStore.dart';
import 'package:Bealthy_app/headerScrollStyle.dart';
import 'package:Bealthy_app/ingredientOverview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'Database/enumerators.dart';
import 'Models/dateStore.dart';
import 'Models/symptomStore.dart';




class OverviewPage extends StatefulWidget {
  final headerScrollStyle = const HeaderScrollStyle();
  final formatAnimation = FormatAnimation.slide;

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> with TickerProviderStateMixin {
  TabController _tabController;
  DateStore dateStore;
  OverviewStore overviewStore;
  double animationStartPos=0;
  ReactionDisposer reaction1;

  void initState() {
    super.initState();

    _tabController = getTabController();
    dateStore = Provider.of<DateStore>(context, listen: false);
    dateStore.overviewSelectedDate=DateTime.now();
    overviewStore = Provider.of<OverviewStore>(context, listen: false);
    reaction1=reactToDataChange();

  }


  @override
  void dispose() {
    _tabController.dispose();
    reaction1.reaction.dispose();
    super.dispose();
  }

  TabController getTabController() {
    return TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Observer(builder: (_) => _buildHeader(dateStore.overviewSelectedDate)),
    Observer(builder: (_) =>  Expanded(child: _buildContent()))
              //Add this to give height
          ],
      )
    ));
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
            child: Observer(builder: (_) => overviewContent())
        ),
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
            child: Observer(builder: (_) => overviewContent())
        ),
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
        key: ValueKey(dateStore.overviewSelectedDate),
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
        overviewStore.symptomsPresentMap.length>0? symptomsWidget() : noSymptomsWidget(),
        IngredientOverview(),
      ],
    );
  }
  Widget noSymptomsWidget() {
    return Container(child: Text("No symptoms present"));
  }

  void selectPrevious() {
    animationStartPos= -1.2;
    context.read<DateStore>().previousDayOverview();
  }

  void selectNext() {
    animationStartPos= 1.2;
    context.read<DateStore>().nextDayOverview();
  }
  ReactionDisposer reactToDataChange(){
    return reaction((changeDay) => dateStore.overviewSelectedDate, (value) => {
      overviewStore.initializeOverviewList(dateStore),
    });
  }

  Widget _buildHeader(DateTime day) {
    final children = [
      _CustomIconButton(
        icon: widget.headerScrollStyle.leftChevronIcon,
        onTap: selectPrevious,
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
      _CustomIconButton(
        icon: widget.headerScrollStyle.rightChevronIcon,
        onTap: selectNext,
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
      Divider(height: 30),
      PieChartSample2(),
      SizedBox( // Horizontal ListView
          height: 80,
          child: Observer(builder: (_) =>
              ListView.builder(
                itemCount: overviewStore.symptomsPresentMap.length,
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
                                  overviewStore.symptomsPresentMap.keys.elementAt(index) + ".png"),
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
                      sections: overviewStore.symptomsPresentMap.length>0 ? showingSections(colorsOfChart,overviewStore, symptomStore) : 0,
                  ),
                )),
              ),
            ),
        Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                for(var symptomId in overviewStore.symptomsPresentMap.keys)
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

    return List.generate(overviewStore.symptomsPresentMap.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;


        return PieChartSectionData(
          color: colorsOfChart[symptomStore.getIndexFromSymptomsList(symptomStore.getSymptomFromList(overviewStore.symptomsPresentMap.keys.elementAt(i)), symptomStore.symptomList)],
          value: overviewStore.totalNumOfSymptomList()>0 ? (overviewStore.symptomsPresentMap.values.elementAt(i)/overviewStore.totalNumOfSymptomList())*100 :1,
          title: overviewStore.totalNumOfSymptomList()>0 ? '${((overviewStore.symptomsPresentMap.values.elementAt(i)/overviewStore.totalNumOfSymptomList())*100).toStringAsFixed(1)}%' : '',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        );

    });
  }
}



class _CustomIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onTap;
  final EdgeInsets margin;
  final EdgeInsets padding;

  const _CustomIconButton({
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