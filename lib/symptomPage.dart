import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'Database/symptom.dart';

class SymptomPage extends StatefulWidget {

  final Symptom symptom;
  DateTime date;
  SymptomPage({@required this.symptom});

  @override
  _SymptomPageState createState() => _SymptomPageState();
}

class _SymptomPageState extends State<SymptomPage> with TickerProviderStateMixin {
  var storage = FirebaseStorage.instance;
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  TabController _tabController;

  void initState() {
    super.initState();
    _tabController = getTabController();
    var store = Provider.of<SymptomStore>(context, listen: false);
    var storeDate = Provider.of<DateStore>(context, listen: false);
    widget.date = storeDate.selectedDate;
    //store.initSymptomOfDayList(widget.date);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TabController getTabController() {
    return TabController(length: 2, vsync: this);
  }



  @override
  Widget build(BuildContext context) {

    final symptomStore = Provider.of<SymptomStore>(context);
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(
        title: Text(widget.symptom.name),
        bottom: TabBar(
          tabs: [
            Tab(text:"Modify"),
            Tab(text: "Description")
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:[
          modifyWidget(widget.symptom,context, symptomStore),
          descriptionWidget(widget.symptom),
        ],
      ),
    ));
  }
}

Widget descriptionWidget(Symptom symptom){
  return Column(
    children: [
      symptom.isSymptomSelectDay ? Text(symptom.name+" is present today") : Text(symptom.name+"is not present"),
    ],
  );
}

Widget modifyWidget(Symptom symptom,BuildContext context, SymptomStore symptomStore){
  return Container(
      child:  Column(
        children: [
          Divider(height: 30),
          Text("Intensity"),
          Observer(builder: (_) =>
              Slider(
                divisions: 10,
                value:  symptom.intensity.toDouble(),
                label:  "${symptom.intensity}",
                min: 0,
                max: 10,
                onChanged: (val) {
                  symptom.intensity = val.toInt()  ;
                },
              )),
        ],
      ));

}
