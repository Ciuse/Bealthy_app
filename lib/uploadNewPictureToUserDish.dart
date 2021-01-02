import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

import 'Database/dish.dart';



class UploadNewPictureToUserDish extends StatefulWidget {
  final CameraDescription camera;
  final Dish dish;
  UploadNewPictureToUserDish({@required this.camera,@required this.dish});

  @override
  _UploadNewPictureToUserDishState createState() =>
      _UploadNewPictureToUserDishState();
}

class _UploadNewPictureToUserDishState extends State<UploadNewPictureToUserDish> {
  File _imageFile;
  final Color yellow = Color(0xfffbc31b);
  final Color orange = Color(0xfffb6900);
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if(pickedFile!=null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }

  }



  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = widget.dish.id+".jpg";
    var firebaseStorageRef = FirebaseStorage.instance.ref().child('DishImage/$fileName');
    var uploadTask = firebaseStorageRef.putFile(_imageFile);
    await uploadTask.whenComplete(() async{
          await firebaseStorageRef.getDownloadURL().then(

                (value) => Navigator.pop(context,value),
          );
    });

  }

  @override
  Widget build(BuildContext context) {
    print("open uploading page");
    return Scaffold(
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
                            :100,
                        width: _imageFile != null
                            ? null
                            :100,
                        margin: const EdgeInsets.only(top: 25.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60.0),
                          child: _imageFile != null
                              ? Image.file(_imageFile)
                              : FlatButton(
                            child: Icon(
                              Icons.add_a_photo,
                              size: 55,
                            ),
                            onPressed: pickImage,
                          ),
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
    );
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
              onPressed: () => uploadImageToFirebase(context),
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

  String nameOfPicture(String path) {
    return "";
  }
}


