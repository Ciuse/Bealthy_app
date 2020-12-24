import 'package:flutter/material.dart';




class TreatmentPage extends StatefulWidget {
  @override
  _TreatmentPageState createState() => _TreatmentPageState();
}

class _TreatmentPageState extends State<TreatmentPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Treatment', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
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