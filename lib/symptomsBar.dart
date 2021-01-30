import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:Bealthy_app/allSymptomsPage.dart';
import 'package:Bealthy_app/symptomPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'Login/config/palette.dart';
import 'headerScrollStyle.dart';



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
    ScrollController _scrollController = new ScrollController();

    return
      Container(
        padding: EdgeInsets.all(8),
          child: Card(
          elevation: 3,
          margin: EdgeInsets.all(0),
          child:Column(
            mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllSymptomsPage()));
                  },
                  title: Text("Symptoms",style: TextStyle(fontWeight:FontWeight.bold,fontSize:20,)),
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
                ),

                Observer(
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
                          symptomStore.sortSymptomDayList();

                          return  OrientationBuilder(
                              builder: (context, orientation) {
                                return MediaQuery.of(context).orientation == Orientation.portrait
                                    ?Container(

                                    margin: EdgeInsets.only(bottom: 16,top:8,right: 16,left: 16),
                                    height: 50,
                                    child:Observer(builder: (_) => symptomStore.symptomListOfSpecificDay.length!=0?

                                          ListView.separated(
                                            controller: _scrollController,
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
                                        return Container(
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
                                              AssetImage("images/Symptoms/" +symptomStore.symptomListOfSpecificDay[index].id+".png" ),
                                              size: 35.0,
                                            ),

                                          ),
                                        );
                                      },
                                    ):Center(child:Text("No symptoms this day",style: TextStyle(fontSize: 20),)))
                                ):Container(
                                    margin: EdgeInsets.only(bottom: 16,top:8,right: 16,left: 16),
                                    child:Observer(builder: (_) => symptomStore.symptomListOfSpecificDay.length!=0?
                                    GridView.builder(
                                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          mainAxisSpacing: 16,
                                          crossAxisSpacing: 16,
                                          childAspectRatio: 1.5
                                      ),
                                      itemCount: symptomStore.symptomListOfSpecificDay.length,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          alignment: Alignment.center,
                                          color: Colors.transparent,
                                          child:  RawMaterialButton(
                                            constraints : const BoxConstraints(minWidth: 60.0, minHeight: 60.0),
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
                                              AssetImage("images/Symptoms/" +symptomStore.symptomListOfSpecificDay[index].id+".png" ),
                                              size: 40.0,
                                            ),

                                          ),
                                        );
                                      },
                                    ):Container(
                                        height: 64,
                                        child:Center(child:Text("No symptoms this day",style: TextStyle(fontSize: 20),)))
                                    ));
                              });
                        case FutureStatus.pending:
                        default:
                          return Container(
                              height: MediaQuery.of(context).orientation == Orientation.portrait
                                  ?50:64,

                              margin: EdgeInsets.only(bottom: 16,top:8,right: 16,left: 16),
                              child:
                              Center(child:CircularProgressIndicator()));
                      }
                    }else{
                      return Container();}
                  },
                )
                //


              ]
          )));

  }
}