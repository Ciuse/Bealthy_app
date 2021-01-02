import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Database/symptomOverviewGraphStore.dart';
import 'package:Bealthy_app/treatmentPage.dart';
import 'package:move_to_background/move_to_background.dart';

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
      child:
      MaterialApp(
      theme: ThemeData(
          buttonBarTheme: ButtonBarThemeData(
            alignment: MainAxisAlignment.spaceEvenly,
          )),
      title: _title,
      home: FirstLoadingPage(),
    ));
  }
}

class FirstLoadingPage extends StatefulWidget{
  @override
  _FirstLoadingPageState createState() => _FirstLoadingPageState();

}

class _FirstLoadingPageState extends State<FirstLoadingPage> {
  @override
  Widget build(BuildContext context) {
    if(auth.currentUser!=null){
      print("A");
      return HomePage();
    }
    else{
      print("B");
      return LoginPage();
    }
  }
}

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
//5
            return FlatButton(
              child: const Text('Sign out'),
              textColor: Theme
                  .of(context)
                  .buttonColor,
              onPressed: () async {

                final User user = auth.currentUser;
                if (user == null) {
//6
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('No one has signed in.'),
                  ));
                  return;
                }
                await auth.signOut();
                final String uid = user.uid;
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(uid + ' has successfully signed out.'),
                ));
              },
            );
          })
        ],
      ),
      body: Builder(builder: (BuildContext context) {
//7
        return ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _RegisterEmailSection(),
            _EmailPasswordForm()
          ],
        );
      }),
    );
  }

}

class _RegisterEmailSection extends StatefulWidget {
  final String title = 'Registration';
  @override
  State<StatefulWidget> createState() =>
      _RegisterEmailSectionState();
}
class _RegisterEmailSectionState extends State<_RegisterEmailSection> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;

  void _register() async {
    final User user = (await
    auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
    ).user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      setState(() {
        _success = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText:
              'Password'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _register();
                  }
                },
                child: const Text('Submit'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(_success == null
                  ? ''
                  : (_success
                  ? 'Successfully registered ' + _userEmail
                  : 'Registration failed')),
            )
          ],
        ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}
class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;

  void _signInWithEmailAndPassword() async {
    final User user = (await auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )).user;

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } else {
      setState(() {
        _success = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: const Text('Test sign in with email and password'),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _signInWithEmailAndPassword();
                }
              },
              child: const Text('Submit'),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _success == null
                  ? ''
                  : (_success
                  ? 'Successfully signed in ' + _userEmail
                  : 'Sign in failed'),
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  OverviewStore overviewStore;
  DateStore dateStore;
  int _selectedIndex = 0;

  void initState() {
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

