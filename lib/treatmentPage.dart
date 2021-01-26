import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/detailsOfSpecificTreatmentPage.dart';
import 'package:Bealthy_app/treatmentToAdd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'Models/symptomStore.dart';
import 'Models/treatmentStore.dart';




class TreatmentPage extends StatefulWidget {
  @override
  _TreatmentPageState createState() => _TreatmentPageState();
}

class _TreatmentPageState extends State<TreatmentPage>{
  TreatmentStore treatmentStore;
  SymptomStore symptomStore;
  DateStore dateStore;

  @override
  void initState() {

    super.initState();
    treatmentStore = Provider.of<TreatmentStore>(context, listen: false);
    dateStore = Provider.of<DateStore>(context, listen: false);
    symptomStore = Provider.of<SymptomStore>(context, listen: false);

    if(!treatmentStore.storeInitialized) {
      treatmentStore.storeInitialized=true;
      treatmentStore
          .initTreatmentsList(dateStore.calendarSelectedDate)
          .then((value) {
        symptomStore.initTreatments(treatmentStore.treatmentsCompletedList,
            dateStore, treatmentStore, symptomStore);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MediaQuery.of(context).orientation==Orientation.portrait?AppBar(
          title: const Text('Treatments'),
        ):null,
        body:
        Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Container(
                  padding: EdgeInsets.all(4),
                  child:Card(
                      elevation: 2,
                      child:Column(
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
                                                builder: (context) => DetailsOfSpecificTreatmentPage(treatment: treatmentStore.treatmentsInProgressList[index],treatmentCompleted: false,),
                                              ),
                                            )
                                          },
                                          title: Text(treatmentStore.treatmentsInProgressList[index].title,style: TextStyle(fontSize: 18.0)),
                                          trailing: Icon(Icons.chevron_right),
                                        ),

                                      );

                                    }

                                ))),

                          ]))
              )),
              Expanded(child: Container(
                  padding: EdgeInsets.only(bottom: 4,right: 4,left: 4),
                  child:Card(
                      elevation: 2,
                      child:Column(
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
                                              builder: (context) => DetailsOfSpecificTreatmentPage(treatment: treatmentStore.treatmentsCompletedList[index],treatmentCompleted: true,),
                                            ),
                                          )
                                        },
                                        title: Text(treatmentStore.treatmentsCompletedList[index].title,style: TextStyle(fontSize: 18.0)),
                                        trailing: Icon(Icons.chevron_right),
                                      ),

                                    );

                                  }

                              )),),
                          ]))
              )),


            ]
        ));
  }

}

