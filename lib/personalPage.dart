import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'Login/config/palette.dart';
import 'Login/screens/auth/auth.dart';
import 'Models/dateStore.dart';
import 'Models/userStore.dart';
import 'uploadNewProfileImage.dart';


class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage>{
  List<CameraDescription> cameras;
  final Color yellow = Color(0xfffbc31b);
  final Color orange = Color(0xfffb6900);
  final Color green = Colors.green;
  final Color lightBlue = Colors.lightBlueAccent;
  var storage = FirebaseStorage.instance;
  UserStore userStore;
  DateStore dateStore;

  void initState() {
    super.initState();
    initializeCameras();
    dateStore = Provider.of<DateStore>(context, listen: false);
    userStore = Provider.of<UserStore>(context, listen: false);
    userStore.initPersonalPage();
    userStore.initSickDaysMonth(dateStore.returnDaysOfAWeekOrMonth(DateTime(DateTime.now().year, DateTime.now().month,DateTime.now().day-31 ), DateTime.now()));


  }

  Future<void> initializeCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();

  }

  openCamera() async {
    await Navigator.push(
      context,
      MaterialPageRoute<File>(
        builder: (context) => UploadNewProfileImage(camera: cameras.first),
      ),
    );
  }

  Future getImage() async {
    String userUid;
    final litUser = context.getSignedInUser();
    litUser.when(
          (user) => userUid=user.uid,
      empty: () => Text('Not signed in'),
      initializing: () => Text('Loading'),
    );
    try {
      return await storage.ref(userUid+"/UserProfileImage/UserProfileImage.jpg").getDownloadURL();
    }
    catch (e) {
      return await Future.error(e);
    }
  }

  Widget symptom(int index){
    return Row(
      children: [
        Observer(builder: (_) => Container(
            padding: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
            width: 70,
            alignment: Alignment.center,
            color: Colors.transparent,
            child:  ImageIcon(
            AssetImage("images/Symptoms/" +userStore.personalPageSymptomsList[index].id+".png" ),
            size: 28.0,
          ),
        ),

    ),
        Container(
            width: 70,
            alignment: Alignment.center,
            color: Colors.transparent,
            child: Text(userStore.personalPageSymptomsList[index].name),),
        Container(
          width: 70,
          alignment: Alignment.center,
          color: Colors.transparent,
          child: Text(userStore.calculatePercentageSymptom(userStore.personalPageSymptomsList[index]).toStringAsFixed(2)+"%"),)
    ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('Personal info'),
        ),
        body: SingleChildScrollView(child: Center(
            child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    child: Observer(builder: (_) =>Container(
                        alignment: Alignment.center ,
                        child: Stack(
                            children: [
                              Container
                                (width: 150,
                                  height: 150,
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
                                    border: new Border.all(
                                      color: Colors.black,
                                      width: 4.0,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: userStore.profileImage==null?
                                    FutureBuilder(
                                        future: getImage(),
                                        builder: (context, remoteString) {
                                          if (remoteString.connectionState != ConnectionState.waiting) {
                                            if (remoteString.hasError) {
                                              return Image(image:AssetImage("images/defaultImageProfile.png"), fit:BoxFit.cover);
                                            }
                                            else {
                                              return Container
                                                (width: 50,
                                                  height: 50,
                                                  child: ClipOval(
                                                    child: Image.network(remoteString.data, fit:BoxFit.cover),));
                                            }
                                          }
                                          else {
                                            return Center(
                                                child:CircularProgressIndicator());
                                          }
                                        }
                                    )
                                        :
                                    Image.file(userStore.profileImage),
                                  )
                              ),

                              Stack(
                                  children:  <Widget>[
                                    Container(
                                        margin: const EdgeInsets.only(left: 125,top:125),
                                        child:IconButton(padding: EdgeInsets.all(2),onPressed: openCamera, icon: Icon(Icons.photo_camera), iconSize: 42,
                                          color: Colors.black,)),]

                              )
                            ])

                    )),
                  ),
                  Divider(
                    height: 2,
                    thickness: 0.5,
                    color: Colors.black87,
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                            child: Observer(
                              builder: (_) {
                                switch (userStore.loadSickDayMonth.status) {
                                  case FutureStatus.rejected:
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Oops something went wrong'),
                                          RaisedButton(
                                            child: Text('Retry'),
                                            onPressed: () async {
                                              await userStore.retrySickDaysMonth(dateStore.returnDaysOfAWeekOrMonth(DateTime(DateTime.now().year, DateTime.now().month,DateTime.now().day-31 ), DateTime.now()));
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  case FutureStatus.fulfilled:
                                    return ListTile(
                                      title: Text("Average sick days in the last month: "+ userStore.sickDays.length.toString()),
                                      leading: Icon(Icons.sick,color: Colors.black,),
                                    );
                                  case FutureStatus.pending:
                                  default:
                                    return Center(
                                        child:CircularProgressIndicator());
                                }
                              },
                            )
                        )])),
                  Divider(
                    height: 2,
                    thickness: 0.5,
                    color: Colors.black87,
                  ),
                  Container(
                    padding: EdgeInsets.all(15.0),
                    alignment: Alignment.centerLeft,
                      child:Text("THREE MOST RELEVANT SYMPTOMS:",style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                      child: Observer(
                        builder: (_) {
                          switch (userStore.loadInitOccurrenceSymptomsList.status) {
                            case FutureStatus.rejected:
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Oops something went wrong'),
                                    RaisedButton(
                                      child: Text('Retry'),
                                      onPressed: () async {
                                        await userStore.retryForOccurrenceSymptoms();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            case FutureStatus.fulfilled:
                              return ListView(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                children: [
                                  userStore.personalPageSymptomsList.length>0? symptom(userStore.personalPageSymptomsList.length-1): Container(),
                                  userStore.personalPageSymptomsList.length>1? symptom(userStore.personalPageSymptomsList.length-2): Container(),
                                  userStore.personalPageSymptomsList.length>2? symptom(userStore.personalPageSymptomsList.length-3): Container(),
                                  SizedBox(height: 8,),
                                ],
                              );
                            case FutureStatus.pending:
                            default:
                              return Center(
                                  child:CircularProgressIndicator());
                          }
                        },
                      )),
                  Divider(
                    height: 2,
                    thickness: 0.5,
                    color: Colors.black87,
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                    margin: const EdgeInsets.only(
                        top: 30, left: 20.0, right: 20.0, bottom: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.signOut();
                        Navigator.of(context).pushReplacement(AuthScreen.route);
                      },
                      child: Text('Sign out'),
                    ),
                  ),
                ]
            )
        )
    ));
  }

}