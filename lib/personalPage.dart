import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Login/screens/auth/auth.dart';
import 'Models/ingredientStore.dart';
import 'Models/symptomStore.dart';
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
    ingredientStore.profileImage=null;
    symptomStore = Provider.of<SymptomStore>(context, listen: false);
    symptomStore.initStore(DateTime.now());
  }

  Future<void> initializeCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();

  }

  openCamera() async {
    ingredientStore.profileImage = await Navigator.push(
      context,
      MaterialPageRoute<File>(
        builder: (context) => UploadNewProfileImage(camera: cameras.first),
      ),
    );
    print(ingredientStore.profileImage);
  }

  Future getImage() async {
    try {
      return await storage.ref("UserProfileImage/userProfileImage.jpg").getDownloadURL();
    }
    catch (e) {
      return await Future.error(e);
    }
  }

  Widget symptom(int index){
    return Row(
      children: [
        Observer(builder: (_) => Container(
        width: 70,
        alignment: Alignment.centerLeft,
        color: Colors.transparent,
        child:  RawMaterialButton(
          elevation: 5.0,
          fillColor: Colors.white,
          child: ImageIcon(
            AssetImage("images/" +symptomStore.symptomList[index].id+".png" ),
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
            child: Text(symptomStore.symptomList[index].name),)
    ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ingredientStore = Provider.of<IngredientStore>(context);
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
                                    child: ingredientStore.profileImage==null?
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
                                    Image.file(ingredientStore.profileImage),
                                  )
                              ),

                              Stack(
                                  children:  <Widget>[
                                    Container(
                                        margin: const EdgeInsets.only(left: 125,top:125),
                                        child:IconButton(padding: EdgeInsets.all(2),onPressed: openCamera, icon: Icon(Icons.add_a_photo_outlined), iconSize: 42,
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
                              leading: Icon(Icons.sick),
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
                  ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          children: [
                            symptom(0),
                            symptom(1),
                            symptom(2),
                          ],
                  ),
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
                          colors: [lightBlue, green],
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