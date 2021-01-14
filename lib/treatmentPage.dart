import 'package:Bealthy_app/detailsOfSpecificTreatmentPage.dart';
import 'package:Bealthy_app/treatmentToAdd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'Models/treatmentStore.dart';




class TreatmentPage extends StatefulWidget {
  @override
  _TreatmentPageState createState() => _TreatmentPageState();
}

class _TreatmentPageState extends State<TreatmentPage>{
  TreatmentStore treatmentStore;

  @override
  void initState() {

    super.initState();
    treatmentStore = Provider.of<TreatmentStore>(context, listen: false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treatment'),
      ),
        body: SingleChildScrollView(

      child:
      Column(
        children: [
              Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 2.2,
            margin: EdgeInsets.only(top: 15, left: 10,right: 10 ),
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
                  ListTile(
                    title: Text("Treatment in progress",style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
                    leading: Icon(Icons.medical_services_outlined,color: Colors.black),
                  ),
            Observer(builder: (_) =>ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: treatmentStore.treatmentsInProgressList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          key: Key(treatmentStore.treatmentsInProgressList[index].id),
                          background: Container(
                            margin:  EdgeInsets.symmetric(horizontal: 10 ),
                            padding: EdgeInsets.symmetric(horizontal: 10 ),
                            decoration: BoxDecoration(
                              color: Color(0xffb30000),
                              borderRadius: BorderRadius.circular(20),),
                            alignment: AlignmentDirectional.centerEnd,
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Card(
                            shape:  RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            margin: EdgeInsets.only(left: 10,right: 10, bottom: 12),
                            child: ListTile(
                              shape:  RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(15.0),
                              ) ,
                              onTap: ()  => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsOfSpecificTreatmentPage(treatment: treatmentStore.treatmentsInProgressList[index]),
                                  ),
                                )
                              },
                              title: Text(treatmentStore.treatmentsInProgressList[index].title,style: TextStyle(fontSize: 18.0)),
                            ),

                          ),
                          onDismissed: (direction){
                            treatmentStore.removeTreatmentCreatedByUser(treatmentStore.treatmentsInProgressList[index])
                                .then((value) => Navigator.of(context).popUntil((route) => route.isFirst));
                          },
                        );

                      }

                  )),
                  FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TreatmentToAdd()),
                      );
                    } ,
                  ),
                ])
        ),
               Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 15,bottom: 15, left: 10,right: 10 ),
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
                        ListTile(
                          title: Text("Treatment completed",style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
                          leading: Icon(Icons.medical_services,color: Colors.blueGrey),
                        ),
                        Observer(builder: (_) =>ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: treatmentStore.treatmentsCompletedList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Dismissible(
                                key: Key(treatmentStore.treatmentsCompletedList[index].id),
                                background: Container(
                                  margin:  EdgeInsets.symmetric(horizontal: 10 ),
                                  padding: EdgeInsets.symmetric(horizontal: 10 ),
                                  decoration: BoxDecoration(
                                    color: Color(0xffb30000),
                                    borderRadius: BorderRadius.circular(20),),
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Icon(Icons.delete, color: Colors.white),
                                ),
                                child: Card(
                                  shape:  RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.black, width: 1),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  margin: EdgeInsets.only(left: 10,right: 10, bottom: 12),
                                  child: ListTile(
                                    shape:  RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ) ,
                                    onTap: ()  => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsOfSpecificTreatmentPage(treatment: treatmentStore.treatmentsCompletedList[index]),
                                        ),
                                      )
                                    },
                                    title: Text(treatmentStore.treatmentsCompletedList[index].title,style: TextStyle(fontSize: 18.0)),
                                  ),

                                ),
                                onDismissed: (direction){
                                  treatmentStore.removeTreatmentCreatedByUser(treatmentStore.treatmentsCompletedList[index])
                                      .then((value) => Navigator.of(context).popUntil((route) => route.isFirst));
                                },
                              );

                            }

                        )),
                      ])
              ),


            ])));
  }

}

