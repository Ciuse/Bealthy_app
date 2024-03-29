import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:Bealthy_app/Models/treatmentStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Models/dateStore.dart';
import 'package:provider/provider.dart';
import 'Login/config/palette.dart';
import 'Models/ingredientStore.dart';
import 'Models/mealTimeStore.dart';


final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

class CalendarHomePage extends StatefulWidget {

  CalendarHomePage() : super();

  @override
  _CalendarHomePageState createState() => _CalendarHomePageState();
}

class _CalendarHomePageState extends State<CalendarHomePage> with TickerProviderStateMixin {
  ReactionDisposer reactionCalendar;
  AnimationController _animationController;
  CalendarController _calendarController;
  DateStore dateStore;
  DateTime dateNormalized;
  @override
  void initState() {
    super.initState();
    dateStore = Provider.of<DateStore>(context, listen: false);

    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    reactionCalendar=reactToDataChange();
    waitIllnesses();
  }

  Future<void> waitIllnesses() async{

   await dateStore.initIllnesses();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    reactionCalendar.reaction.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    dateStore.calendarSelectedDate = day;
  }

  void _getNewSymptomAndDish(DateTime day) {
    context.read<MealTimeStore>().initDishesOfMealTimeList(day);
    context.read<SymptomStore>().initSymptomDay(day);
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {

  }

  ReactionDisposer reactToDataChange(){
    return reaction((_) => dateStore.calendarSelectedDate, (value) => {
      dateNormalized=DateTime.utc(value.year, value.month, value.day, 12),

          setState((){
            _calendarController.setSelectedDay(dateNormalized, isProgrammatic: false);
          }),
          _getNewSymptomAndDish(dateNormalized),

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Palette.bealthyColorScheme.primaryVariant, width: 2.5,style: BorderStyle.solid)
      ),
      child: Observer(builder: (_) =>_buildTableCalendarWithBuilders()),
    );
  }


  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {

    return TableCalendar(
      rowHeight: MediaQuery.of(context).orientation==Orientation.portrait?40:45,
      locale: 'en_US',
      calendarController: _calendarController,
      events: dateStore.illnesses,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        outsideHolidayStyle: TextStyle().copyWith(color: Colors.grey[500]),
        outsideWeekendStyle: TextStyle().copyWith(color: Colors.grey[500]),
        weekendStyle: TextStyle().copyWith(color: Colors.black),
        holidayStyle: TextStyle().copyWith(color: Colors.black),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle().copyWith(fontWeight:FontWeight.bold, color: Colors.black),
        weekendStyle: TextStyle().copyWith(fontWeight:FontWeight.bold, color: Colors.black),
      ),
      headerStyle: HeaderStyle(
        headerMargin: EdgeInsets.symmetric(vertical: 0,horizontal: 8),
        headerPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 8),
        leftChevronMargin: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
        leftChevronIcon :const Icon(Icons.chevron_left, color: Palette.secondaryLight),
        rightChevronIcon :const Icon(Icons.chevron_right, color: Palette.secondaryLight),
        rightChevronMargin: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
        centerHeaderTitle: true,
        formatButtonVisible: false,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      builders: CalendarBuilders(
        outsideDayBuilder: (context, date, _) {
          return Container(
            alignment: Alignment.center,
            margin:  EdgeInsets.symmetric(vertical: 1.5,horizontal: 1.5),
            child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0,color: Colors.grey[500])
            ),
          );
        },
        outsideWeekendDayBuilder: (context, date, _) {
          return Container(
            alignment: Alignment.center,
            margin:  EdgeInsets.symmetric(vertical: 1.5,horizontal: 1.5),
            child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0,color: Colors.grey[500])
            ),
          );
        },
        dayBuilder: (context, date, _) {
          return Container(
            alignment: Alignment.center,
            margin:  EdgeInsets.symmetric(vertical: 1.5,horizontal: 1.5),
            decoration: new BoxDecoration(
              border: Border.all(color:Colors.black12),
              shape: BoxShape.rectangle,),
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0)
            ),
          );
        },
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 1.5,horizontal: 1.5),
               decoration: new BoxDecoration(
                   color: Palette.bealthyColorScheme.primary,
                   shape: BoxShape.rectangle,
                 ),
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0, color: Palette.bealthyColorScheme.onPrimary),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            alignment: Alignment.center,
            margin:  EdgeInsets.symmetric(vertical: 1.5,horizontal: 1.5),
            decoration: new BoxDecoration(
              border: Border.all(color:Palette.bealthyColorScheme.secondaryVariant),
              shape: BoxShape.rectangle,),
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0, color: Palette.bealthyColorScheme.secondaryVariant),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (dateStore.illnesses.isNotEmpty) {
            children.add(
              Positioned(
                right: 3,
                bottom: 2.5,
                child: _buildIllnessesMarker(date),
              ),
            );
          }



          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,

    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date) ? Colors.brown[300] : Palette.secondaryDark,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildIllnessesMarker(DateTime date) {

    return Icon(
      Icons.sick_outlined,
      size: 16.0,
      color: _calendarController.isSelected(date)
          ? Palette.bealthyColorScheme.onPrimary
          : _calendarController.isToday(date) ? Palette.bealthyColorScheme.secondaryVariant : Colors.black,
    );
  }
}
