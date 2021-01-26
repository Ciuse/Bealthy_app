import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:Bealthy_app/Models/dateStore.dart';
import 'package:Bealthy_app/Models/ingredientStore.dart';
import 'package:Bealthy_app/Models/mealTimeStore.dart';
import 'package:Bealthy_app/uploadNewPictureToUserDish.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'Database/enumerators.dart';
import 'Database/dish.dart';
import 'Database/ingredient.dart';
import 'Login/config/palette.dart';
import 'Models/barCodeScannerStore.dart';
import 'Models/foodStore.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';

class DishPageFromScan extends StatefulWidget {

  final String barcode;
  Dish dish = new Dish();
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
  String selectedItemIngredient="";

  void initState() {
    super.initState();
    initializeCameras();
    quantityList= getQuantityName();
    ingredientStore = Provider.of<IngredientStore>(context, listen: false);
    barCodeScannerStore = Provider.of<BarCodeScannerStore>(context, listen: false);
    barCodeScannerStore.initProduct();
    foodStore = Provider.of<FoodStore>(context, listen: false);

    ingredientStore.ingredientListOfDish.clear();
    ingredientStore.ingredientsName.clear();
    ingredientStore.getIngredientsName();
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
    widget.dish.name= barCodeScannerStore.productFromQuery.productName;
    widget.dish.barcode= widget.barcode;
    getLastNumber().then((value) =>widget.dish.id="Dish_User_" + widget.dish.number.toString());
    getImageFileDish();
    barCodeScannerStore.ingredients.clear();
    barCodeScannerStore.initIngredients(ingredientStore, foodStore);
  }

  bool findIngredient(Ingredient ingredient){
    bool toReturn = false;
    barCodeScannerStore.ingredients.forEach((element) {
      if(element.id==ingredient.id){
        toReturn = true;
        return toReturn;
      }
    });
    return toReturn;
  }


