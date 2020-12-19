import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Database/enumerators.dart';
import 'Database/symptom.dart';
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
  double animationStartPos=0;

  void initState() {
    super.initState();
    dateStore = Provider.of<DateStore>(context, listen: false);
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
            Observer(builder: (_) => _buildHeader(dateStore.selectedDate)),
      Padding(
        padding:const EdgeInsets.only(bottom: 4.0, left: 8.0, right: 8.0),
        child: Observer(builder: (_) => _buildContent()),
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
        alignment: Alignment(0, -1),
        vsync: this,
        child: _buildHorizontalSwipeWrapper(
            child:Text(dateStore.selectedDate.toString())
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
          child: Text(dateStore.selectedDate.toString())
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
        key: ValueKey(dateStore.selectedDate),
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
    context.read<DateStore>().previousDay(dateStore.selectedDate);
  }

  void selectNext() {
    animationStartPos= 1.2;

    context.read<DateStore>().nextDay(dateStore.selectedDate);
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

