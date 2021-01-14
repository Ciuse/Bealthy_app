import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Database/treatment.dart';
import 'Models/dateStore.dart';
import 'Models/treatmentStore.dart';


class TreatmentToAdd extends StatefulWidget {
  @override
  _TreatmentToAddState createState() => _TreatmentToAddState();
}

class _TreatmentToAddState extends State<TreatmentToAdd> {

  final titleCt = TextEditingController();
  final descriptionTextCt = TextEditingController();
  final dietInfoCt = TextEditingController();
  final medicalInfoCt = TextEditingController();
  final startingDateCt = TextEditingController();
  final endingDateCt = TextEditingController();
  DateStore dateStore;
  TreatmentStore treatmentStore;

  ScrollController _controller;
  @override
  void initState() {
    _controller = ScrollController();
    var dateStore = Provider.of<DateStore>(context, listen: false);
    treatmentStore = Provider.of<TreatmentStore>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  String fixDate(DateTime date){
    return "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
  }

  void addTreatmentToUser() {
    if (titleCt.text != "" && startingDateCt!=null && endingDateCt!=null && treatmentStore.setDateFromString(startingDateCt.text)
        .isBefore(treatmentStore.setDateFromString(endingDateCt.text))&& (DateTime.now().isBefore(treatmentStore.setDateFromString(startingDateCt.text))||
        DateTime.now().isAtSameMomentAs(treatmentStore.setDateFromString(startingDateCt.text)))) {
      Random random = new Random();
      int randomNumber = random.nextInt(100);
      Treatment treatment = new Treatment(
        id: "Treatment_"+randomNumber.toString(),
        title: titleCt.text,
        startingDay: startingDateCt.text,
        endingDay: endingDateCt.text,
        descriptionText: descriptionTextCt.text,
        dietInfoText: dietInfoCt.text,
        medicalInfoText: medicalInfoCt.text,
      );
      context.read<TreatmentStore>().addNewTreatmentCreatedByUser(treatment);
      Navigator.pop(context);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create New Treatment"),
        ),
        body: SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                TextField(
                  controller: titleCt,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  controller: descriptionTextCt,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                ),
                TextField(
                  controller: dietInfoCt,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Diet',
                  ),
                ),
                TextField(
                  controller: medicalInfoCt,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Medical Cure',
                  ),
                ),
            Row(children: [
              Expanded( flex: 4,
                  child: TextField(
                controller: startingDateCt,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Starting Date',
                ),
              )),
              Expanded(
                  flex: 1,
                  child:
              IconButton(
                  icon: Icon(Icons.calendar_today,color: Colors.black,),
                  onPressed: (){
                    showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2019, 1),
                        lastDate: DateTime(2021,12),
                        builder: (BuildContext context, Widget picker){
                          return Theme(
                            data: ThemeData.light(),
                            child: picker,);
                        })
                        .then((selectedDate) {
                      //TODO: handle selected date
                      if(selectedDate!=null){
                        startingDateCt.text = fixDate(selectedDate);
                      }
                    });
                  })),
            ],),
                Row(children: [
                  Expanded( flex: 4,
                      child: TextField(
                        controller: endingDateCt,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Ending Date',
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child:
                      IconButton(
                          icon: Icon(Icons.calendar_today,color: Colors.black,),
                          onPressed: (){
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2019, 1),
                                lastDate: DateTime(2021,12),
                                builder: (BuildContext context, Widget picker){
                                  return Theme(
                                    data: ThemeData.light(),
                                    child: picker,);
                                })
                                .then((selectedDate) {
                              //TODO: handle selected date
                              if(selectedDate!=null){
                                endingDateCt.text = fixDate(selectedDate);
                              }
                            });
                          })),
                ],),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      addTreatmentToUser();
                    },
                    child: Text('Create'),
                  ),
                ),
              ],
            )));

  }
}