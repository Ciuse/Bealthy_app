import 'dart:io';
import 'dart:ui';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/ingredientStore.dart';
import 'package:Bealthy_app/Models/mealTimeStore.dart';
import 'package:Bealthy_app/uploadNewPictureToUserDish.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'Database/enumerators.dart';
import 'Database/dish.dart';
import 'Login/config/palette.dart';
import 'Models/barCodeScannerStore.dart';
import 'Models/foodStore.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';

class DishPageFromScan extends StatefulWidget {

  final String barcode;
  Dish dish;
  DishPageFromScan({@required this.barcode});

  @override
  _DishPageFromScanState createState() => _DishPageFromScanState();
}

class _DishPageFromScanState extends State<DishPageFromScan>{
  var storage = FirebaseStorage.instance;
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  List<String> quantityList;
  IngredientStore ingredientStore;
  BarCodeScannerStore barCodeScannerStore;
  FoodStore foodStore;
  final titleCt = TextEditingController();
  List<CameraDescription> cameras;

  void initState() {
    super.initState();
    initializeCameras();
    quantityList= getQuantityName();
    ingredientStore = Provider.of<IngredientStore>(context, listen: false);
    barCodeScannerStore = Provider.of<BarCodeScannerStore>(context, listen: false);
    barCodeScannerStore.initProduct();
    foodStore = Provider.of<FoodStore>(context, listen: false);

  }

  @override
  void dispose() {
    super.dispose();
  }



