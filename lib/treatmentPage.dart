import 'package:Bealthy_app/treatmentToAdd.dart';
import 'package:flutter/material.dart';




class TreatmentPage extends StatefulWidget {
  @override
  _TreatmentPageState createState() => _TreatmentPageState();
}

class _TreatmentPageState extends State<TreatmentPage>{

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
                      ])
              ),


            ])));
  }

}

