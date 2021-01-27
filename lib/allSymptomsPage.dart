import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:Bealthy_app/symptomPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'Database/enumerators.dart';
import 'Login/config/palette.dart';
import 'headerScrollStyle.dart';
import 'overviewPage.dart';



class AllSymptomsPage extends StatefulWidget {
  final headerScrollStyle = const HeaderScrollStyle();
  final formatAnimation = FormatAnimation.slide;


  @override
  _AllSymptomsPageState createState() => _AllSymptomsPageState();
}

class _AllSymptomsPageState extends State<AllSymptomsPage>  with SingleTickerProviderStateMixin{


  DateStore dateStore;
  SymptomStore symptomStore;
  double animationStartPos=0;

  int variableSet = 0;
  ScrollController _scrollController;
  double width;
  double height;

  void initState() {
    super.initState();
    dateStore = Provider.of<DateStore>(context, listen: false);
    symptomStore = Provider.of<SymptomStore>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(child: Scaffold(
        appBar: AppBar(
          title: Text("Add Symptom"),
          actions: [
            IconButton(
              onPressed: () =>
              {
                showToast(
                    "To change the order of your symptoms, long press on the icon and pull the row up or down ",
                    position: ToastPosition.bottom,
                    duration: Duration(seconds: 5))
              },
              icon: Icon(Icons.info_outline),)
          ],
        ),
        body: MediaQuery
            .of(context)
            .orientation == Orientation.portrait
            ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Flexible(child: Observer(builder: (_) => symptomsContent()),
                ),
              ],
            ):DragAndDropGridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
            ),
            padding: EdgeInsets.all(16),
            controller: _scrollController,
            itemCount: symptomStore.symptomList.length,
            itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.all(16),
                    child:Card(
                      margin: EdgeInsets.all(0),
                        elevation: 2,
                        child: LayoutBuilder(
                          builder: (context, costrains) {

                            if (variableSet == 0) {
                              height = costrains.maxHeight;
                              width = costrains.maxWidth;
                              variableSet++;
                            }
                            return  Container(
                                width: width-8,
                                height: height-8,
                                child:TextButton(
                                onPressed: () =>
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        SymptomPage(symptom: symptomStore.symptomList[index])
                                    )
                                ),
                            child:Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image(
                                        height: height/2,
                                        width: width/2,
                                        color: symptomStore.symptomList[index].isSymptomSelectDay ? Palette
                                            .bealthyColorScheme.primaryVariant : null,
                                        image:AssetImage("images/Symptoms/" +
                                            symptomStore.symptomList[index].id + ".png")

                                    ),
                                    Text(symptomStore.symptomList[index].name, style: TextStyle(fontSize: 20),),

                                  ],)));
                          },
                        ))),
            onWillAccept: (oldIndex, newIndex) => true,
            onReorder: (oldIndex, newIndex) {
              symptomStore.reorderList(oldIndex, newIndex);
            })

    )

    );
  }
  Widget symptomsContent() {
    return Container(
        color: Colors.white,
        child: ReorderableListView(
        key:Key("symptomsContent"),

            padding: EdgeInsets.symmetric(vertical: 8),
            children: [
              for(var symptom in symptomStore.symptomList )
                Padding(
                  key: Key(symptom.id),
                  padding: EdgeInsets.only(top: 4, bottom: 4),
                  child:
                  ListTile(

                    title: Text(symptom.name, style: TextStyle(fontSize: 20.0)),
                    leading: ImageIcon(
                      AssetImage("images/Symptoms/" +
                          symptomStore.symptomList[symptomStore
                              .getIndexFromSymptomsList(
                              symptom, symptomStore.symptomList)].id + ".png"),
                      size: 35.0,
                      color: symptom.isSymptomSelectDay ? Palette
                          .bealthyColorScheme.primaryVariant : null,
                    ),
                    onTap: () =>
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                SymptomPage(symptom: symptom)
                            )
                        ),
                  ),
                )
            ],
            onReorder: (oldIndex, newIndex) {
              symptomStore.reorderList(oldIndex, newIndex);
            }
        ));

  }
}
