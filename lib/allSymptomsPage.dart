import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'Database/symptom.dart';

class AllSymptomsPage extends StatefulWidget {


  @override
  _AllSymptomsPageState createState() => _AllSymptomsPageState();
}

class _AllSymptomsPageState extends State<AllSymptomsPage> {
  var storage = FirebaseStorage.instance;
  final FirebaseFirestore fb = FirebaseFirestore.instance;


  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Symptoms"),
        ),
        body: Text("Tutti i sintomi"));
  }
}