  Future<void> initializeCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();

  }

  Future<void> getLastNumber() async {
    widget.dish.number = await foodStore.getLastCreatedDishId();
  }

  Future<void> getImageFileDish() async {
    widget.dish.imageFile = await barCodeScannerStore.urlToFile(barCodeScannerStore.productFromQuery.imgSmallUrl);
  }




  List<String> getQuantityName(){
    List<String> listToReturn = new List<String>();
    Quantity.values.forEach((element) {
      listToReturn.add(element.toString().split('.').last);
    });
    return listToReturn;
  }



  void setQuantityAndMealTimeToDish(String qty){
    MealTimeStore mealTimeStore = Provider.of<MealTimeStore>(context, listen: false);
    widget.dish.mealTime = mealTimeStore.selectedMealTime.toString().split('.').last;
    widget.dish.qty = qty;
  }

  openCamera()  {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadNewPictureToUserDish(camera: cameras.first,dish: widget.dish,uploadingOnFirebase: false),
      ),
    );
  }

  Future uploadImageToFirebase(BuildContext context,File imageFile) async {
    String userUid;
    final litUser = context.getSignedInUser();
    litUser.when(
          (user) => userUid=user.uid,
      empty: () => Text('Not signed in'),
      initializing: () => Text('Loading'),
    );
    String fileName = widget.dish.id+".jpg";
    var firebaseStorageRef = FirebaseStorage.instance.ref().child(userUid+'/DishImage/$fileName');
    firebaseStorageRef.putFile(imageFile);
    Navigator.pop(context);


  }

  void initializeDishFromProduct() async{
    widget.dish = new Dish(name: barCodeScannerStore.productFromQuery.productName, barcode: widget.barcode);
    getLastNumber().then((value) =>widget.dish.id="Dish_User_" + widget.dish.number.toString());
    getImageFileDish();
    barCodeScannerStore.initIngredients(ingredientStore, foodStore);
  }


  @override
  Widget build(BuildContext context) {
    MealTimeStore mealTimeStore = Provider.of<MealTimeStore>(context);
    DateStore dateStore = Provider.of<DateStore>(context);
    return   Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("widget.dish.name"),
        actions: [
          IconButton(
              alignment: Alignment.centerLeft,
              icon: Icon(
                Icons.mode_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                return showDialog(
                  context: context,
                  builder: (_) =>  new  AlertDialog(
                      title: Center(child: Text("Modify the name of ${widget.dish.name}",style: TextStyle(fontWeight: FontWeight.bold,),)),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children : <Widget>[
                          Expanded(
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.disabled,
                              controller: titleCt,
                              decoration: new InputDecoration(
                                labelText: 'Name',
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
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
                          )
                        ],
                      ),
                      actions: <Widget> [
                        RaisedButton(

                            onPressed:  () {
                              widget.dish.name= titleCt.text;
                              Navigator.of(context).pop();
                            },
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Palette.primaryDark,
                                    Palette.primaryLight,
                                    Palette.primaryMoreLight,
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              child: Text("OK" , style: TextStyle(fontSize: 20)),)
                        )]
                  ),
                );
              }
          ),
        ],
      ),
      body: Center(child:SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(child:
          Observer(
            builder: (_) {
              switch (barCodeScannerStore.loadProduct.status) {
                case FutureStatus.rejected:
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Oops something went wrong'),
                        RaisedButton(
                          child: Text('Retry'),
                          onPressed: () async {
                          },
                        ),
                      ],
                    ),
                  );
                case FutureStatus.fulfilled:
                  initializeDishFromProduct();
                  return Column(
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
                                            color: Palette.bealthyColorScheme.primaryVariant,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: widget.dish.imageFile==null? null:
                                          Image.file(widget.dish.imageFile, fit: BoxFit.cover,),
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
                        ingredientsWidget(),
                        SizedBox(height: 20,)
                      ]
                  );
                case FutureStatus.pending:
                default:
                  return CircularProgressIndicator();
              }
            },
          )
          )
      )),
      floatingActionButton: FloatingActionButton(

        onPressed: () {

          return showDialog(
            context: context,
            builder: (_) =>  new AlertDialog(
              title: Text('Select the quantity eaten'),
              content: Observer(builder: (_) => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  for (int i = 0; i < Quantity.values.length; i++)
                    ListTile(
                      title: Text(
                        Quantity.values[i].toString().split('.').last,
                      ),
                      leading: Radio(
                        value: i,
                        groupValue: widget.dish.valueShowDialog,
                        onChanged: (int value) {
                          widget.dish.valueShowDialog=value;
                        },
                      ),
                    ),
                  Divider(
                    height: 4,
                    thickness: 0.8,
                    color: Colors.black,
                  ),
                ],
              )),
              contentPadding: EdgeInsets.only(top: 8),
              actionsPadding: EdgeInsets.only(bottom: 5,right: 5),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('CANCEL'),
                ),
                FlatButton(
                  onPressed: () {
                    setQuantityAndMealTimeToDish(quantityList[widget.dish.valueShowDialog]);
                    mealTimeStore.addDishOfMealTimeListOfSpecificDay(widget.dish, dateStore.calendarSelectedDate)
                        .then((value) => Navigator.of(context).popUntil((route) => route.isFirst)
                    );
                  },
                  child: Text('ACCEPT'),
                ),
              ],
            )
          );


        },
        child: Icon(Icons.add ),
      ),
    );
  }

  Widget ingredientsWidget(){
    return Card(
        child: Column(
            children:[
              ListTile(
                title: Text("Ingredients",style: TextStyle(fontWeight:FontWeight.bold,fontSize:19)),
                leading: Icon(Icons.fastfood_outlined,color: Colors.black),
              ),
              Divider(
                thickness: 0.8,
                color: Colors.black54,
              ),
              Observer(
                builder: (_) {
                  switch (barCodeScannerStore.loadIngredients.status) {
                    case FutureStatus.rejected:
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Oops something went wrong'),
                            RaisedButton(
                              child: Text('Retry'),
                              onPressed: () async {
                              },
                            ),
                          ],
                        ),
                      );
                    case FutureStatus.fulfilled:
                      return  Observer(builder: (_) => ListView.builder
                        (
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: barCodeScannerStore.ingredients.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Container(
                                    child:
                                    ListTile(
                                      title: Text(barCodeScannerStore.ingredients[index].name),
                                      subtitle:Text(barCodeScannerStore.ingredients[index].qty),
                                      leading: Image(image:AssetImage("images/ingredients/" + barCodeScannerStore.ingredients[index].id + ".png"), height: 40,width:40,),
                                    )),
                                index!=barCodeScannerStore.ingredients.length-1?
                                Divider(
                                  height: 4,
                                  thickness: 0.5,
                                  indent: 20,
                                  endIndent: 20,
                                  color: Colors.black38,
                                ):Container(),
                              ],
                            );
                          }
                      ));
                    case FutureStatus.pending:
                    default:
                      return CircularProgressIndicator();
                  }
                },
              )

            ]
        )
    );
  }
}
