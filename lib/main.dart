import 'package:flutter/material.dart';
import 'homePageWidget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'Models/date_model.dart';
import 'Models/foodStore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting().then((_) => runApp(
      MultiProvider(providers: [
        Provider<DateModel>(
          create: (_) => DateModel(),
        ),
        Provider<FoodStore>(
          create: (_) => FoodStore(),
        )
      ], child:MyApp())));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static const String _title = 'Bealthy';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: HomePage(),
    );
  }
}


/// This is the stateful widget that the main application instantiates.
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// This is the private State class that goes with HomePage.
class _MyHomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    HomePageWidget(Colors.red),
    HomePageWidget(Colors.green),
    HomePageWidget(Colors.yellow),
    HomePageWidget(Colors.blue),

  ];

  void _bottomBarOnTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bealthy'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_sharp),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            label: 'Treatment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Treatment',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blue,
        onTap: _bottomBarOnTapped,
      ),
    );
  }
}

