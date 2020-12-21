import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Models/dateStore.dart';
import 'package:provider/provider.dart';

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
  Map<DateTime, List> _illneses;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _illneses = {
      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    };

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    context.read<DateStore>().selectedDate = day;
    context.read<MealTimeStore>().initDishesOfMealTimeList(day);
    context.read<SymptomStore>().getSymptomsOfADay(day);
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
    context.read<SymptomStore>().getSymptomsOfADay(DateTime.now());
    context.read<MealTimeStore>().initDishesOfMealTimeList(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView(

        shrinkWrap: true,
      children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          //_buildTableCalendar(),
        const SizedBox(height: 8.0),

        _buildTableCalendarWithBuilders(),
        const SizedBox(height: 8.0),
        ],),);
  }


  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {

    return TableCalendar(

      rowHeight: 35,

      locale: 'en_US',
      calendarController: _calendarController,
      events: _illneses,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,

      availableGestures: AvailableGestures.all,
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
        headerMargin: EdgeInsets.symmetric(vertical: 2,horizontal: 5),
        headerPadding: EdgeInsets.symmetric(vertical: 1,horizontal: 1),
        leftChevronMargin: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
        centerHeaderTitle: true,
        formatButtonVisible: false,
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 1,horizontal: 10),
               decoration: new BoxDecoration(
                   color: Colors.blue[300],
                   shape: BoxShape.circle,
                 ),
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            alignment: Alignment.center,
            margin:  EdgeInsets.symmetric(vertical: 1,horizontal: 10),
            decoration: new BoxDecoration(
              border: Border.all(color:Colors.blue),
              shape: BoxShape.circle,),
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0, color: Colors.blue),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (_illneses.isNotEmpty) {
            children.add(
              Positioned(
                right: -1,
                bottom: 0,
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
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
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
      Icons.add_circle_outline,
      size: 15.0,
      color: _calendarController.isSelected(date)
          ? Colors.blue[700]
          : _calendarController.isToday(date) ? Colors.blue[700] : Colors.grey[900],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event.toString()),
          onTap: () => print('$event tapped!'),
        ),
      ))
          .toList(),
    );
  }
}
