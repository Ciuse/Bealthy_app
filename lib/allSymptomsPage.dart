import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Database/enumerators.dart';
import 'headerScrollStyle.dart';



class AllSymptomsPage extends StatefulWidget {
  final headerScrollStyle = const HeaderScrollStyle();
  final formatAnimation = FormatAnimation.slide;


  @override
  _AllSymptomsPageState createState() => _AllSymptomsPageState();
}

class _AllSymptomsPageState extends State<AllSymptomsPage>  with SingleTickerProviderStateMixin{
  var storage = FirebaseStorage.instance;
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  DateStore dateStore;
  SymptomStore symptomStore;
  double animationStartPos=0;

  void initState() {
    super.initState();
    dateStore = Provider.of<DateStore>(context, listen: false);
    symptomStore = Provider.of<SymptomStore>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Symptoms"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Observer(builder: (_) => _buildHeader(dateStore.calendarSelectedDate)),
            Expanded(child:Observer(builder: (_) => _buildContent()),
            ),
          ],
        )

    );
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
            child:_symptomsContent()
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
            child: _symptomsContent()
        ),
      );
    }
  }

  Widget _buildHorizontalSwipeWrapper({Widget child}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
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
        key: ValueKey(dateStore.calendarSelectedDate),
        resizeDuration: null,
        onDismissed: _onHorizontalSwipe,
        direction: DismissDirection.horizontal,
        child: child,
      ),
    );
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

  Widget _symptomsContent() {
    return
      Container(
          child:ReorderableListView(
              children: [
                for(var symptom in symptomStore.symptomList )
                  ListTile(
                    key: Key(symptom.id),
                    title: Text(symptom.name, style: TextStyle(fontSize: 22.0)),
                    leading: ImageIcon(
                      AssetImage("images/" +symptomStore.symptomList[symptomStore.getIndexFromSymptomsList(symptom, symptomStore.symptomList)].id+".png" ),
                      color: symptomStore.symptomList[symptomStore.getIndexFromSymptomsList(symptom, symptomStore.symptomList)].isSymptomSelectDay ? Colors.pinkAccent : null,
                      size: 28.0,
                    ),
                  )
              ],
              onReorder: (oldIndex, newIndex) {
                symptomStore.reorderList(oldIndex, newIndex);
              }
          ));
  }

  void _onHorizontalSwipe(DismissDirection direction) {
    if (direction == DismissDirection.startToEnd) {
      // Swipe right
      selectPrevious();
    } else {
      // Swipe left
      selectNext();
    }
  }

  void selectPrevious() {
    animationStartPos= -1.2;
    context.read<DateStore>().previousDayCalendar();
  }

  void selectNext() {
    animationStartPos= 1.2;

    context.read<DateStore>().nextDayCalendar();
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

