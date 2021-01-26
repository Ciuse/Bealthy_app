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
  }


  @override
  Widget build(BuildContext context) {

    return
      Container(
        height: 130,
          margin: EdgeInsets.only(left: 8,right: 8,top:8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5), //border corner radius
            boxShadow:[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6), //color of shadow
                spreadRadius: 1.3, //spread radius
                blurRadius: 3.5, // blur radius
                offset: Offset(2, 4), // changes position of shadow
                //first paramerter of offset is left-right
                //second parameter is top to down
              ),
              //you can set more BoxShadow() here
            ],
          ),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex:2,
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
                      flex:2,
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
                                              elevation: 5.0,
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
          ));

  }
}