import 'package:Bealthy_app/Database/treatment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'Login/config/palette.dart';
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
  var mapSymptoms;
  @override
  void initState() {

    super.initState();
    treatmentStore = Provider.of<TreatmentStore>(context, listen: false);
    dateStore = Provider.of<DateStore>(context, listen: false);
    symptomStore = Provider.of<SymptomStore>(context, listen: false);

    // if(widget.treatmentCompleted){
    //   startingDateTreatment = dateStore.setDateFromString(widget.treatment.startingDay);
    //   endingDateTreatment = dateStore.setDateFromString(widget.treatment.endingDay);
    //   rangeDaysLength = dateStore.returnDaysOfAWeekOrMonth(startingDateTreatment, endingDateTreatment).length;
    //   startingDateBeforeTreatment = startingDateTreatment.subtract(Duration(days: rangeDaysLength*2));
    //   endingDateBeforeTreatment = startingDateTreatment.subtract(Duration(days: 1));
    //   waitForMap().then((value) => treatmentStore.calculateTreatmentEndedStatistics(symptomStore));
    //
    // }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Treatment Details"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Palette.bealthyColorScheme.onError,
              ),
              onPressed: () {
                return showDialog(
                    context: context,
                    builder: (_) =>  new AlertDialog(
                        title: Text('Are you sure to remove it?'),
                        content:Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[

                            Divider(
                              height: 4,
                              thickness: 0.8,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.only(top: 30),
                        actionsPadding: EdgeInsets.only(bottom: 5,right: 5),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('CANCEL'),
                          ),
                          FlatButton(
                              child:Text('REMOVE'),
                              onPressed: () {
                                treatmentStore.removeTreatmentCreatedByUser(widget.treatment)
                                    .then((value) => Navigator.of(context).popUntil((route) => route.isFirst));
                              }
                          )]));
              }
          )
        ],
      ),
      body: SingleChildScrollView(child: Container(
          child:
          Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                treatmentDescriptionWidget(),
                Observer(builder: (_) =>treatmentValuesSymptom()),
                // widget.treatmentCompleted? Container(
                //     child:Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Text(dateStore.returnStringDate(startingDateBeforeTreatment) +"\n"+ dateStore.returnStringDate(endingDateBeforeTreatment)),
                //           SizedBox(width: 20,),
                //           Text(dateStore.returnStringDate(startingDateTreatment) +"\n"+ dateStore.returnStringDate(endingDateTreatment)),
                //         ])): Container(),
                // widget.treatmentCompleted? Container(
                //     child:Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Observer(builder: (_) =>treatmentBeforeMap()),
                //           Observer(builder: (_) =>treatmentMap()),
                //         ])): Container(),

              ]))),
    );
  }



  Widget treatmentValuesSymptom(){
    switch (symptomStore.loadTreatments.status) {
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
        if(widget.treatmentCompleted){
          mapSymptoms= symptomStore.mapTreatments[widget.treatment.id].mapSymptomPercentage;
        }
        return widget.treatmentCompleted?Observer(
            builder: (_) =>
            Container(
                padding: EdgeInsets.only(left: 4,right: 4,bottom: 4,top: 0),
                child:
                Card(
                  elevation: 0,

                    child:
                    Column(children: [
                      ListTile(
                        leading: Icon(Icons.show_chart),
                        title: Text("Statistics report",),
                      ),

                      ListView(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          children: [for(var symptom in mapSymptoms.keys )
                            (mapSymptoms[symptom].percentageSymptom!=null||
                                mapSymptoms[symptom].appeared==true
                                ||mapSymptoms[symptom].disappeared==true)?

                            Padding(
                                padding: EdgeInsets.all(6),
                                child:
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child:Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          child:ImageIcon(
                                            AssetImage("images/Symptoms/" +symptom +".png" ),
                                            size: 35.0,
                                          )),),
                                    Expanded(
                                        flex: 1,
                                        child: mapSymptoms[symptom].percentageSymptom!=null?
                                        mapSymptoms[symptom].percentageSymptom>=0? Text("Aggravation"):
                                        mapSymptoms[symptom].percentageSymptom<0?Text("Improvement"):
                                        Container():
                                        mapSymptoms[symptom].disappeared==true?
                                        Text(("Sympton not more present")):
                                        mapSymptoms[symptom].appeared==true?
                                        Text(("New symptom appeared")):Container()),
                                    Expanded(
                                        flex:1 ,
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 30),
                                            child:
                                            AspectRatio(
                                                aspectRatio: 1,
                                                child:ClipOval(
                                                    child:(Container(


                                                        color:mapSymptoms[symptom].percentageSymptom!=null?
                                                        mapSymptoms[symptom].percentageSymptom<0? Color(0xff00C853):
                                                        mapSymptoms[symptom].percentageSymptom>=0?Color(0xffDD2C00):Colors.white:
                                                        Colors.white,
                                                        child: Center(
                                                            child:
                                                            mapSymptoms[symptom].percentageSymptom!=null?Text((mapSymptoms[symptom].percentageSymptom)
                                                                .toStringAsFixed(0)+"%",style: TextStyle(color:Colors.white,fontSize: 16,fontWeight: FontWeight.w500),):Container()))))))),
                                  ],
                                )

                            ):Container(),
                          ]
                      )  ],)

                ))):Container();
      case FutureStatus.pending:
      default:
        return Center(child:CircularProgressIndicator());
    }
  }


  Widget descriptionWidget(){
    return Column(
      children: [
          ListTile(
            leading: Icon(Icons.description),
            title: Text("Description of this treatment: ",),
          ),
          Container(
            margin: const EdgeInsets.all(4.0),
            child: Text(
              widget.treatment.descriptionText,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ],

    );
  }

  Widget medicalWidget(){
    return   Column(
        children: [
          ListTile(
            leading: Icon(FontAwesomeIcons.capsules),
            title: Text("Medical information: "),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              widget.treatment.medicalInfoText,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ],
    );
  }
  Widget dietWidget(){
    return  Column(
        children: [
          ListTile(
            leading: Icon(Icons.restaurant_outlined),
            title: Text("Diet information: "),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              widget.treatment.dietInfoText,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ],
    );
  }


  Widget datesWidget(){
    return  Column(
        children: [
          ListTile(
            leading: Icon(FontAwesomeIcons.calendarDay),
            title: Text('Treatment dates: '),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Starting date: '+ widget.treatment.startingDay,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Ending date:   '+ widget.treatment.endingDay,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ],
    );
  }


  Widget treatmentDescriptionWidget(){
    return Padding(
      padding: EdgeInsets.all(4),
      child:
      Card(
          elevation: 0,

          child:Column(
          children:[Container(
              padding: EdgeInsets.only(bottom:16),
              child:
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
            ))
          ]
      )
      ),
    );
  }


}