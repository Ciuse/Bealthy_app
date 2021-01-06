import 'package:Bealthy_app/Database/symptomOverviewGraphStore.dart';
import 'package:Bealthy_app/treatmentPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:move_to_background/move_to_background.dart';
import 'Login/config/palette.dart';
import 'Login/screens/splash.dart';
import 'Models/mealTimeStore.dart';
import 'Models/overviewStore.dart';
import 'Models/symptomStore.dart';
import 'overviewPage.dart';
import 'package:flutter/material.dart';
import 'homePage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'Models/dateStore.dart';
import 'Models/foodStore.dart';
import 'Models/ingredientStore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'personalPage.dart';

FirebaseAuth auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Obtain a list of the available cameras on the device.


  initializeDateFormatting().then((_) => runApp(
      MultiProvider(providers: [
        Provider<DateStore>(
          create: (_) => DateStore(),
        ),
        Provider<FoodStore>(
          create: (_) => FoodStore(),
        ),
        Provider<IngredientStore>(
          create: (_) => IngredientStore(),
        ),
        Provider<SymptomStore>(
          create: (_) => SymptomStore(),
        ),
        Provider<MealTimeStore>(
          create: (_) => MealTimeStore(),
        ),
        Provider<OverviewStore>(
          create: (_) => OverviewStore(),
        ),
        Provider<SymptomOverviewGraphStore>(
          create: (_) => SymptomOverviewGraphStore(),
        )
      ], child:MyApp())));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static const String _title = 'Bealthy';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;},
        child: LitAuthInit(
            authProviders: const AuthProviders(
              emailAndPassword: true,
              google: true,
              github: true,
              twitter: true,
            ),
            child:
      MaterialApp(
      theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.redHatDisplayTextTheme(),
            accentColor: Palette.tealDoubleMoreLight,
            appBarTheme: const AppBarTheme(
              brightness: Brightness.dark,
              color: Palette.tealDark,
            ),
          buttonBarTheme: ButtonBarThemeData(
            alignment: MainAxisAlignment.spaceEvenly,
          )),
      title: _title,
        home: LitAuthState(
          authenticated: HomePage(),
          unauthenticated: SplashScreen(),
        ),
    )));
  }
}


/// This is the stateful widget that the main application instantiates.
class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  static MaterialPageRoute get route => MaterialPageRoute(
    builder: (context) => const HomePage(),
  );

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// This is the private State class that goes with HomePage.
class _MyHomePageState extends State<HomePage> {

  OverviewStore overviewStore;
  DateStore dateStore;
  int _selectedIndex = 0;

  void initState() {
    super.initState();
   overviewStore = Provider.of<OverviewStore>(context, listen: false);
   dateStore = Provider.of<DateStore>(context, listen: false);
  }

  final List<Widget> _widgetOptions = <Widget>[
    HomePageWidget(Colors.green),
    OverviewPage(),
    TreatmentPage(),
    PersonalPage(),

  ];

  void _bottomBarOnTapped(int index) {
    setState(() {
      _selectedIndex = index;

    });


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          MoveToBackground.moveTaskToBack();
          return false;},
        child:Scaffold(
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
            label: 'Personal Info',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blue,
        onTap: _bottomBarOnTapped,
      ),
    ));
  }
}

