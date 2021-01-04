import 'package:Bealthy_app/main.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Login/screens/auth/auth.dart';


class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Personal info'),
        ),
        body: Center(
            child: Column(
                children: [
                  //5
                  FlatButton(
                    child: const Text('Sign out'),
                    textColor: Colors.black,
                    onPressed: () async {
                     context.signOut();
                      Navigator.of(context).pushReplacement(AuthScreen.route);
                    },
                  )
                ]
            )
        )
    );
  }

}