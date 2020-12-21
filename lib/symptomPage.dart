import 'package:Bealthy_app/Database/enumerators.dart';
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
    var storeDate = Provider.of<DateStore>(context, listen: false);
    var storeSymptom = Provider.of<SymptomStore>(context, listen: false);
    widget.date = storeDate.selectedDate;
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
    print(widget.symptom.frequency);
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
          modifyWidget(widget.symptom,context, symptomStore, widget.date ),
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

Widget modifyWidget(Symptom symptom,BuildContext context, SymptomStore symptomStore, DateTime date){
  bool check = false;
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
          Divider(height: 30),
          Text("Frequency"),
          Observer(builder: (_) =>
              Slider(
                divisions: 10,
                value:  symptom.frequency.toDouble(),
                label:  "${symptom.frequency}",
                min: 0,
                max: 10,
                onChanged: (val) {
                  symptom.frequency = val.toInt();
                },
              )),
          mealTimeList(symptom),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                modifySymptom(context,symptom, date);
              },
              child: Text('Modify Symptom'),
            ),
          ),
        ],
      ));

}
void modifySymptom(BuildContext context, Symptom symptomToUpdate, DateTime date){
  print(date);
  context.read<SymptomStore>().updateSymptom(symptomToUpdate, date);

  Navigator.pop(context);
}

List<String> getMealTimeName(){

  List<String> listToReturn = new List<String>();
  MealTime.values.forEach((element) {
    listToReturn.add(element.toString().split('.').last);
  });
  return listToReturn;
}



Widget mealTimeList(Symptom symptom){
  print(symptom.mealTimeBoolList.length);
  return Expanded(child:
      Observer(builder: (_) =>ListView.builder(
        itemCount: symptom.mealTimeBoolList.length,
        itemBuilder: (BuildContext context, int index){
          return Observer(builder: (_) =>CheckboxListTile(
                    activeColor: Colors.green,
                    checkColor: Colors.black,
                      value: symptom.mealTimeBoolList[index].isSelected,
                      title: new Text(MealTime.values[index].toString().split('.').last),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged:(bool val){
                        symptom.mealTimeBoolList[index].setIsSelected(val);
                        //symptom.setIndexMealTimeBool(val, index);
                        print( symptom.mealTimeBoolList);
                        },

          ));

        }
    )),
  );
}
