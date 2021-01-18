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
  int lastTreatmentNumber;
  final _formKey = GlobalKey<FormState>();

  ScrollController _controller;
  @override
  void initState() {
    _controller = ScrollController();
    var dateStore = Provider.of<DateStore>(context, listen: false);
    treatmentStore = Provider.of<TreatmentStore>(context, listen: false);
    getLastNumber();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getLastNumber() async {
    lastTreatmentNumber = await treatmentStore.getLastTreatmentId();
  }



  String fixDate(DateTime date){
    return "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
  }

  void addTreatmentToUser() {

      Treatment treatment = new Treatment(
        id: "Treatment_"+ lastTreatmentNumber.toString(),
        number: lastTreatmentNumber,
        title: titleCt.text,
        startingDay: startingDateCt.text,
        endingDay: endingDateCt.text,
        descriptionText: descriptionTextCt.text,
        dietInfoText: dietInfoCt.text,
        medicalInfoText: medicalInfoCt.text,
      );
      treatmentStore.addNewTreatmentCreatedByUser(treatment);
      Navigator.pop(context);


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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
                Form(
                    key: this._formKey,
                    child:
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          autovalidateMode: AutovalidateMode.disabled,
                          controller: titleCt,
                          decoration: new InputDecoration(
                            labelText: 'Name',
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(
                              ),
                            ),
                            //fillColor: Colors.green
                          ),
                          validator: (val) {
                            if(val.length==0) {
                              return "Name cannot be empty";
                            }else{
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.disabled,
                          controller: descriptionTextCt,
                          decoration: new InputDecoration(
                            labelText: 'Description',
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(
                              ),
                            ),
                            //fillColor: Colors.green
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.disabled,
                          controller: dietInfoCt,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: new InputDecoration(
                            labelText: 'Diet',
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(
                              ),
                            ),
                            //fillColor: Colors.green
                          ),
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.disabled,
                          controller: medicalInfoCt,
                          decoration: new InputDecoration(
                            labelText: 'Medical Cure',
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(
                              ),
                            ),
                            //fillColor: Colors.green
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        TextFormField(
                              onTap: (){
                                FocusScope.of(context).requestFocus(new FocusNode());
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2019, 1),
                                    lastDate: DateTime(2030,12),
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
                              },
                              autovalidateMode: AutovalidateMode.disabled,
                              controller: startingDateCt,
                              decoration: new InputDecoration(
                                labelText: "Enter Starting date of treatment",
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(
                                  ),
                                ),
                              ),
                              validator: (val) {
                                if(val.length==0) {
                                  return "Starting Date of treatment cannot be empty";
                                }else{
                                  if(treatmentStore.setDateFromString(val)!=null){
                                    return null;
                                  }else{
                                    return "Insert a valid Date of starting treatment date";
                                  }

                                }
                              },
                              keyboardType: TextInputType.datetime,
                              style: new TextStyle(
                                fontFamily: "Poppins",
                              ),
                            ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                        ),
                  TextFormField(
                              onTap: (){
                                FocusScope.of(context).requestFocus(new FocusNode());
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2019, 1),
                                    lastDate: DateTime(2030,12),
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
                              },
                              autovalidateMode: AutovalidateMode.disabled,
                              controller: endingDateCt,
                              decoration: new InputDecoration(
                                labelText: "Enter Ending date of treatment",
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(
                                  ),
                                ),
                              ),
                              validator: (val) {
                                if(val.length==0) {
                                  return "Ending Date of treatment cannot be empty";
                                }else{
                                  if(treatmentStore.setDateFromString(val)!=null && treatmentStore.setDateFromString(startingDateCt.text).isBefore(treatmentStore.setDateFromString(val))){
                                    return null;
                                  }else{
                                    return "Insert a valid Date of ending treatment date";
                                  }

                                }
                              },
                              keyboardType: TextInputType.datetime,
                              style: new TextStyle(
                                fontFamily: "Poppins",
                              ),
                            ),
                      ]))
                ),




                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (this._formKey.currentState.validate()) {
                        setState(() {
                          this._formKey.currentState.save();
                        });
                        addTreatmentToUser();
                      }

                    },
                    child: Text('Create'),
                  ),
                ),
              ],
            )));

  }
}
