import 'dart:math' as math;
import 'Login/config/palette.dart';
import 'package:Bealthy_app/Database/scrollControllerStore.dart';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/mealTimeStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'addMeal.dart';
import 'calendar.dart';
import 'listDishesOfDay.dart';
import 'symptomsBar.dart';

class HomePageWidget extends StatefulWidget {
  final Color color;

  HomePageWidget(this.color);
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}
class _HomePageWidgetState extends State<HomePageWidget>{

  ScrollControllerStore scrollControllerStore;

  @override
  void dispose() {
    scrollControllerStore.scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollControllerStore = new ScrollControllerStore();
    scrollControllerStore.scrollController.addListener(() {
      if (scrollControllerStore.scrollController.hasClients) {
        scrollControllerStore.scale = scrollControllerStore.scrollController.offset / 300;
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
      CustomScrollView(
        controller: scrollControllerStore.scrollController,
          slivers: <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              expandedHeight: 260,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                stretchModes: [StretchMode.blurBackground],
                background: CalendarHomePage(),

              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 143.0,
                maxHeight: 143.0,
                child: SymptomsBar(day: dateModel.calendarSelectedDate),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                ListDishesOfDay(day: dateModel.calendarSelectedDate),
              ]),
            )
          ],
        )),


      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showDialog(
      //         context: context,
      //         barrierColor: Colors.white10.withOpacity(0.85), // background color
      //         barrierDismissible: false, // should dialog be dismissed when tapped outside
      //         builder: (_) =>  new AlertDialog(
      //             content:GestureDetector(
      //                 behavior: HitTestBehavior.opaque,
      //                 onTap: () {
      //                   Navigator.pop(context);
      //                 },
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   children: [
      //                     Row(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       crossAxisAlignment: CrossAxisAlignment.center,
      //                       children: [
      //                         Column(
      //                           children: [
      //                             RawMaterialButton(
      //
      //                               onPressed: () {
      //                                 mealTimeStore.changeCurrentMealTime(0);
      //                                 Navigator.pop(context);
      //                                 Navigator.push(
      //                                   context,
      //                                   MaterialPageRoute(builder: (context) => AddMeal(title: mealTimeStore.selectedMealTime.toString().split('.').last)),
      //                                 );
      //                               },
      //                               elevation: 2.0,
      //                               fillColor: Colors.white,
      //                               child: Icon(
      //                                 Icons.breakfast_dining,
      //                                 size: 35.0,
      //                               ),
      //                               padding: EdgeInsets.all(15.0),
      //                               shape: CircleBorder(),
      //                             ),
      //                             Text("Breakfast",style: TextStyle(
      //                               fontSize: 25,
      //                               fontWeight: FontWeight.normal,
      //                               fontFamily: 'Open Sans',
      //                               decoration: TextDecoration.none,
      //                               letterSpacing: 1.0,
      //                               wordSpacing: 5.0,
      //                               color: Colors.black,
      //                             ),)
      //                           ],
      //                         ),
      //
      //                         Padding(padding: EdgeInsets.all(15)),
      //
      //                         Column(
      //                           children: [
      //                             RawMaterialButton(
      //
      //                               onPressed: () {
      //                                 mealTimeStore.changeCurrentMealTime(1);
      //                                 Navigator.pop(context);
      //                                 Navigator.push(
      //                                   context,
      //                                   MaterialPageRoute(builder: (context) => AddMeal(title: mealTimeStore.selectedMealTime.toString().split('.').last,)),
      //                                 );
      //                               },
      //                               elevation: 2.0,
      //                               fillColor: Colors.white,
      //
      //                               child: Icon(
      //                                 Icons.lunch_dining,
      //                                 size: 35.0,
      //                               ),
      //                               padding: EdgeInsets.all(15.0),
      //                               shape: CircleBorder(),
      //                             ),
      //                             Text("Lunch",style: TextStyle(
      //                               fontSize: 25,
      //                               fontWeight: FontWeight.normal,
      //                               fontFamily: 'Open Sans',
      //                               decoration: TextDecoration.none,
      //                               letterSpacing: 1.0,
      //                               wordSpacing: 5.0,
      //                               color: Colors.black,
      //                             ),)
      //                           ],
      //                         )],
      //                     ),
      //                     Row(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       crossAxisAlignment: CrossAxisAlignment.center,
      //                       children: [
      //                         Column(
      //                           children: [
      //                             RawMaterialButton(
      //
      //                               onPressed: () {
      //                                 mealTimeStore.changeCurrentMealTime(2);
      //                                 Navigator.pop(context);
      //                                 Navigator.push(
      //                                   context,
      //                                   MaterialPageRoute(builder: (context) => AddMeal(title: mealTimeStore.selectedMealTime.toString().split('.').last,)),
      //                                 );
      //                               },
      //                               elevation: 2.0,
      //                               fillColor: Colors.white,
      //                               child: Icon(
      //                                 Icons.fastfood_rounded,
      //                                 size: 35.0,
      //                               ),
      //                               padding: EdgeInsets.all(15.0),
      //                               shape: CircleBorder(),
      //                             ),
      //                             Text("Snack",style: TextStyle(
      //                               fontSize: 25,
      //                               fontWeight: FontWeight.normal,
      //                               fontFamily: 'Open Sans',
      //                               decoration: TextDecoration.none,
      //                               letterSpacing: 1.0,
      //                               wordSpacing: 5.0,
      //                               color: Colors.black,
      //                             ),)
      //                           ],
      //                         ),
      //
      //                         Padding(padding: EdgeInsets.all(15)),
      //
      //                         Column(
      //                           children: [
      //                             RawMaterialButton(
      //
      //                               onPressed: () {
      //                                 mealTimeStore.changeCurrentMealTime(3);
      //                                 Navigator.pop(context);
      //                                 Navigator.push(
      //                                   context,
      //                                   MaterialPageRoute(builder: (context) => AddMeal(title: mealTimeStore.selectedMealTime.toString().split('.').last)),
      //                                 );
      //                               },
      //                               elevation: 2.0,
      //                               fillColor: Colors.white,
      //
      //                               child: Icon(
      //                                 Icons.dinner_dining,
      //                                 size: 35.0,
      //                               ),
      //                               padding: EdgeInsets.all(15.0),
      //                               shape: CircleBorder(),
      //                             ),
      //                             Text("Dinner",style: TextStyle(
      //                               fontSize: 25,
      //                               fontWeight: FontWeight.normal,
      //                               fontFamily: 'Open Sans',
      //                               decoration: TextDecoration.none,
      //                               letterSpacing: 1.0,
      //                               wordSpacing: 5.0,
      //                               color: Colors.black,
      //                             ),)
      //                           ],
      //                         )],
      //                     )
      //                   ],
      //                 )
      //
      //             )
      //         )
      //
      //     );
      //     // Add your onPressed code here!
      //
      //   },
      //   child: Icon(Icons.add, color:Colors.white),
      //   backgroundColor: Palette.tealDark,
      // ),
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