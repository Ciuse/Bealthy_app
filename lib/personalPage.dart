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
import 'Models/ingredientStore.dart';
import 'Models/symptomStore.dart';
import 'Models/userStore.dart';
import 'symptomPage.dart';
import 'uploadNewProfileImage.dart';


class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage>{
  IngredientStore ingredientStore;
  List<CameraDescription> cameras;
  final Color yellow = Color(0xfffbc31b);
  final Color orange = Color(0xfffb6900);
  final Color green = Colors.green;
  final Color lightBlue = Colors.lightBlueAccent;
  var storage = FirebaseStorage.instance;
  SymptomStore symptomStore;

  void initState() {
    super.initState();
    initializeCameras();
    ingredientStore = Provider.of<IngredientStore>(context, listen: false);
    symptomStore = Provider.of<SymptomStore>(context, listen: false);
    symptomStore.initPersonalPage();


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
            child:  RawMaterialButton(
              onPressed: () => {
                print(symptomStore.personalPageSymptomsList[index].occurrence),
              },
          elevation: 5.0,
          fillColor: Colors.white,
          child: ImageIcon(
            AssetImage("images/Symptoms/" +symptomStore.personalPageSymptomsList[index].id+".png" ),
            color: Colors.black,
            size: 28.0,
          ),
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),

        )),

    ),
        Container(
            width: 70,
            alignment: Alignment.center,
            color: Colors.transparent,
            child: Text(symptomStore.personalPageSymptomsList[index].name),)
    ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ingredientStore = Provider.of<IngredientStore>(context);
    final userStore = Provider.of<UserStore>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Personal info'),
        ),
        body: Center(
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
                                              return Image(image:AssetImage("images/defaultImageProfile.png"));
                                            }
                                            else {
                                              return Container
                                                (width: 50,
                                                  height: 50,
                                                  child: ClipOval(
                                                    child: Image.network(remoteString.data, fit: BoxFit.fill),));
                                            }
                                          }
                                          else {
                                            return CircularProgressIndicator();
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
                  Row(
                      children: [
                        Container(
                            width: 300,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: ListTile(
                              title: Text("AVERAGE SICK DAYS:",style: TextStyle(fontWeight: FontWeight.bold)),
                              leading: Icon(Icons.sick, color: Colors.black,),
                            )
                        )]),
                  Divider(
                    height: 2,
                    thickness: 0.5,
                    color: Colors.black87,
                  ),
                  Container(
                    padding: EdgeInsets.all(15.0),
                    alignment: Alignment.centerLeft,
                      child:Text("THREE MOST PREVALENT SYMPTOMS:",style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                      child: Observer(
                        builder: (_) {
                          switch (symptomStore.loadInitOccurrenceSymptomsList.status) {
                            case FutureStatus.rejected:
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Oops something went wrong'),
                                    RaisedButton(
                                      child: Text('Retry'),
                                      onPressed: () async {
                                        await symptomStore.retryForOccurrenceSymptoms();
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
                                  symptomStore.personalPageSymptomsList.length>0? symptom(symptomStore.personalPageSymptomsList.length-1): Container(),
                                  symptomStore.personalPageSymptomsList.length>1? symptom(symptomStore.personalPageSymptomsList.length-2): Container(),
                                  symptomStore.personalPageSymptomsList.length>2? symptom(symptomStore.personalPageSymptomsList.length-3): Container(),
                                  SizedBox(height: 8,),
                                ],
                              );
                            case FutureStatus.pending:
                            default:
                              return CircularProgressIndicator();
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
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Palette.primaryDark, Palette.primaryLight,Palette.primaryMoreLight,],
                        ),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: FlatButton(
                      child: const Text('Sign out'),
                      textColor: Colors.black,
                      onPressed: () async {
                        context.signOut();
                        Navigator.of(context).pushReplacement(AuthScreen.route);
                      },
                    ),
                  ),
                ]
            )
        )
    );
  }

}