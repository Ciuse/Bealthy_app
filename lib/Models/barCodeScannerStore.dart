
import 'dart:io';
import 'dart:math';
import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Models/foodStore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobx/mobx.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as OFF;
import 'package:Bealthy_app/Database/dish.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Bealthy_app/Models/ingredientStore.dart';
import 'package:path_provider/path_provider.dart';
import '../Database/ingredient.dart';

// Include generated file
part 'barCodeScannerStore.g.dart';


FirebaseAuth auth = FirebaseAuth.instance;
// This is the class used by rest of your codebase
class BarCodeScannerStore = _BarCodeScannerStoreBase with _$BarCodeScannerStore;

// The store-class
abstract class _BarCodeScannerStoreBase with Store {
   final firestoreInstance = FirebaseFirestore.instance;

   @observable
   String scanBarcode = 'Unknown';

   @observable
   List<Ingredient> ingredients = new ObservableList<Ingredient>();


   @action
   Future<OFF.Product> getProductFromOpenFoodDB(String barcode) async {
      OFF.ProductQueryConfiguration configuration = OFF.ProductQueryConfiguration(barcode, language: OFF.OpenFoodFactsLanguage.ENGLISH, fields: [OFF.ProductField.ALL]);
      OFF.ProductResult result =
      await OFF.OpenFoodAPIClient.getProduct(configuration);

      if (result.status == 1) {
         print(result.product.images);
            print(result.product.imgSmallUrl);
         return result.product;
      } else {
         return null;
      }
   }

   @action
   Future<void> getIngredients(OFF.Product product, IngredientStore ingredientStore, FoodStore foodStore) async {


      product.ingredients.forEach((productIngredient) {
         ingredientStore.ingredientList.forEach((ingredient) {
            if(isSubstring(ingredient.name, productIngredient.id) || isSubstring(ingredient.it_Name, productIngredient.id)){
               if(!ingredients.contains(ingredient)){
                  ingredient.qty= Quantity.Normal.toString().split('.').last;
                  ingredients.add(ingredient);

               }

            }
            });
      });

   }


   Future<File> urlToFile(String imageUrl) async {
// generate random number.
      var rng = new Random();
// get temporary directory of device.
      Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
      String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
      File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
// call http.get method and pass imageUrl into it to get response.
      http.Response response = await http.get(imageUrl);
// write bodyBytes received in response to file.
      await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
      return file;
   }

   Future<void> getLastNumber(Dish dish) async {
      dish.number = await getLastCreatedDishId();
   }

   Future<int> getLastCreatedDishId() async {
      return await FirebaseFirestore.instance.collection('DishesCreatedByUsers')
          .doc(auth.currentUser.uid).collection("Dishes")
          .orderBy("number")
          .limitToLast(1)
          .get()
          .then((querySnapshot) {
         int toReturn=0;
         if(querySnapshot.size>0){
            querySnapshot.docs.forEach((dish) {
               toReturn = dish.get("number")+1;
            });
         }
         else{
            toReturn = 0;
         }
         return toReturn;
      });

   }

   @action
   double rankValueIngredient(int count){
      double value;
      if(count==1){
         value = 1.0;
      }
      if(count==2){
         value = 0.95;
      }
      if(count==3){
         value = 0.8;
      }
      if(count==4){
         value = 0.65;
      }
      if(count==5){
         value = 0.5;
      }
      if(count==6){
         value = 0.3;
      }
      if(count==7){
         value = 0.25;
      }
      if(count==8){
         value = 0.15;
      }
      return value;
   }

   bool isSubstring(String s1, String s2) {
      s1=s1.toLowerCase();
      s2=s2.toLowerCase();

      int M = s1.length;
      int N = s2.length;

/* A loop to slide pat[] one by one */
      for (int i = 0; i <= N - M; i++) {
         int j;

/* For current index i, check for
 pattern match */
         for (j = 0; j < M; j++)
            if (s2[i + j] != s1[j])
               break;

         if (j == M)
            return true; // il piatto è stato creato dall'utente
      }

      return false; //il piatto non è stato creato dall'utente

   }

}