  @override
  Widget build(BuildContext context) {
    MealTimeStore mealTimeStore = Provider.of<MealTimeStore>(context);
    DateStore dateStore = Provider.of<DateStore>(context);
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:  Text(barCodeScannerStore.scanBarcode),
      ),
      body: OKToast( child:
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
              if(barCodeScannerStore.productFromQuery!=null){
                initializeDishFromProduct();
                Ingredient toAdd;
                return SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child:Column(
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 4,left: 4,right: 4),
                              child: Card(
                                elevation: 0,
                                child:Observer(builder: (_) =>Container(
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
                                                      color: Palette.bealthyColorScheme.secondary,)),]
                                          )
                                        ])

                                )),
                              )),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                              child: Card(child:
                              ListTile(
                                  title: Text("Name: ",style: TextStyle(fontWeight:FontWeight.bold,fontSize:19)),
                                  trailing: TextButton(child:
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [Expanded(
                                        flex:2,
                                        child:
                                        Observer(builder: (_) =>widget.dish.name==null? Text(barCodeScannerStore.productFromQuery.productName, textAlign: TextAlign.left)
                                            : Text(widget.dish.name,maxLines:2,softWrap: false,overflow: TextOverflow.ellipsis,textAlign: TextAlign.end,))),
                                      SizedBox(width: 8,),
                                      Flexible(
                                          flex: 1,
                                          child: Icon(Icons.mode_rounded,)),
                                    ],
                                  ),
                                      onPressed: () =>{
                                        showDialog(
                                          context: context,
                                          builder: (_) =>  new  AlertDialog(

                                            title: Center(child: Text("Change dish name",style: TextStyle(fontWeight: FontWeight.bold,),)),
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children : <Widget>[
                                                Expanded(
                                                  child: TextFormField(
                                                    autovalidateMode: AutovalidateMode.disabled,
                                                    controller: titleCt,
                                                    maxLength: 25,
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
                                                  ),
                                                )
                                              ],
                                            ),
                                            contentPadding: EdgeInsets.only(top: 8, left: 10, right: 10),
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
                                                  widget.dish.name= titleCt.text;
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('ACCEPT'),
                                              ),
                                            ],
                                          ),
                                        )
                                      })
                              ))),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                              child: ingredientsWidget()),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                              child: Container(
                                  height: 95,
                                  child:Card(child:Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                          fit: FlexFit.loose,
                                          flex:5,
                                          child: ListTile(
                                            title: Text("Add ingredients!"),
                                          )),
                                      Expanded(
                                          flex:5,
                                          child:
                                          Padding(
                                              padding: const EdgeInsets.all(16),
                                              child:DropdownSearch<String>(
                                                mode: Mode.MENU,
                                                dropdownSearchDecoration:  new InputDecoration(
                                                  labelText: "Select",
                                                  fillColor: Colors.white,
                                                  contentPadding: EdgeInsets.all(4),
                                                  border: new OutlineInputBorder(
                                                    borderRadius: new BorderRadius.circular(15.0),
                                                    borderSide: new BorderSide(
                                                    ),
                                                  ),
                                                  //fillColor: Colors.green
                                                ),
                                                //  showSearchBox: true,
                                                items: ingredientStore.ingredientsName,
                                                autoValidateMode: AutovalidateMode.onUserInteraction,
                                                validator:  (val) {
                                                  if(barCodeScannerStore.ingredients.length==0) {
                                                    return "Insert at least one ingredient";
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                onChanged: (String ingredient)=> {
                                                  selectedItemIngredient="",
                                                  if(!findIngredient(ingredientStore.getIngredientFromName(ingredient))){
                                                    toAdd = ingredientStore.getIngredientFromName(ingredient),
                                                    toAdd.qty=Quantity.Normal.toString().split('.').last,
                                                    barCodeScannerStore.ingredients.add(toAdd),
                                                    ingredientStore.ingredientsName.remove(ingredient),
                                                  }else{
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                        new AlertDialog(
                                                          title: Center(child: Text("Ingredient already inserted")),
                                                          contentPadding: EdgeInsets.only(top: 8, left: 10, right: 10),
                                                          actionsPadding: EdgeInsets.only(bottom: 5,right: 5),
                                                          actions: [
                                                            FlatButton(
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text('OK'),
                                                            ),
                                                          ],
                                                        )),

                                                  }


                                                },
                                              ))),
                                    ],)))),



                          barCodeScannerStore.scanBarcode != "-1"? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: ElevatedButton(
                                child:  Text('ADD DISH'),
                                style: ElevatedButton.styleFrom(primary: Palette.bealthyColorScheme.primary),
                                onPressed: (){
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
                                              foodStore.addNewDishScannedByUser(widget.dish, barCodeScannerStore.ingredients,ingredientStore);
                                              if(widget.dish.imageFile!=null){
                                                uploadImageToFirebase(context,widget.dish.imageFile);
                                              }
                                              mealTimeStore.addScannedDishOfMealTimeListOfSpecificDay(widget.dish, dateStore.calendarSelectedDate)
                                                  .then((value) => Navigator.of(context).popUntil((route) => route.isFirst)
                                              );
                                            },
                                            child: Text('ADD DISH'),
                                          ),
                                        ],
                                      )
                                  );
                                },
                                       )
                          ): Container()
                        ]
                    )
                );
              }
              else{
                return Center(
                    child: Container(
                        padding: EdgeInsets.all(40),
                        child:Text("Can't find any product with this barcode in our Database: "+ barCodeScannerStore.scanBarcode )
                    ));
              }
              break;
            case FutureStatus.pending:
            default:
              return Center(child:CircularProgressIndicator());
          }
        },

      )),
    );
  }


  int getQuantityEnumIndex(String name){
    int i =0;
    int toReturn=0;
    Quantity.values.forEach((element) {
      if (element.toString().contains(name))
      {
        toReturn=i;
      }i++;
    }
    );
    return toReturn;
  }

  Widget ingredientsWidget(){
    return Card(
        child: Column(
            children:[
              ListTile(
                title: Text("Ingredients",style: TextStyle(fontWeight:FontWeight.bold)),
                leading: Icon(Icons.fastfood_outlined,color: Colors.black),
                trailing: Padding(
                    padding: EdgeInsets.only(right: 15),
                    child:Text("Quantity",style: TextStyle(fontWeight:FontWeight.bold,fontSize:20))),
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
                                    Observer(builder: (_) =>ListTile(
                                      title: Text(barCodeScannerStore.ingredients[index].name),
                                      leading: Image(image:AssetImage("images/ingredients/" + barCodeScannerStore.ingredients[index].id + ".png"), height: 35,width:35,),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,

                                        children: [
                                          TextButton(child:
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(barCodeScannerStore.ingredients[index].qty, textAlign: TextAlign.left),
                                              Icon(Icons.mode_rounded,),
                                            ],
                                          ),
                                              onPressed: () =>{
                                                barCodeScannerStore.ingredients[index].valueShowDialog=getQuantityEnumIndex(barCodeScannerStore.ingredients[index].qty),
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>  new AlertDialog(
                                                      title: Text('Change Quantity'),
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
                                                                groupValue:  barCodeScannerStore.ingredients[index].valueShowDialog,
                                                                onChanged: (int value) {
                                                                  barCodeScannerStore.ingredients[index].valueShowDialog=value;
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
                                                            barCodeScannerStore.ingredients[index].qty=Quantity.values[barCodeScannerStore.ingredients[index].valueShowDialog].toString().split('.').last;
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('ACCEPT'),
                                                        ),
                                                      ],
                                                    )
                                                )
                                              }),
                                          IconButton(
                                            splashRadius: 20,
                                            padding: EdgeInsets.all(0),
                                            icon: Icon(Icons.delete),
                                            onPressed: (){
                                              showDialog(
                                                  context: context,
                                                  builder: (_) =>  new AlertDialog(
                                                    title: Text('Delete ingredient'),
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
                                                          String ingredientName = barCodeScannerStore.ingredients[index].name;
                                                          barCodeScannerStore.ingredients.removeAt(index);
                                                          if(!ingredientStore.ingredientsName.contains(ingredientName)){
                                                            ingredientStore.ingredientsName.add(ingredientName);
                                                          }

                                                          Navigator.pop(context);
                                                        },
                                                        child: Text('DELETE'),
                                                      ),
                                                    ],
                                                  )
                                              );

                                            },
                                          ),
                                        ],
                                      ),
                                    ))),
                                index!=barCodeScannerStore.ingredients.length-1?
                                Divider(
                                  height: 0,
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
