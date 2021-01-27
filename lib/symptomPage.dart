import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/overviewStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:Bealthy_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'Database/symptom.dart';
import 'Login/config/palette.dart';
import 'overviewPage.dart';

class SymptomPage extends StatefulWidget {

  final Symptom symptom;
  SymptomPage({@required this.symptom});

  @override
  _SymptomPageState createState() => _SymptomPageState();
}

class _SymptomPageState extends State<SymptomPage> with TickerProviderStateMixin {

  TabController _tabController;
  DateTime date;

  OverviewStore overviewStore;
  DateStore dateStore;
  AppBar appBar;
  void initState() {
    super.initState();
    _tabController = getTabController();
    dateStore = Provider.of<DateStore>(context, listen: false);
    date = dateStore.calendarSelectedDate;
    widget.symptom.intensityTemp = widget.symptom.intensity;
    widget.symptom.frequencyTemp = widget.symptom.frequency;
    widget.symptom.copyOriginalToTempMealtime();
    widget.symptom.isModeRemove=false;
     appBar = AppBar(
      title: Text(widget.symptom.name),
      bottom: TabBar(
        tabs: [
          Tab(text: "Modify"),
          Tab(text: "Description")
        ],
        controller: _tabController,
      ),
    );

  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TabController getTabController() {
    return TabController(length: 2, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    reactButtonEnabled();
    final symptomStore = Provider.of<SymptomStore>(context);
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: appBar,
      body: TabBarView(
        controller: _tabController,
        children: [
          MediaQuery
              .of(context)
              .orientation == Orientation.portrait
              ?modifyPortraitWidget(symptomStore):
          modifyLandscapeWidget(symptomStore),
          descriptionWidget(),
        ],
      ),
    ));
  }


