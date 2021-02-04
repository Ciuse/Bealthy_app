import 'package:Bealthy_app/Database/treatment.dart';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/symptomStore.dart';
import 'package:Bealthy_app/Models/treatmentStore.dart';
import 'package:Bealthy_app/detailsOfSpecificTreatmentPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobx/mobx.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'firebaseMock.dart';
import 'package:intl/intl.dart';



class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();


  });
  final mockObserver = MockNavigatorObserver();


  testWidgets('Add new treatment', (WidgetTester tester) async {



    final GlobalKey<FormFieldState<String>> descriptionKey = GlobalKey<FormFieldState<String>>();
    final GlobalKey<FormFieldState<String>> titleKey = GlobalKey<FormFieldState<String>>();
    final GlobalKey<FormFieldState<String>> startingDateKey = GlobalKey<FormFieldState<String>>();
    final GlobalKey<FormFieldState<String>> endingDateKey = GlobalKey<FormFieldState<String>>();
    final titleCt = TextEditingController();
    final descriptionTextCt = TextEditingController();
    final startingDateCt = TextEditingController();
    final endingDateCt = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    List<Treatment> treatmentsInProgressList = new List<Treatment>();
    List<Treatment> treatmentsCompletedList = new List<Treatment>();
    int length = treatmentsCompletedList.length;

    String fixDate(DateTime date){
      return "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
    }

    DateTime setDateFromString(String dateTime){
      try{
        DateFormat dateFormat = DateFormat("yyyy-MM-dd");
        DateTime toCheck = dateFormat.parse(dateTime);
        return toCheck;
      }catch (e){
        return null;
      }
    }



    void addTreatmentToUser(int lastTreatmentNumber) {

      Treatment treatment = new Treatment(
        id: "Treatment_"+ lastTreatmentNumber.toString(),
        number: lastTreatmentNumber,
        title: titleCt.text,
        startingDay: startingDateCt.text,
        endingDay: endingDateCt.text,
        descriptionText: descriptionTextCt.text,
      );
      DateTime endingDate = setDateFromString(treatment.endingDay);
      if (DateTime.now().isBefore(endingDate)) {
        treatmentsInProgressList.add(treatment);
      } else {
        treatmentsCompletedList.add(treatment);
      }

    }

    Widget YourWidgetToTest(BuildContext context) {
      return MaterialApp(

        home: MediaQuery(
          data: const MediaQueryData(devicePixelRatio: 1.0),
          child: Center(
              child: Material(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        key: titleKey,
                        maxLength: 25,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: titleCt,
                        decoration: new InputDecoration(
                          labelText: 'Name',
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                          //fillColor: Colors.green
                        ),
                        validator: (val) {
                          if(val.length==0) {
                            return "Name cannot be empty";
                          }else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextFormField(
                        key: descriptionKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: descriptionTextCt,
                        decoration: new InputDecoration(
                          labelText: 'Description',
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                          //fillColor: Colors.green
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextFormField(
                        key: startingDateKey,
                        readOnly: true,
                        onTap: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2019, 1),
                              lastDate: DateTime(2030,12),
                              builder: (BuildContext context, Widget picker){
                                return Theme(
                                  data: ThemeData.light(),
                                  child: picker,);
                              })
                              .then((selectedDate) {
                            //TODO: handle selected date
                            if(selectedDate!=null){
                              startingDateCt.text = fixDate(selectedDate);
                            }
                          });
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: startingDateCt,
                        decoration: new InputDecoration(
                          labelText: "Enter Starting date of treatment",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                        ),
                        validator: (val) {
                          if(val.length==0) {
                            return "Starting Date of treatment cannot be empty";
                          }else{
                            if(setDateFromString(val)!=null){
                              return null;
                            }else{
                              return "Insert a valid Date of starting treatment date";
                            }

                          }
                        },
                        keyboardType: TextInputType.datetime,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextFormField(
                        key: endingDateKey,
                        enabled: startingDateCt.text.length>0?true:false, //METTERE SOLO DOPO AVER SELEZIONATO LA PRIMA DATA
                        readOnly: true,
                        onTap: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2019, 1),
                              lastDate: DateTime(2030,12),
                              builder: (BuildContext context, Widget picker){
                                return Theme(
                                  data: ThemeData.light(),
                                  child: picker,);
                              })
                              .then((selectedDate) {
                            //TODO: handle selected date
                            if(selectedDate!=null){
                              endingDateCt.text = fixDate(selectedDate);
                            }
                          });
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: endingDateCt,
                        decoration: new InputDecoration(
                          labelText: "Enter Ending date of treatment",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                        ),
                        validator: (val) {
                          if(val.length==0) {
                            return "Ending Date of treatment cannot be empty";
                          }else{
                            if(setDateFromString(val)!=null && setDateFromString(startingDateCt.text).isBefore(setDateFromString(val))){
                              return null;
                            }else{
                              return "Insert a valid Date of ending treatment date";
                            }

                          }
                        },
                        keyboardType: TextInputType.datetime,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (titleCt.text!=null && startingDateCt.text!=null&& endingDateCt.text!=null) {

                              _formKey.currentState.save();

                              addTreatmentToUser(2);

                            }

                          },
                          child: Text('CREATE'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      );
    }

    await initializeDateFormatting().then((_) async =>  await  tester.pumpWidget(
        MaterialApp(home:
      Builder(
      builder: (context) => YourWidgetToTest(context),
    ),)));

    await tester.enterText(find.byKey(titleKey).first, "");
    await tester.pump();
    expect(titleKey.currentState.isValid, isFalse);

    await tester.enterText(find.byKey(titleKey).first, "treatment1");
    await tester.pump();
    expect(titleKey.currentState.isValid, isTrue);

    await tester.enterText(find.byKey(descriptionKey).first, "");
    await tester.pump();
    expect(descriptionKey.currentState.isValid, isTrue);

    //apro il calendario ma poi lo chiudo senza settare nessuna data quindi mi aspetto che il campo sia invalido
    await tester.tap(find.byKey(startingDateKey));
    await tester.pumpAndSettle();
    expect(find.byType(CalendarDatePicker), findsNWidgets(1));
    await tester.tap(find.text('CANCEL'));
    expect(startingDateKey.currentState.isValid, isFalse);

    await tester.pumpAndSettle();

    //apro il calendario setto una data iniziale e quindi mi aspetto che il campo sia valido
    DateTime startingDay = DateTime(DateTime.now().year,DateTime.now().month,1) ;
    await tester.tap(find.byKey(startingDateKey));
    await tester.pumpAndSettle();
    expect(find.byType(CalendarDatePicker), findsNWidgets(1));
    await tester.tap(find.text(startingDay.day.toString()));
    await tester.tap(find.text('OK'));

    expect(startingDateCt.text, equals(fixDate(startingDay)));
    expect(startingDateKey.currentState.isValid, isTrue);

    await tester.pumpAndSettle();

    //apro il calendario setto una data finale e quindi mi aspetto che il campo sia valido
    DateTime endingDay =  startingDay.add(Duration(days: 2));
    await tester.tap(find.byKey(endingDateKey));
    await tester.pumpAndSettle();
    expect(find.byType(CalendarDatePicker), findsNWidgets(1));
    await tester.tap(find.text(endingDay.day.toString()));
    await tester.tap(find.text('OK'));
    expect(endingDateCt.text, equals(fixDate(endingDay)));
    expect(endingDateKey.currentState.isValid, isTrue);


    ElevatedButton button = find.widgetWithText(ElevatedButton, 'CREATE').evaluate().first.widget;
    button.onPressed();
    await tester.pumpAndSettle();
    expect(treatmentsCompletedList.length,length+1);
  });


  testWidgets('Removing treatment test', (WidgetTester tester) async {
    final _providerKey = GlobalKey();

    String fixDate(DateTime date){
      return "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
    }

    Treatment treatment = new Treatment(
      id: "Treatment_2",
      number: 2,
      title: "newTreatmentAdded",
      startingDay: fixDate(DateTime(DateTime.now().year,DateTime.now().month,15) ),
      endingDay: fixDate(DateTime(DateTime.now().year,DateTime.now().month,18) ),
      descriptionText: "",
      medicalInfoText: "",
      dietInfoText: "",
    );


    await tester.pumpWidget(MultiProvider(providers: [
      Provider<DateStore>(
        create: (_) => DateStore(),
      ),
      Provider<TreatmentStore>(
        create: (_) => TreatmentStore(),
      ),
      Provider<SymptomStore>(

        create: (_) => SymptomStore(),
      ),
    ], child:MaterialApp(  key: _providerKey,home: DetailsOfSpecificTreatmentPage(treatment: treatment,treatmentCompleted: false,),navigatorObservers: [mockObserver],),
    ),);

    var treatmentStore = Provider.of<TreatmentStore>(_providerKey.currentContext,listen: false);
    var symptomStore = Provider.of<SymptomStore>(_providerKey.currentContext,listen: false);
    treatmentStore.treatmentsInProgressList.add(treatment);
    int length =treatmentStore.treatmentsInProgressList.length;
    await tester.runAsync(() async {
      symptomStore.loadTreatments = ObservableFuture.value([treatment]);
      await  tester.pumpAndSettle();
    });
    //ciò che mi aspetto quando apro questa pagina
    //confermo l'eliminazione del sintomo
    IconButton buttonRemove = find.byKey(Key("buttonRemove")).evaluate().first.widget;
    buttonRemove.onPressed();
    await tester.pumpAndSettle();

    expect(find.byKey(Key("alertDialog")), findsNWidgets(1));
    //confermo l'eliminazione del sintomo
    FlatButton flatButtonRemove = find.widgetWithText(FlatButton,"REMOVE").evaluate().first.widget;
    flatButtonRemove.onPressed();
    await tester.pumpAndSettle();

    //mi aspetto che la lista dei sintomi di quel giorno sia diminuita di un'unità
    expect(treatmentStore.treatmentsInProgressList.length,length-1);

  });

}