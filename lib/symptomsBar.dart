import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:Bealthy_app/allSymptomsPage.dart';
import 'package:Bealthy_app/symptomPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'Login/config/palette.dart';



class SymptomsBar extends StatefulWidget {
  final DateTime day;
  SymptomsBar({@required this.day});

  @override
  _SymptomsBarState createState() => _SymptomsBarState();
}

class _SymptomsBarState extends State<SymptomsBar>{

  SymptomStore symptomStore;
  @override

  void initState() {
    super.initState();
    symptomStore = Provider.of<SymptomStore>(context, listen: false);
    symptomStore.initStore(widget.day);
  }


  @override
  Widget build(BuildContext context) {

    return
      Container(
        padding: EdgeInsets.all(8),
          height: 140,
          child: Card(
          elevation: 3,
          margin: EdgeInsets.all(0),
          child:Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex:3,
                    child:ListTile(
                      title: Text("Symptoms",style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,fontStyle: FontStyle.italic)),
                      leading: Icon(Icons.sick,color: Colors.black),
                      trailing: IconButton(
                        icon: Icon(Icons.add,color: Theme.of(context).accentColor,size: 30,),
                        tooltip: 'Add a new symptom',
                        onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AllSymptomsPage()))
                        },
                      ),
                    )),
                Container(
                  child:
                  Expanded(
                      flex:5,
                      child:  Observer(
                        builder: (_) {
                          if(symptomStore.loadSymptomDay!=null){
                            switch (symptomStore.loadSymptomDay.status) {
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
                                return  Observer(builder: (_) => Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child:symptomStore.symptomListOfSpecificDay.length!=0?ListView.separated(
                                      separatorBuilder: (BuildContext context, int index) {
                                        return SizedBox(
                                          width: 16,
                                        );
                                      },
                                      itemCount: symptomStore.symptomListOfSpecificDay.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Observer(builder: (_) => Container(
                                            alignment: Alignment.center,
                                            color: Colors.transparent,
                                            child:  RawMaterialButton(
                                              constraints : const BoxConstraints(minWidth: 50.0, minHeight: 50.0),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                  side: BorderSide(color:  Palette.bealthyColorScheme.primaryVariant, width: 2, style: BorderStyle.solid)
                                              ),
                                              onPressed: () => {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => SymptomPage(symptom: symptomStore.symptomListOfSpecificDay[index])
                                                    ))
                                              },
                                              child: ImageIcon(
                                                AssetImage("images/Symptoms/" +symptomStore.symptomList[index].id+".png" ),
                                                size: 35.0,
                                              ),

                                            )),
                                        );
                                      },
                                    ):Center(child:Text("No symptoms this day",style: TextStyle(fontSize: 20),))));
                              case FutureStatus.pending:
                              default:
                                return Center(child:CircularProgressIndicator());
                            }
                          }else{
                            return Container();}
                        },
                      )
                    //

                  )),
                ]
          )));

  }
}