  Widget descriptionWidget() {
    return SingleChildScrollView(

        child:ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height-appBar.bottom.preferredSize.height-
                    appBar.preferredSize.height
            ),
            child:
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  descriptionText(),
                  symptomsText(),
                  Padding(
                      padding: EdgeInsets.only(top:4,bottom: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback(
                                (_) =>
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HomePage(startingIndex: 1,))),
                          );
                        },
                        child: Text('STATISTICS'),
                      ))
                ])));
  }

  Widget descriptionText(){
    return  Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        margin: MediaQuery.of(context).orientation == Orientation.portrait?EdgeInsets.all(16):
        EdgeInsets.symmetric(vertical:16,horizontal: 64),
        width:double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5), //border corner radius
          boxShadow:[
            BoxShadow(
              color: Colors.grey.withOpacity(0.0), //color of shadow
              spreadRadius: 1, //spread radius
              blurRadius: 3, // blur radius
              offset: Offset(2, 4), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
        ),
        child: Column(
            children:[
              Text("Description",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              SizedBox(height: 10,),

              Text(widget.symptom.description,textAlign: TextAlign.justify, style: TextStyle(fontSize: MediaQuery.of(context).orientation == Orientation.portrait?null:20)),
            ]
        )
    );
  }

  Widget symptomsText(){
    return  Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        margin: MediaQuery.of(context).orientation == Orientation.portrait?EdgeInsets.all(16):
        EdgeInsets.symmetric(vertical:16,horizontal: 64),
        width:double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5), //border corner radius
          boxShadow:[
            BoxShadow(
              color: Colors.grey.withOpacity(0.0), //color of shadow
              spreadRadius: 1, //spread radius
              blurRadius: 3, // blur radius
              offset: Offset(2, 4), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
        ),
        child: Column(
            children:[
              Text("Related Symptoms & Signs",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              SizedBox(height: 10,),
              Text(widget.symptom.symptoms,textAlign: TextAlign.justify, style: TextStyle(fontSize: MediaQuery.of(context).orientation == Orientation.portrait?null:20),),
            ]
        )
    );
  }

  Widget modifyPortraitWidget(SymptomStore symptomStore) {
    return SingleChildScrollView(child: Container(
      padding: EdgeInsets.all( 4 ),
        child: Card(
            elevation: 0,
            child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Intensity",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            Observer(builder: (_) =>
                Slider(
                  divisions: 5,
                  value: widget.symptom.intensityTemp.toDouble(),
                  label: Intensity.values[widget.symptom.intensityTemp].toString().split('.').last,
                  min: 0,
                  max: 5,
                  onChanged: (val) {
                    widget.symptom.intensityTemp = val.toInt();
                  },
                )),
            Divider(height: 40),
            Text("Frequency",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            Observer(builder: (_) =>
                Slider(
                  divisions: 5,
                  value: widget.symptom.frequencyTemp.toDouble(),
                  label: Frequency.values[widget.symptom.frequencyTemp].toString().split('.').last,
                  min: 0,
                  max: 5,
                  onChanged: (val) {
                    widget.symptom.frequencyTemp = val.toInt();
                  },
                )),
            Divider(height: 40),
            Text("Select symptom occurrence",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            SizedBox(height: 10,),
            mealTimeList(widget.symptom),
            Divider(height: 10),
            Align(
                alignment: Alignment.centerRight,
                child:Padding(
                    padding: const EdgeInsets.all(4),
                    child: TextButton(
                      style: TextButton.styleFrom(primary: Palette.bealthyColorScheme.secondary),
                      child:Text('RESET VALUES'),
                      onPressed: ()=>widget.symptom.resetTempValue(),))),
            Observer(builder: (_) =>  Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  key:Key("buttonSaveRemove"),
                  onPressed: !widget.symptom.isModifyButtonActive?  null :  () {
                    buttonActivated(symptomStore);
                  } ,
                  child: !widget.symptom.isModeRemove ? Text('SAVE'):Text('REMOVE'),
                  style: !widget.symptom.isModeRemove?ElevatedButton.styleFrom(primary: Palette.bealthyColorScheme.primary)
                      :ElevatedButton.styleFrom(primary: Palette.bealthyColorScheme.error),
                )
            ))
          ],
            ))));
  }

  Widget modifyLandscapeWidget(SymptomStore symptomStore) {
    return Container(
        padding: EdgeInsets.all( 4 ),
        child: Card(
            elevation: 0,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Expanded(child:
                    Padding(
                        padding:EdgeInsets.all(16),
                        child:Column(children: [
                        Text("Intensity",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                        Observer(builder: (_) =>
                      Slider.adaptive(
                        divisions: 5,
                        value: widget.symptom.intensityTemp.toDouble(),
                        label: Intensity.values[widget.symptom.intensityTemp].toString().split('.').last,
                        min: 0,
                        max: 5,
                        onChanged: (val) {
                          widget.symptom.intensityTemp = val.toInt();
                        },
                      )),
                      Divider(height: 80),
                      Text("Frequency",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                      Observer(builder: (_) =>
                          Slider(
                            divisions: 5,
                            value: widget.symptom.frequencyTemp.toDouble(),
                            label: Frequency.values[widget.symptom.frequencyTemp].toString().split('.').last,
                            min: 0,
                            max: 5,
                            onChanged: (val) {
                              widget.symptom.frequencyTemp = val.toInt();
                            },
                          )),
                    ],))),
                    Expanded(child:
                    Padding(
                        padding:EdgeInsets.all(16),
                        child:Column(children: [
                      Text("Select symptom occurrence",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                      SizedBox(height: 10,),
                      mealTimeList(widget.symptom),

                    ],)
                    )),

                  ],),
                  Align(
                      alignment: Alignment.center,
                      child:Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextButton(
                            style: TextButton.styleFrom(primary: Palette.bealthyColorScheme.secondary),
                            child:Text('RESET VALUES'),
                            onPressed: ()=>widget.symptom.resetTempValue(),))),
                  Observer(builder: (_) =>  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
          child: ElevatedButton(
            key:Key("buttonSaveRemove"),
            onPressed: !widget.symptom.isModifyButtonActive?  null :  () {
              buttonActivated(symptomStore);
            } ,
            child: !widget.symptom.isModeRemove ? Text('SAVE'):Text('REMOVE'),
            style: !widget.symptom.isModeRemove?ElevatedButton.styleFrom(primary: Palette.bealthyColorScheme.primary)
                :ElevatedButton.styleFrom(primary: Palette.bealthyColorScheme.error),
          )
      ))
    ]
    )
    )
    );
  }

  bool areMealTimeBoolListsEqual(){
    int count = 0;
    for(int i = 0; i<MealTime.values.length; i++){
      if(widget.symptom.mealTimeBoolList[i].isSelected== widget.symptom.mealTimeBoolListTemp[i].isSelected){
        count = count + 1;
      }
    }
    if(count == MealTime.values.length){
      return true;
    } else {return false;}

  }

  List<String> getMealTimeName() {
    List<String> listToReturn = new List<String>();
    MealTime.values.forEach((element) {
      listToReturn.add(element
          .toString()
          .split('.')
          .last);
    });
    return listToReturn;
  }

  void saveTempValueToRealSymptom(){
    widget.symptom.intensity=widget.symptom.intensityTemp;
    widget.symptom.frequency=widget.symptom.frequencyTemp;
    widget.symptom.copyTempToOriginalMealTime();

  }

  buttonActivated(SymptomStore symptomStore){
    if (!widget.symptom.isSymptomSelectDay) {
      if ((widget.symptom.frequencyTemp > 0 && widget.symptom.intensityTemp > 0) &&
          widget.symptom.isPresentAtLeastOneTrue()){
        saveTempValueToRealSymptom();
        dateStore.addIllnesses(date);
        symptomStore.updateSymptom(widget.symptom, date);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } else {
      if ((widget.symptom.frequencyTemp > 0 && widget.symptom.intensityTemp > 0) &&
          widget.symptom.isPresentAtLeastOneTrue()) {
        if (widget.symptom.frequency != widget.symptom.frequencyTemp ||
            widget.symptom.intensity != widget.symptom.intensityTemp || !areMealTimeBoolListsEqual()) {
          saveTempValueToRealSymptom();
          symptomStore.updateSymptom(widget.symptom, date);
          Navigator.of(context).popUntil((route) => route.isFirst);

        }
      }else{
        if((widget.symptom.frequencyTemp == 0 && widget.symptom.intensityTemp == 0) &&
            !widget.symptom.isPresentAtLeastOneTrue()){
          return showDialog(

              context: context,
              builder: (_) =>  new AlertDialog(
                key:Key("alertDialog"),
                title: new Text(widget.symptom.name),
                content: new Text("Are you sure to remove it?"),
                actions: <Widget>[
                  FlatButton(
                    key:Key("flatButtonRemoveSymptom"),
                    child: Text('REMOVE'),
                    onPressed: () {
                      //dateStore.removeIllnesses(symptomStore, date);
                      symptomStore.removeSymptomOfSpecificDay( widget.symptom, date)
                          .then((value) {
                            dateStore.removeIllnesses(symptomStore, date);
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          }
                            );
                    },
                  )
                ],
              ));
        }
      }
    }
  }

  void reactButtonEnabled(){

    reaction((_) => {widget.symptom.frequencyTemp, widget.symptom.intensityTemp,
      widget.symptom.mealTimeBoolListTemp.forEach((element) {
        element.isSelected;
      })}, (_) => {

      if (!widget.symptom.isSymptomSelectDay) {
        if ((widget.symptom.frequencyTemp > 0 && widget.symptom.intensityTemp > 0) &&
            widget.symptom.isPresentAtLeastOneTrue()){
          widget.symptom.isModifyButtonActive = true
        }else{ widget.symptom.isModifyButtonActive = false}
      } else
        {
          if ((widget.symptom.frequencyTemp > 0 && widget.symptom.intensityTemp > 0 &&
              widget.symptom.isPresentAtLeastOneTrue()) &&
              (widget.symptom.frequency != widget.symptom.frequencyTemp ||
                  widget.symptom.intensity != widget.symptom.intensityTemp ||
                  !areMealTimeBoolListsEqual())) {
            widget.symptom.isModifyButtonActive = true
          } else
            {

              if((widget.symptom.frequencyTemp == 0 &&
                  widget.symptom.intensityTemp == 0) &&
                  !widget.symptom.isPresentAtLeastOneTrue()){
                widget.symptom.isModifyButtonActive = true,
                widget.symptom.isModeRemove = true
              }else{
                widget.symptom.isModifyButtonActive = false,
                widget.symptom.isModeRemove = false

            }
            }
        }

    });
  }

  Widget mealTimeList(Symptom symptom) {
    return
    Observer(builder: (_) =>
        ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: symptom.mealTimeBoolListTemp.length,
            itemBuilder: (BuildContext context, int index) {
              return Observer(builder: (_) =>
                  CheckboxListTile(
                    checkColor: Colors.black,
                    value: symptom.mealTimeBoolListTemp[index].isSelected,
                    title: new Text(MealTime.values[index]
                        .toString()
                        .split('.')
                        .last),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool val) {
                      symptom.mealTimeBoolListTemp[index].setIsSelected(val);
                    },

                  ));
            }
        ),
    );
  }
}