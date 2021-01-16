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
  DateTime date;

  OverviewStore overviewStore;
  DateStore dateStore;

  void initState() {
    super.initState();
    _tabController = getTabController();
    dateStore = Provider.of<DateStore>(context, listen: false);
    date = dateStore.calendarSelectedDate;
    widget.symptom.intensityTemp = widget.symptom.intensity;
    widget.symptom.frequencyTemp = widget.symptom.frequency;
    widget.symptom.copyOriginalToTempMealtime();
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
    return SingleChildScrollView(child: 
      Column(
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
          descriptionText(),
          Divider(height: 30),
          symptomsText(),
        ]));
  }

  Widget descriptionText(){
    return  Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(top: 15, left: 10,right: 10, bottom: 5 ),
        width:double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), //border corner radius
          boxShadow:[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6), //color of shadow
              spreadRadius: 4, //spread radius
              blurRadius: 6, // blur radius
              offset: Offset(0, 4), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
        ),
        child: Column(
            children:[
              Text("Description",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              SizedBox(height: 10,),

              Text(widget.symptom.description,textAlign: TextAlign.justify,),
            ]
        )
    );
  }

  Widget symptomsText(){
    return  Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(top: 5, left: 10,right: 10, bottom: 5 ),
        width:double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), //border corner radius
          boxShadow:[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6), //color of shadow
              spreadRadius: 4, //spread radius
              blurRadius: 6, // blur radius
              offset: Offset(0, 4), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
        ),
        child: Column(
            children:[
              Text("Related Symptoms & Signs",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              SizedBox(height: 10,),
              Text(widget.symptom.symptoms,textAlign: TextAlign.justify),
            ]
        )
    );
  }

  Widget modifyWidget(SymptomStore symptomStore) {
    return Container(
        child: Column(
          children: [
            Divider(height: 30),
            Text("Intensity",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            Observer(builder: (_) =>
                Slider(
                  divisions: 5,
                  value: widget.symptom.intensityTemp.toDouble(),
                  label: Intensity.values[widget.symptom.intensityTemp].toString().split('.').last,
                  min: 0,
                  max: 5,
                  onChanged: (val) {
                    widget.symptom.intensityTemp = val.toInt();
                  },
                )),
            Divider(height: 30),
            Text("Frequency",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            Observer(builder: (_) =>
                Slider(
                  divisions: 5,
                  value: widget.symptom.frequencyTemp.toDouble(),
                  label: Frequency.values[widget.symptom.frequencyTemp].toString().split('.').last,
                  min: 0,
                  max: 5,
                  onChanged: (val) {
                    widget.symptom.frequencyTemp = val.toInt();
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
      if(widget.symptom.mealTimeBoolList[i].isSelected== widget.symptom.mealTimeBoolListTemp[i].isSelected){
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

  void saveTempValueToRealSymptom(){
    widget.symptom.intensity=widget.symptom.intensityTemp;
    widget.symptom.frequency=widget.symptom.frequencyTemp;
    widget.symptom.copyTempToOriginalMealTime();

  }

  buttonActivated(SymptomStore symptomStore){
    if (!widget.symptom.isSymptomSelectDay) {
      if ((widget.symptom.frequencyTemp > 0 && widget.symptom.intensityTemp > 0) &&
          widget.symptom.isPresentAtLeastOneTrue()){
        saveTempValueToRealSymptom();
        symptomStore.updateSymptom(widget.symptom, date);
        Navigator.pop(context);
      }
    } else {
      if ((widget.symptom.frequencyTemp > 0 && widget.symptom.intensityTemp > 0) &&
          widget.symptom.isPresentAtLeastOneTrue()) {
        if (widget.symptom.frequency != widget.symptom.frequencyTemp ||
            widget.symptom.intensity != widget.symptom.intensityTemp || !areMealTimeBoolListsEqual()) {
          saveTempValueToRealSymptom();
          symptomStore.updateSymptom(widget.symptom, date);
          Navigator.pop(context);

        }
      }else{
        if((widget.symptom.frequencyTemp == 0 && widget.symptom.intensityTemp == 0) &&
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
    reaction((_) => {widget.symptom.frequencyTemp, widget.symptom.intensityTemp,
      widget.symptom.mealTimeBoolListTemp.forEach((element) {
        element.isSelected;
      })}, (_) => {
      if (!widget.symptom.isSymptomSelectDay) {
        if ((widget.symptom.frequencyTemp > 0 && widget.symptom.intensityTemp > 0) &&
            widget.symptom.isPresentAtLeastOneTrue()){
          widget.symptom.isModifyButtonActive = true
        }else{ widget.symptom.isModifyButtonActive = false}
      } else
        {
          if ((widget.symptom.frequencyTemp > 0 && widget.symptom.intensityTemp > 0 &&
              widget.symptom.isPresentAtLeastOneTrue()) &&
              (widget.symptom.frequency != widget.symptom.frequencyTemp ||
                  widget.symptom.intensity != widget.symptom.intensityTemp ||
                  !areMealTimeBoolListsEqual())) {
            widget.symptom.isModifyButtonActive = true
          } else
            {
              if((widget.symptom.frequencyTemp == 0 &&
                  widget.symptom.intensityTemp == 0) &&
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
            itemCount: symptom.mealTimeBoolListTemp.length,
            itemBuilder: (BuildContext context, int index) {
              return Observer(builder: (_) =>
                  CheckboxListTile(
                    activeColor: Palette.primaryLight,
                    checkColor: Colors.black,
                    value: symptom.mealTimeBoolListTemp[index].isSelected,
                    title: new Text(MealTime.values[index]
                        .toString()
                        .split('.')
                        .last),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool val) {
                      symptom.mealTimeBoolListTemp[index].setIsSelected(val);
                    },

                  ));
            }
        )),
    );
  }
}