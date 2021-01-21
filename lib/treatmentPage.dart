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
          title: const Text('Treatments'),
        ),
        body:
        Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Container(
                  height: 300,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 8, bottom: 8,left: 8,right: 8 ),
                  width:double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5), //border corner radius
                    boxShadow:[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4), //color of shadow
                        spreadRadius: 1.3, //spread radius
                        blurRadius: 2.5, // blur radius
                        offset: Offset(2, 4), // changes position of shadow
                        //first paramerter of offset is left-right
                        //second parameter is top to down
                      ),
                      //you can set more BoxShadow() here
                    ],
                  ),
                  child: Column(
                      children:[
                      Flexible(
                      fit:FlexFit.loose,
                      flex:2,
                      child:ListTile(
                          onTap:(){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TreatmentToAdd()),
                            );
                          } ,
                          title: Text("TREATMENTS IN PROGRESS",style: TextStyle(fontWeight:FontWeight.bold,fontSize:16,)),
                          leading: Icon(Icons.medical_services_outlined,color: Colors.black),
                          trailing: IconButton(
                            icon: Icon(Icons.add,color: Theme.of(context).accentColor,size: 30,),
                            onPressed:(){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TreatmentToAdd()),
                              );
                            } ,
                          ),
                        )),
                        Divider(
                          thickness:1,
                          height: 4,
                          color: Colors.black,
                        ),
                        Expanded(
                            flex:7,
                            child: Observer(builder: (_) =>ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                  indent: 20,
                                  endIndent: 20,
                                  height: 4,
                                  color: Colors.black,
                                ),
                            itemCount: treatmentStore.treatmentsInProgressList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 0,
                                margin: EdgeInsets.only(left: 0,right: 0),
                                child: ListTile(
                                  onTap: ()  => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsOfSpecificTreatmentPage(treatment: treatmentStore.treatmentsInProgressList[index]),
                                      ),
                                    )
                                  },
                                  title: Text(treatmentStore.treatmentsInProgressList[index].title,style: TextStyle(fontSize: 18.0)),
                                  trailing: Icon(Icons.chevron_right),
                                ),

                              );

                            }

                        ))),

                      ])
              )),
            Expanded(child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 8, bottom: 8,left: 8,right: 8 ),
                  width:double.infinity,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5), //border corner radius
                    boxShadow:[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4), //color of shadow
                        spreadRadius: 1.3, //spread radius
                        blurRadius: 2.5, // blur radius
                        offset: Offset(2, 4), // changes position of shadow
                        //first paramerter of offset is left-right
                        //second parameter is top to down
                      ),
                      //you can set more BoxShadow() here
                    ],
                  ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      Flexible(
                          fit:FlexFit.loose,
                          flex:2,
                          child:ListTile(
                            title: Text("TREATMENT ENDED",style: TextStyle(fontWeight:FontWeight.bold,fontSize:16,)),
                            leading: Icon(Icons.medical_services,color: Colors.black87),
                          )),
                      Divider(
                        thickness:1,
                        height: 4,
                        color: Colors.black,
                      ),
                      Expanded(
                        flex:7,
                        child:Observer(builder: (_) =>ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                              indent: 20,
                              endIndent: 20,
                              height: 4,
                              color: Colors.black,
                            ),
                            itemCount: treatmentStore.treatmentsCompletedList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 0,
                                margin: EdgeInsets.only(left: 0,right: 0),
                                child: ListTile(
                                  onTap: ()  => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsOfSpecificTreatmentPage(treatment: treatmentStore.treatmentsCompletedList[index]),
                                      ),
                                    )
                                  },
                                  title: Text(treatmentStore.treatmentsCompletedList[index].title,style: TextStyle(fontSize: 18.0)),
                                  trailing: Icon(Icons.chevron_right),
                                ),

                              );

                            }

                        )),),
                    ])
            )),


            ]
        ));
  }

}

