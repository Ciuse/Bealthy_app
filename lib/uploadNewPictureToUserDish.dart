import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'Database/dish.dart';
import 'package:Bealthy_app/Models/mealTimeStore.dart';
import 'package:provider/provider.dart';

import 'Login/config/palette.dart';


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
  final picker = ImagePicker();
  MealTimeStore mealTimeStore;
  void initState() {
    super.initState();

    mealTimeStore = Provider.of<MealTimeStore>(context, listen: false);
  }

  void checkPermissionOpenGallery() async{
    var galleryStatus = await Permission.storage.status;


    if(!galleryStatus.isGranted){
      await Permission.storage.request();
    }

    if(await Permission.storage.isGranted){
      pickImageFromGallery().then((value) => _cropImage());
    }else{
      showToast("Bealthy needs to access your Gallery, please provide permission", position: ToastPosition.bottom, duration: Duration(seconds: 4));
      openAppSettings2();
    }

  }

  void checkPermissionOpenCamera() async{
    var cameraStatus = await Permission.camera.status;

    if (!cameraStatus.isGranted)
    {await Permission.camera.request();}


    if(await Permission.camera.isGranted){
      await pickImageWithCamera().then((value) => _cropImage());
    }else{
      showToast("Provide Camera permission to use camera.", position: ToastPosition.bottom, duration: Duration(seconds: 4));
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
      });
    }
  }

  Future pickImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      setState(() {
        _imageFile = File(pickedFile.path);
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


  Widget build(BuildContext context) {
    return OKToast(
        child:Scaffold(
            appBar: AppBar(
              title: Text("Dish Picture"),
              bottom: PreferredSize(
                child:
                ListTile(
                  title: Text(
                    "",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20,color: Colors.white),
                  ),
                ),
                preferredSize: Size(50,50),
              ),
            ),
            body:  Container(
                margin: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                child:Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SingleChildScrollView(
                      child:
                      Container(
                          margin: const EdgeInsets.only(top: 15.0),
                          child:Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 20.0),
                              _imageFile != null
                                  ? Image.file(_imageFile, height: MediaQuery.of(context).orientation==Orientation.landscape?500:null,) : Image(image:AssetImage("images/placeholder-image.png"),)
                            ],)
                      ),),
                    uploadImageButton(context),
                  ],
                )),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
            floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    child: Icon(
                        Icons.add_a_photo,size: 33
                    ),
                    onPressed: () {
                      checkPermissionOpenCamera();
                    },
                    heroTag: null,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    child: Icon(
                      Icons.image_search,size: 33,
                    ),
                    onPressed: () => {checkPermissionOpenGallery()},
                    heroTag: null,
                  ),SizedBox(
                    width: 15,
                  ),
                ]
            )));
  }
  Future<Null> _cropImage() async {
    if(_imageFile!=null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Palette.bealthyColorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            showCropGrid: false,
            lockAspectRatio: true),
      );
      if (croppedFile != null) {
        setState(() {
          _imageFile = File(croppedFile.path);
        });
      }
    }
  }

  Widget uploadImageButton(BuildContext context) {
    return Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: _imageFile == null? null :  () =>
            {
              uploadImageToFirebase(context),
              widget.dish.imageFile = _imageFile,
              mealTimeStore.changeImageToAllSameDishes(widget.dish)},
            child: Text(
              "Save Image",
              style: TextStyle(fontSize: 22),
            ),
          ),

        ));
  }

}

