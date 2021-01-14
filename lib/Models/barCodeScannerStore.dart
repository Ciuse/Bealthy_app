import 'package:mobx/mobx.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as OFF;
import 'package:Bealthy_app/Database/dish.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Bealthy_app/Models/ingredientStore.dart';
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


   @action
   Future<OFF.Product> getProductFromOpenFoodDB(String barcode) async {
      OFF.ProductQueryConfiguration configuration = OFF.ProductQueryConfiguration(barcode, language: OFF.OpenFoodFactsLanguage.ENGLISH, fields: [OFF.ProductField.ALL]);
      OFF.ProductResult result =
      await OFF.OpenFoodAPIClient.getProduct(configuration);

      if (result.status == 1) {

         return result.product;
      } else {
         return null;
      }
   }

   @action
   void createNewDishFromScan(OFF.Product product, IngredientStore ingredientStore){
      List<Ingredient> ingredientsSelectedList = new List<Ingredient>();
      Dish dishToFill = new Dish();
      dishToFill.name = product.productName;
      getLastNumber(dishToFill).then((value) =>dishToFill.id="Dish_User_" + dishToFill.number.toString());

      product.ingredients.forEach((productIngredient) {
         ingredientStore.ingredientList.forEach((ingredient) {
            if(isSubstring(ingredient.name, productIngredient.id) || isSubstring(ingredient.it_Name, productIngredient.id)){
               ingredientsSelectedList.add(ingredient);
            }
            });
      });
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