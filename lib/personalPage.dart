import 'package:flutter/material.dart';




class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Personal info', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        body: Center(
            child: Column(
                children: [
                ]
            )
        )
    );
  }

}