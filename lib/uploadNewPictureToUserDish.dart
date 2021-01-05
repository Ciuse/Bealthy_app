import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'Database/dish.dart';
import 'package:Bealthy_app/Models/mealTimeStore.dart';
import 'package:provider/provider.dart';


class UploadNewPictureToUserDish extends StatefulWidget {
  final CameraDescription camera;
  final Dish dish;
  final bool uploadingOnFirebase;
  UploadNewPictureToUserDish({@required this.camera,@required this.dish,@required this.uploadingOnFirebase});

  @override
  _UploadNewPictureToUserDishState createState() =>
      _UploadNewPictureToUserDishState();
}

class _UploadNewPictureToUserDishState extends State<UploadNewPictureToUserDish> {
  File _imageFile;
  final Color yellow = Color(0xfffbc31b);
  final Color orange = Color(0xfffb6900);
  final picker = ImagePicker();
  MealTimeStore mealTimeStore;

  void initState() {
    super.initState();
    mealTimeStore = Provider.of<MealTimeStore>(context, listen: false);
  }


  void checkPermissionOpenGallery() async{
    var galleryStatus = await Permission.storage.status;


    if(!galleryStatus.isGranted){
      print("richiesta permessi");
      await Permission.storage.request();
    }

    if(await Permission.storage.isGranted){
      pickImageFromGallery();
    }else{
      showToast("Bealthy needs to access your Gallery, please provide permission", position: ToastPosition.bottom);
      openAppSettings2();
    }

  }

  void checkPermissionOpenCamera() async{
    var cameraStatus = await Permission.camera.status;

    print(cameraStatus);
    if (!cameraStatus.isGranted)
    {await Permission.camera.request();}


    if(await Permission.camera.isGranted){
      pickImageWithCamera();
    }else{
      showToast("Provide Camera permission to use camera.", position: ToastPosition.bottom);
      openAppSettings2();
    }

  }


  openAppSettings2(){
    return showDialog(
        context: context,
        builder: (_) =>  new AlertDialog(
          title: new Text("Bealthy"),
          content: new Text("Bealthy needs to access to your memory in order to upload new image"),
          actions: <Widget>[
            FlatButton(
              child: Text('Settings'),
              onPressed: () {
                openAppSettings();
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ));
  }

  Future pickImageWithCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if(pickedFile!=null){
      setState(() {
        _imageFile = File(pickedFile.path);
        widget.dish.imageFile = _imageFile;
        mealTimeStore.changeImageToAllSameDishes(widget.dish);
      });
    }
  }

  Future pickImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      setState(() {
        _imageFile = File(pickedFile.path);
        widget.dish.imageFile = _imageFile;
        mealTimeStore.changeImageToAllSameDishes(widget.dish);
      });
    }}


  Future uploadImageToFirebase(BuildContext context) async {
    if(widget.uploadingOnFirebase){
      String userUid;
      final litUser = context.getSignedInUser();
      litUser.when(
            (user) => userUid=user.uid,
        empty: () => Text('Not signed in'),
        initializing: () => Text('Loading'),
      );
      String fileName = widget.dish.id+".jpg";
      var firebaseStorageRef = FirebaseStorage.instance.ref().child(userUid+'/DishImage/$fileName');
      firebaseStorageRef.putFile(_imageFile);
      Navigator.pop(context);
    }else{
      Navigator.pop(context);
    }

  }





  @override
  Widget build(BuildContext context) {
    print("open uploading page");
    return OKToast(
        child:Scaffold(
      appBar: AppBar(
        title: Text("Upload new picture"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [orange, yellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Uploading Image to Firebase Storage",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Container(
                        height:_imageFile != null
                            ? null
                            :200,
                        width: _imageFile != null
                            ? null
                            :200,
                        margin: const EdgeInsets.only(top: 25.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(60.0),
                            child: _imageFile != null
                                ? Image.file(_imageFile)
                                : Row(
                              children: [
                                FlatButton(
                                  child: Icon(Icons.add_a_photo, size: 55,),
                                  onPressed: checkPermissionOpenCamera,
                                ),
                                FlatButton(
                                  child: Icon(Icons.image_search, size: 55,),
                                  onPressed: checkPermissionOpenGallery,
                                ),
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                uploadImageButton(context),
              ],
            ),
          ),
        ],
      ),
    ));
  }
  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [yellow, orange],
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: FlatButton(
              onPressed: _imageFile == null? null :  () => uploadImageToFirebase(context),
              child: Text(
                "Upload Image",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

