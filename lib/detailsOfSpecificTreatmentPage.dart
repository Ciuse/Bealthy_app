import 'package:Bealthy_app/Database/treatment.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        title: Text("Details:"),
      ),
      body: SingleChildScrollView(child: Container(child:
      Column(
          children: [
            treatmentDescriptionWidget(),
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

  Widget descriptionWidget(){
    return  Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.description),
            title: Text("Description of this treatment: "),
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