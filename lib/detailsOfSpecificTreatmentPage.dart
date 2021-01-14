import 'package:Bealthy_app/Database/treatment.dart';
import 'package:flutter/material.dart';



class DetailsOfSpecificTreatmentPage extends StatefulWidget {
  final Treatment treatment;
  DetailsOfSpecificTreatmentPage({@required this.treatment});

  @override
  _DetailsOfSpecificTreatmentPageState createState() => _DetailsOfSpecificTreatmentPageState();
}

class _DetailsOfSpecificTreatmentPageState extends State<DetailsOfSpecificTreatmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(widget.treatment.title),
    ),
    body:Container(
      alignment: Alignment.center,
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
      child: treatmentDescriptionWidget(),
    ),

    );
  }

  Widget treatmentDescriptionWidget(){
    return Column(
        children:[
          ListTile(
            title: Text("Details:",style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
            leading: Icon(Icons.fastfood_outlined,color: Colors.black),
          ),
         ListView
            (
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Text(widget.treatment.descriptionText),
                Text(widget.treatment.medicalInfoText),
                Text(widget.treatment.dietInfoText),
              ],
          )
        ]
    );
  }


}