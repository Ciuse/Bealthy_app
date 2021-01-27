import 'package:Bealthy_app/Database/symptomOverviewGraphStore.dart';
import 'package:Bealthy_app/treatmentPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';

import 'Login/config/palette.dart';
import 'Login/screens/splash.dart';
import 'Models/barCodeScannerStore.dart';
import 'Models/dateStore.dart';
import 'Models/foodStore.dart';
import 'Models/ingredientStore.dart';
import 'Models/mealTimeStore.dart';
import 'Models/symptomStore.dart';
import 'Models/treatmentStore.dart';
import 'Models/userStore.dart';
import 'homePage.dart';
import 'overviewPage.dart';
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
        Provider<UserStore>(
          create: (_) => UserStore(),
        ),
        Provider<SymptomOverviewGraphStore>(
          create: (_) => SymptomOverviewGraphStore(),
        ),
        Provider<TreatmentStore>(
          create: (_) => TreatmentStore(),
        ),
        Provider<BarCodeScannerStore>(
          create: (_) => BarCodeScannerStore(),
        ),
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
              theme: ThemeData.from(colorScheme: Palette.bealthyColorScheme,
               textTheme: TextTheme(

                headline1: GoogleFonts.roboto(
                    fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
                headline2: GoogleFonts.roboto(
                    fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
                headline3: GoogleFonts.roboto(fontSize: 48, fontWeight: FontWeight.w400),
                headline4: GoogleFonts.roboto(
                    fontSize: 70, fontWeight: FontWeight.w400, letterSpacing: 0.3),
                headline5: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
                headline6: GoogleFonts.roboto(
                    fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 0.15),
                subtitle1: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.w400, letterSpacing: 0.15),
                subtitle2: GoogleFonts.roboto(
                    fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
                bodyText1: GoogleFonts.roboto(
                    fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 0.5, height: 1.3),
                bodyText2: GoogleFonts.roboto(
                    fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.3, height: 1.3),
                button: GoogleFonts.roboto(
                    fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
                caption: GoogleFonts.roboto(
                    fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
                overline: GoogleFonts.roboto(
                    fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
              ),
              ).copyWith(
                  primaryTextTheme: TextTheme(
                    headline6: GoogleFonts.roboto(fontSize: 21, fontWeight: FontWeight.w400, letterSpacing: 0.5),

                  ),
                  visualDensity: VisualDensity.adaptivePlatformDensity,

                  buttonBarTheme: ButtonBarThemeData(
                    alignment: MainAxisAlignment.end,
                  ),
                  iconTheme: IconThemeData(
                    color: Color(0xff005f64),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      textStyle: TextStyle(
                        fontSize: 17,
                      )
                    )
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                          textStyle: TextStyle(
                            fontSize: 17,
                          )
                      )
                  ),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: Colors.white,
                    unselectedItemColor: Palette.bealthyColorScheme.onBackground,
                    selectedItemColor: Palette.bealthyColorScheme.primary,
                    type: BottomNavigationBarType.shifting
                  ),

                  tabBarTheme: TabBarTheme(
                    labelPadding: EdgeInsets.all(0),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white),
                    labelColor: Colors.black,
                    unselectedLabelColor:Colors.black ,

                    unselectedLabelStyle:GoogleFonts.roboto(
                        fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.25, height: 1),
                    labelStyle: GoogleFonts.roboto(
                        fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 0.25, height: 1),)
              ),

              title: _title,
              home: LitAuthState(
                authenticated: HomePage(startingIndex: 0),
                unauthenticated: SplashScreen(),
              ),
            )));
  }
}

/// This is the stateful widget that the main application instantiates.
class HomePage extends StatefulWidget {
  final int startingIndex;
  const HomePage({Key key,this.startingIndex}) : super(key: key);

  static MaterialPageRoute get route => MaterialPageRoute(
    builder: (context) => const HomePage(startingIndex: 0,),
  );

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// This is the private State class that goes with HomePage.
class _MyHomePageState extends State<HomePage> {


  DateStore dateStore;
  FoodStore foodStore;
  IngredientStore ingredientStore;
  int _selectedIndex=0;
  TreatmentStore treatmentStore;
  SymptomStore symptomStore;

  void initState() {
    super.initState();
    _selectedIndex=widget.startingIndex;
    treatmentStore=  Provider.of<TreatmentStore>(context, listen: false);
    dateStore = Provider.of<DateStore>(context, listen: false);
    foodStore = Provider.of<FoodStore>(context, listen: false);
    dateStore.initializeIllnesses=false;
    foodStore.storeCreatedYourDishInitialized = false;
    foodStore.storeFavouriteDishInitialized = false;
    foodStore.storeSearchAllDishInitialized = false;
    UserStore userStore = Provider.of<UserStore>(context, listen: false);
    userStore.initUserDb();
    symptomStore = Provider.of<SymptomStore>(context, listen: false);
    symptomStore.initStore(DateTime.now());
    ingredientStore = Provider.of<IngredientStore>(context, listen: false);
    ingredientStore.initStore();

  }

  final List<Widget> _widgetOptions = <Widget>[
    HomePageWidget(),
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

          appBar: MediaQuery.of(context).orientation==Orientation.portrait?null:AppBar(
            title: Text("Bealthy"),
          ),
          body: OrientationBuilder(
              builder: (context, orientation) {
                return orientation == Orientation.portrait
                    ?Center(
                  child: _widgetOptions.elementAt(_selectedIndex),
                ):Row(
                  children: <Widget>[
                    NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (int index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      labelType: NavigationRailLabelType.selected,
                      destinations: [
                        NavigationRailDestination(
                          icon: Icon(Icons.calendar_today_sharp),
                          label: Text('Calendar'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.stacked_bar_chart),
                          label: Text('Statistics'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.medical_services_outlined),
                          label: Text('Treatments'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.person_outline),
                          label: Text('Profile'),
                        ),
                      ],
                    ),
                    VerticalDivider(thickness: 1, width: 1),
                    // This is the main content.
                    Expanded(
                      child: Center(
                        child: _widgetOptions.elementAt(_selectedIndex),
                      ),
                    )
                  ],
                );}),
          bottomNavigationBar: MediaQuery.of(context).orientation==Orientation.portrait?BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.calendar_today_sharp),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,

                icon: Icon(Icons.stacked_bar_chart),
                label: 'Statistics',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,

                icon: Icon(Icons.medical_services_outlined),
                label: 'Treatments',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,

                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _bottomBarOnTapped,
          ):null,
        ));
  }
}

