import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/overviewStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'Database/symptom.dart';
import 'Login/config/palette.dart';

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
  int intensityFromDb;
  int frequencyFromDb;
  DateTime date;
  var mealTimeBoolListFromDb = new List<bool>();
  OverviewStore overviewStore;
  DateStore dateStore;

  void initState() {
    super.initState();
    _tabController = getTabController();
    dateStore = Provider.of<DateStore>(context, listen: false);
    date = dateStore.calendarSelectedDate;
    intensityFromDb = widget.symptom.intensity;
    frequencyFromDb = widget.symptom.frequency;
    widget.symptom.mealTimeBoolList.forEach((element) {
      mealTimeBoolListFromDb.add(element.isSelected);
    });
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
    reactButtonEnabled();
    final symptomStore = Provider.of<SymptomStore>(context);
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(
        title: Text(widget.symptom.name),
        bottom: TabBar(
          tabs: [
            Tab(text: "Modify"),
            Tab(text: "Description")
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          modifyWidget(symptomStore),
          descriptionWidget(),
        ],
      ),
    ));
  }


  Widget descriptionWidget() {
    return Column(
        children: [
          Container(
              width: 50,
              height: 50,
              child:  ClipOval(
                  child: Image(
                    image: AssetImage("images/Symptoms/" +widget.symptom.id+".png" ),
                  )
              )),
          Divider(height: 30),
          Text("Description",style: TextStyle(fontWeight: FontWeight.bold),),
        ]);
  }

  Widget modifyWidget(SymptomStore symptomStore) {
    return Container(
        child: Column(
          children: [
            Divider(height: 30),
            Text("Intensity",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            Observer(builder: (_) =>
                Slider(
                  divisions: 10,
                  value: widget.symptom.intensity.toDouble(),
                  label: "${widget.symptom.intensity}",
                  min: 0,
                  max: 10,
                  onChanged: (val) {
                    widget.symptom.intensity = val.toInt();
                  },
                )),
            Divider(height: 30),
            Text("Frequency",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            Observer(builder: (_) =>
                Slider(
                  divisions: 10,
                  value: widget.symptom.frequency.toDouble(),
                  label: "${widget.symptom.frequency}",
                  min: 0,
                  max: 10,
                  onChanged: (val) {
                    widget.symptom.frequency = val.toInt();
                  },
                )),
            Divider(height: 30),
            Text("When did the symptom occur?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            Divider(height: 30),
            mealTimeList(widget.symptom),
            Divider(height: 30),
        Observer(builder: (_) =>  Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: !widget.symptom.isModifyButtonActive?  null :  () => buttonActivated(symptomStore),
                child: Text('Save'),
              )
            ))
          ],
        ));
  }



  bool areMealTimeBoolListsEqual(){
    int count = 0;
    for(int i = 0; i<MealTime.values.length; i++){
      if(widget.symptom.mealTimeBoolList[i].isSelected== mealTimeBoolListFromDb[i]){
        count = count + 1;
      }
    }
    if(count == MealTime.values.length){
      return true;
    } else {return false;}

  }

  List<String> getMealTimeName() {
    List<String> listToReturn = new List<String>();
    MealTime.values.forEach((element) {
      listToReturn.add(element
          .toString()
          .split('.')
          .last);
    });
    return listToReturn;
  }


  buttonActivated(SymptomStore symptomStore){
    if (!widget.symptom.isSymptomSelectDay) {
      if ((widget.symptom.frequency > 0 && widget.symptom.intensity > 0) &&
          widget.symptom.isPresentAtLeastOneTrue()){
        symptomStore.updateSymptom(widget.symptom, date);
        Navigator.pop(context);
      }
    } else {
      if ((widget.symptom.frequency > 0 && widget.symptom.intensity > 0) &&
          widget.symptom.isPresentAtLeastOneTrue()) {
        if (widget.symptom.frequency != frequencyFromDb ||
            widget.symptom.intensity != intensityFromDb || !areMealTimeBoolListsEqual()) {
          symptomStore.updateSymptom(widget.symptom, date);

          Navigator.pop(context);
        }
      }else{
        if((widget.symptom.frequency == 0 && widget.symptom.intensity == 0) &&
            !widget.symptom.isPresentAtLeastOneTrue()){
          return showDialog(
              context: context,
              builder: (_) =>  new AlertDialog(
                title: new Text(widget.symptom.name),
                content: new Text("Are you sure to remove it?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Remove it!'),
                    onPressed: () {
                      symptomStore.removeSymptomOfSpecificDay( widget.symptom, date)
                          .then((value) => Navigator.of(context).popUntil((route) => route.isFirst));
                    },
                  )
                ],
              ));
        }
      }
    }
  }

  void reactButtonEnabled(){
    reaction((_) => {widget.symptom.frequency, widget.symptom.intensity,
      widget.symptom.mealTimeBoolList.forEach((element) {
        element.isSelected;
      })}, (_) => {
      if (!widget.symptom.isSymptomSelectDay) {
        if ((widget.symptom.frequency > 0 && widget.symptom.intensity > 0) &&
            widget.symptom.isPresentAtLeastOneTrue()){
          widget.symptom.isModifyButtonActive = true
        }else{ widget.symptom.isModifyButtonActive = false}
      } else
        {
          if ((widget.symptom.frequency > 0 && widget.symptom.intensity > 0 &&
              widget.symptom.isPresentAtLeastOneTrue()) &&
              (widget.symptom.frequency != frequencyFromDb ||
                  widget.symptom.intensity != intensityFromDb ||
                  !areMealTimeBoolListsEqual())) {
            widget.symptom.isModifyButtonActive = true
          } else
            {
              if((widget.symptom.frequency == 0 &&
                  widget.symptom.intensity == 0) &&
                  !widget.symptom.isPresentAtLeastOneTrue()){
                widget.symptom.isModifyButtonActive = true
              }else{
                widget.symptom.isModifyButtonActive = false
              }
            }
        }

    });
  }

  Widget mealTimeList(Symptom symptom) {
    return Expanded(child:
    Observer(builder: (_) =>
        ListView.builder(
            itemCount: symptom.mealTimeBoolList.length,
            itemBuilder: (BuildContext context, int index) {
              return Observer(builder: (_) =>
                  CheckboxListTile(
                    activeColor: Palette.primaryLight,
                    checkColor: Colors.black,
                    value: symptom.mealTimeBoolList[index].isSelected,
                    title: new Text(MealTime.values[index]
                        .toString()
                        .split('.')
                        .last),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool val) {
                      symptom.mealTimeBoolList[index].setIsSelected(val);
                    },

                  ));
            }
        )),
    );
  }
}