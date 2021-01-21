import 'dart:math' as math;
import 'package:Bealthy_app/Database/scrollControllerStore.dart';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Login/config/palette.dart';

import 'calendar.dart';
import 'headerScrollStyle.dart';
import 'listDishesOfDay.dart';
import 'overviewPage.dart';
import 'symptomsBar.dart';

class HomePageWidget extends StatefulWidget {
  final headerScrollStyle = const HeaderScrollStyle();

  HomePageWidget();
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}
class _HomePageWidgetState extends State<HomePageWidget>{
  ScrollControllerStore scrollControllerStore;
  DateStore dateStore;

  @override
  void dispose() {
    scrollControllerStore.scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dateStore = Provider.of<DateStore>(context, listen: false);
    scrollControllerStore = new ScrollControllerStore();
    scrollControllerStore.scrollController.addListener(() {
      if (scrollControllerStore.scrollController.hasClients) {
        scrollControllerStore.scale = scrollControllerStore.scrollController.offset / 300;
        scrollControllerStore.offset= scrollControllerStore.scrollController.offset;
        scrollControllerStore.scale = scrollControllerStore.scale * 2;
        if (scrollControllerStore.scale > 1) {
          scrollControllerStore.scale = 1.0;
        }
      } else {
        scrollControllerStore.scale = 0.0;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final dateModel = Provider.of<DateStore>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bealthy'),
        actions: <Widget>[
          new Padding(
            padding: EdgeInsets.all(5.0),
            child: Observer(builder: (_) => _buildActions()),
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(8),
          child:
              Stack(children: [
          CustomScrollView(
            controller: scrollControllerStore.scrollController,
            slivers: <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
                expandedHeight: 282,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  stretchModes: [StretchMode.blurBackground],
                  background: CalendarHomePage(),

                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  SymptomsBar(day: dateModel.calendarSelectedDate),
                ]),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  ListDishesOfDay(day: dateModel.calendarSelectedDate),
                  Container(height: MediaQuery.of(context).size.height-680,),

                ]),
              ),

              // Observer(builder: (_) => SliverPersistentHeader(
              //   pinned: true,
              //   delegate: _SliverAppBarDelegate(
              //     minHeight: scrollControllerStore.offset>240?70.0:0,
              //     maxHeight: scrollControllerStore.offset>240?70.0:0,
              //     child: scrollControllerStore.offset>240?_buildHeaderDay(dateStore.calendarSelectedDate):Container(),
              //
              //   ),
              // )),
            ],
          ),Observer(
                    builder: (_) =>scrollControllerStore.offset>210?
                    Positioned(
                        top: 0,
                        width: MediaQuery.of(context).size.width-16,
                        height:70,
                        child:_buildHeaderDay(dateStore.calendarSelectedDate)):Container())],)),

    );
  }
  Widget _buildHeaderDay(DateTime day) {
    final children = [
      CustomIconButtonOur(
        icon: Icon(Icons.chevron_left,size: 30,color: Palette.bealthyColorScheme.secondary,),
        onTap: ()=>dateStore.calendarSelectedDate=dateStore.calendarSelectedDate.subtract(Duration(days: 1)),
        margin: EdgeInsets.only(top:6,bottom: 6,left: 5,right: 5),
        padding: EdgeInsets.only(top:6,bottom: 6,left: 9,right: 0),
      ),
      Expanded(
        child: GestureDetector(
          onTap: null,
          onLongPress: null,
          child: Text(DateFormat.yMMMMEEEEd("en_US").format(day),
            style: TextStyle(fontSize: 18),
            textAlign: widget.headerScrollStyle.centerHeaderTitle
                ? TextAlign.center
                : TextAlign.start,
          ),
        ),
      ),
      CustomIconButtonOur(
        icon: Icon(Icons.chevron_right,size: 30,color: Palette.bealthyColorScheme.secondary,),
        onTap: ()=>dateStore.calendarSelectedDate=dateStore.calendarSelectedDate.add(Duration(days: 1)),
        margin: EdgeInsets.only(top:6,bottom: 6,left: 5,right: 5),
        padding: EdgeInsets.only(top:6,bottom: 6,left: 0,right: 9),
      ),
    ];

    return Container(
      decoration: widget.headerScrollStyle.decoration,
      margin: EdgeInsets.all(0),
      padding: widget.headerScrollStyle.headerPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );

  }

  Widget _buildActions() {
    Widget profile = new GestureDetector(
      child: new Container(
        height: 45.0,
        width: 45.0,
        child:IconButton(
          onPressed: () => scrollControllerStore.scrollController.animateTo(0.0, duration:new Duration(milliseconds: 700), curve: Curves.easeInQuad),
          icon: Icon(Icons.calendar_today_outlined),)
      ),
    );



    if(   scrollControllerStore.scale <0.5){
      return Container();
    }
    else{
      return new Transform(

        transform: new Matrix4.identity()..scale(scrollControllerStore.scale, scrollControllerStore.scale),
        alignment: Alignment.center,
        child: profile,
      );
    }

  }

}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });  final double minHeight;
  final double maxHeight;
  final Widget child;  @override
  double get minExtent => minHeight;  @override
  double get maxExtent => math.max(maxHeight, minHeight);  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent)
  {
    return new SizedBox.expand(child: child);
  }  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}