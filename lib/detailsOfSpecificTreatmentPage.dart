import 'package:Bealthy_app/Database/treatment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'Models/dateStore.dart';
import 'Models/symptomStore.dart';
import 'Models/treatmentStore.dart';



class DetailsOfSpecificTreatmentPage extends StatefulWidget {
  final Treatment treatment;
  final bool treatmentCompleted;
  DetailsOfSpecificTreatmentPage({@required this.treatment,@required this.treatmentCompleted});

  @override
  _DetailsOfSpecificTreatmentPageState createState() => _DetailsOfSpecificTreatmentPageState();
}

class _DetailsOfSpecificTreatmentPageState extends State<DetailsOfSpecificTreatmentPage> {
  TreatmentStore treatmentStore;
  SymptomStore symptomStore;
  DateStore dateStore;
DateTime startingDateTreatment;
DateTime endingDateTreatment;
DateTime startingDateBeforeTreatment;
  DateTime endingDateBeforeTreatment;
int rangeDaysLength;
  @override
  void initState() {

    super.initState();
    treatmentStore = Provider.of<TreatmentStore>(context, listen: false);
    dateStore = Provider.of<DateStore>(context, listen: false);
    symptomStore = Provider.of<SymptomStore>(context, listen: false);
    if(widget.treatmentCompleted){
      startingDateTreatment = dateStore.setDateFromString(widget.treatment.startingDay);
      endingDateTreatment = dateStore.setDateFromString(widget.treatment.endingDay);
      rangeDaysLength = dateStore.returnDaysOfAWeekOrMonth(startingDateTreatment, endingDateTreatment).length;
      startingDateBeforeTreatment = startingDateTreatment.subtract(Duration(days: rangeDaysLength*2));
      endingDateBeforeTreatment = startingDateTreatment.subtract(Duration(days: 1));
      symptomStore.initBeforeTreatmentMap(dateStore.returnDaysOfAWeekOrMonth(startingDateBeforeTreatment, endingDateBeforeTreatment));
      symptomStore.initTreatmentMap(dateStore.returnDaysOfAWeekOrMonth(startingDateTreatment, endingDateTreatment));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details:"),
      ),
      body: SingleChildScrollView(child: Container(
          margin: EdgeInsets.all(8),
          height:1000,

          child:
      Column(
        mainAxisSize: MainAxisSize.min,
          children: [
            treatmentDescriptionWidget(),
            widget.treatmentCompleted? Container(
                height: 200,
                child:Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(dateStore.returnStringDate(startingDateBeforeTreatment) +"\n"+ dateStore.returnStringDate(endingDateBeforeTreatment)),
                      SizedBox(width: 20,),
                      Text(dateStore.returnStringDate(startingDateTreatment) +"\n"+ dateStore.returnStringDate(endingDateTreatment)),
                    ])): Container(),
            widget.treatmentCompleted? Container(
                height: 200,
                child:Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                Observer(builder: (_) =>treatmentBeforeMap()),
                Observer(builder: (_) =>treatmentMap()),
              ])): Container(),

          ]))),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            return showDialog(
                context: context,
                builder: (_) =>  new AlertDialog(
                  title: new Text("Treatment: "+widget.treatment.title),
                  content: new Text("Are you sure to remove it?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Remove it!'),
                      onPressed: () {

                        treatmentStore.removeTreatmentCreatedByUser(widget.treatment)
                            .then((value) => Navigator.of(context).popUntil((route) => route.isFirst));

                      },
                    )
                  ],
                ));
          },
          child: Icon(Icons.auto_delete, color: Colors.white),
          backgroundColor: Colors.redAccent
      ),
    );
  }

  Widget treatmentMap(){
    switch (symptomStore.loadTreatmentMap.status) {
      case FutureStatus.rejected:
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Oops something went wrong'),
              RaisedButton(
                child: Text('Retry'),
                onPressed: () async {
                },
              ),
            ],
          ),
        );
      case FutureStatus.fulfilled:
        return Expanded(child:ListView(
            padding: EdgeInsets.symmetric(vertical: 8),
            children: [for(var symptom in symptomStore.mapSymptomTreatment.keys )
            ListTile(
                title: Text((symptomStore.mapSymptomTreatment[symptom].severitySymptom/symptomStore.mapSymptomTreatment[symptom].occurrenceSymptom).toStringAsFixed(2)),
              subtitle:Text(symptom),
              )]
        ));
      case FutureStatus.pending:
      default:
        return Center(child:CircularProgressIndicator());
    }
  }

  Widget treatmentBeforeMap(){
    switch (symptomStore.loadBeforeTreatmentMap.status) {
      case FutureStatus.rejected:
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Oops something went wrong'),
              RaisedButton(
                child: Text('Retry'),
                onPressed: () async {
                },
              ),
            ],
          ),
        );
      case FutureStatus.fulfilled:
        return Expanded(child:ListView(
            padding: EdgeInsets.symmetric(vertical: 8),
            children: [for(var symptom in symptomStore.mapSymptomBeforeTreatment.keys )
              ListTile(
                title: Text((symptomStore.mapSymptomBeforeTreatment[symptom].severitySymptom/symptomStore.mapSymptomBeforeTreatment[symptom].occurrenceSymptom).toStringAsFixed(2)),
                subtitle:Text(symptom),
              )]
        ));
      case FutureStatus.pending:
      default:
        return Center(child:CircularProgressIndicator());
    }
  }


  Widget descriptionWidget(){
    return  Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.description),
            title: Text("Description of this treatment: ",),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.treatment.descriptionText,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }

  Widget medicalWidget(){
    return  Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(FontAwesomeIcons.capsules),
            title: Text("Medical information: "),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.treatment.medicalInfoText,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }
  Widget dietWidget(){
    return  Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.restaurant_outlined),
            title: Text("Diet information: "),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.treatment.dietInfoText,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }


  Widget datesWidget(){
    return  Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(FontAwesomeIcons.calendarDay),
            title: Text('Treatment dates: '),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Starting date: '+ widget.treatment.startingDay,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Ending date: '+ widget.treatment.endingDay,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }


  Widget treatmentDescriptionWidget(){
    return Column(
        children:[
          ListView
            (
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              datesWidget(),
              widget.treatment.descriptionText!="" ? descriptionWidget() : Container(),
              widget.treatment.medicalInfoText!="" ? medicalWidget() : Container(),
              widget.treatment.dietInfoText!="" ? dietWidget() : Container(),
            ],
          )
        ]
    );
  }


}