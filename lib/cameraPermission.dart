import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';



class CameraPermission extends StatefulWidget {
  @override
  _CameraPermissionState createState() => _CameraPermissionState();
}

class _CameraPermissionState extends State<CameraPermission> {



void initState() {
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
        title: Text("Upload new picture"),
    ),
    body: Container(
      child: Wrap(
        children: <Widget>[
      Card( child:ListTile(
              leading: Icon(Icons.camera_enhance),
              title: Text("Camera"),
              onTap: () async {
                var status = await Permission.camera.status;
                if (!status.isGranted) {
                  requestPermission();
                  print("accesso consentito");
                } else {
                  print("no access");
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Camera Permission'),
                        content: Text(
                            'This app needs camera access to take pictures for upload dishes photo'),
                        actions: <Widget>[
                         FlatButton(
                            child: Text('Deny'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          FlatButton(
                            child: Text('ok'),
                            onPressed: () => requestPermission(),
                          ),
                        ],
                      ));
                }
              }))
        ],
      ),
    ));
  }

requestPermission() async {
  await Permission.camera.request();
  }

}