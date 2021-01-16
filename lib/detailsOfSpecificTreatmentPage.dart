import 'package:Bealthy_app/Database/treatment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models/treatmentStore.dart';



class DetailsOfSpecificTreatmentPage extends StatefulWidget {
  final Treatment treatment;
  DetailsOfSpecificTreatmentPage({@required this.treatment});

  @override
  _DetailsOfSpecificTreatmentPageState createState() => _DetailsOfSpecificTreatmentPageState();
}

class _DetailsOfSpecificTreatmentPageState extends State<DetailsOfSpecificTreatmentPage> {
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
        title: Text(widget.treatment.title),
    ),
    body:Container(child:
    Column(
    children: [
    Container(
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

    ])),
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

  Widget textWidget(String title,String text){
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
              Text(title,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              SizedBox(height: 10,),

              Text(text,textAlign: TextAlign.justify,),
            ]
        )
    );
  }

  Widget treatmentDescriptionWidget(){
    return Column(
        children:[
          ListTile(
            title: Text("Details:",style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
            leading: Icon(Icons.medical_services,color: Colors.black),
          ),
         ListView
            (
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                widget.treatment.descriptionText!=null ? textWidget("Description of this treatment: ",widget.treatment.descriptionText) : Container(),
                widget.treatment.medicalInfoText!=null ? textWidget("Medical information: ",widget.treatment.medicalInfoText) : Container(),
                widget.treatment.dietInfoText!=null ? textWidget("Diet information: ",widget.treatment.dietInfoText) : Container(),
              ],
          )
        ]
    );
  }


}