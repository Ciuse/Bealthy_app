import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:provider/provider.dart';

import 'Login/config/palette.dart';
import 'Models/userStore.dart';


class UploadNewProfileImage extends StatefulWidget {
  final CameraDescription camera;
  UploadNewProfileImage({@required this.camera});

  @override
  _UploadNewProfileImageState createState() =>
      _UploadNewProfileImageState();
}

class _UploadNewProfileImageState extends State<UploadNewProfileImage> {
  File _imageFile;
  final Color yellow = Color(0xfffbc31b);
  final Color orange = Color(0xfffb6900);
  final picker = ImagePicker();
  UserStore userStore;

  void initState() {
    super.initState();
    userStore = Provider.of<UserStore>(context, listen: false);

  }


  void checkPermissionOpenGallery() async{
    var galleryStatus = await Permission.storage.status;


    if(!galleryStatus.isGranted){
      print("richiesta permessi");
      await Permission.storage.request();
    }

    if(await Permission.storage.isGranted){
      pickImageFromGallery().then((value) => _cropImage());
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
      await pickImageWithCamera().then((value) => _cropImage());
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
    String userUid;
    final litUser = context.getSignedInUser();
    litUser.when(
          (user) => userUid=user.uid,
      empty: () => Text('Not signed in'),
      initializing: () => Text('Loading'),
    );

      String fileName = "UserProfileImage.jpg";
      var firebaseStorageRef = FirebaseStorage.instance.ref().child(userUid+'/UserProfileImage/$fileName');
      firebaseStorageRef.putFile(_imageFile);
      userStore.profileImage=_imageFile;
      Navigator.pop(context);

  }

  Widget build(BuildContext context) {
    return OKToast(
        child:Scaffold(
          appBar: AppBar(
            title: Text("Add Profile Picture"),
          ),
          body: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height/5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0)),
                    gradient: LinearGradient(
                        colors: [Palette.primaryDark, Palette.primaryLight,Palette.primaryMoreLight,],
                        begin: Alignment.bottomLeft,
                        end: Alignment.bottomRight)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Take or load a picture",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Expanded(
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 15.0),
                            child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            FlatButton(
                                              child: Icon(Icons.add_a_photo, size: 55,),
                                              onPressed: checkPermissionOpenCamera,
                                            ),
                                            SizedBox(width: 30.0),
                                            FlatButton(
                                              child: Icon(Icons.image_search, size: 55,),
                                              onPressed: checkPermissionOpenGallery,
                                            ),

                                          ],
                                        )),
                                    SizedBox(height: 10.0),
                                    Flexible(
                                      flex: 4,
                                      child: _imageFile != null
                                          ? ClipRRect(
                                          borderRadius: BorderRadius.circular(40.0),
                                          child:Image.file(_imageFile,)) : Container(),)
                                  ],)
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

  Future<Null> _cropImage() async {
    print("entrato");
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatioPresets:
        [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        );
    if(croppedFile!=null){
      setState(() {
        _imageFile = File(croppedFile.path);
      });
    }
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
                  colors: [Palette.primaryDark, Palette.primaryLight,Palette.primaryMoreLight,],
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
