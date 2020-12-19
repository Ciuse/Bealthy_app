import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Database/symptom.dart';

class SymptomPage extends StatefulWidget {

  final Symptom symptom;
  SymptomPage({@required this.symptom});

  @override
  _SymptomPageState createState() => _SymptomPageState();
}

class _SymptomPageState extends State<SymptomPage> with TickerProviderStateMixin {
  var storage = FirebaseStorage.instance;
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  TabController _tabController;
  static double _lowerValue = 0.0;
  static double _upperValue = 10.0;

  RangeValues values = RangeValues(_lowerValue, _upperValue);

  void initState() {
    super.initState();
    _tabController = getTabController();
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
          modifyWidget(context, _lowerValue, _upperValue, values),
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

Widget modifyWidget(BuildContext context, double lowerValue, double upperValue, RangeValues values){
    return Column(
      children: [
        Divider(height: 30),
        Text("Intensity"),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 10,
            overlayColor: Colors.transparent,
          ),
          child: RangeSlider(
            activeColor: Colors.transparent,
            inactiveColor: Colors.black87,
            divisions: 5,
            labels: RangeLabels(values.start.toString(), values.end.toString()),
            min: lowerValue,
            max: upperValue,
            values: values,
            onChanged: (val) {
                values = val;
            },
          ),
        )
      ],
    );
  }
