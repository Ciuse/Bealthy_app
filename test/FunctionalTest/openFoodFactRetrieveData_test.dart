import 'dart:convert';
import 'dart:io';
import 'package:Bealthy_app/Database/dish.dart';
import 'package:Bealthy_app/Database/enumerators.dart';
import 'package:Bealthy_app/Database/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as OFF;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

int status;
List<Ingredient> ingredientsExistingProduct = new List<Ingredient>();
List<Ingredient> noIngredientsExistingProduct = new List<Ingredient>();

String fixture(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('test')) {
    dir = dir.replaceAll('test', '');
  }
  return File('$dir/test/fixture/$name').readAsStringSync();
}

Future<List<Ingredient>> getIngredients() async {
  return Future.value([
    Ingredient(id:"Ingr_25",name:"Butter",it_Name:"Burro",qty:"" ),
    Ingredient(id:"Ingr_18",name:"Wheat",it_Name:"Grano",qty:"" ),
    Ingredient(id:"Ingr_3",name:"salt",it_Name:"sale",qty:"" ),
    Ingredient(id:"Ingr_15",name:"Oil",it_Name:"Olio",qty:"" ),
    Ingredient(id:"Ingr_15",name:"Flour",it_Name:"Farina",qty:"" ),
    Ingredient(id:"Ingr_1",name:"Cocoa",it_Name:"Cacao",qty:"" ),
    Ingredient(id:"Ingr_8",name:"Sugar",it_Name:"Zucchero",qty:"" ),
    Ingredient(id:"Ingr_10",name:"Milk",it_Name:"Latte",qty:"" ),
  ]);
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


Future<OFF.Product> getProductFromOpenFoodDB(String barcode) async {
  OFF.ProductQueryConfiguration configuration = OFF.ProductQueryConfiguration(barcode, language: OFF.OpenFoodFactsLanguage.ENGLISH, fields: [OFF.ProductField.ALL]);
  print(configuration);
  OFF.ProductResult result =
  await OFF.OpenFoodAPIClient.getProduct(configuration);
  status= result.status;
  print(result.status);
  if (result.status == 1) {
    return result.product;
  } else {
    return null;
  }
}

Future<void> getIngredientsProductFromQuery(OFF.Product productFromQuery,List<Ingredient> ingredientList) async {

  if(productFromQuery.ingredients!=null)
  {
    productFromQuery.ingredients.forEach((productIngredient) {
      ingredientList.forEach((ingredient) {
        if (isSubstring(ingredient.name, productIngredient.id) ||
            isSubstring(ingredient.it_Name, productIngredient.id)) {
          if(productFromQuery.barcode=="3017620422003"){
            if (!ingredientsExistingProduct.contains(ingredient)) {
              ingredient.qty = Quantity.Normal
                  .toString()
                  .split('.')
                  .last;
              ingredientsExistingProduct.add(ingredient);
            }
          }else{
            if (!noIngredientsExistingProduct.contains(ingredient)) {
              ingredient.qty = Quantity.Normal
                  .toString()
                  .split('.')
                  .last;
              noIngredientsExistingProduct.add(ingredient);
            }
          }
        }
      });
    });
    
  }
}

Future<void> main() async {
  OFF.Product productFromQueryNotExisting = await getProductFromOpenFoodDB("3017620422007");
  OFF.Product productFromQueryExisting = await getProductFromOpenFoodDB("3017620422003"); //nutella
  OFF.Product productFromQueryExistingNoIngredients = await getProductFromOpenFoodDB("8009030055204"); //chiacchiere
  List<Ingredient> ingredientListFromOurDB = await getIngredients();
  await getIngredientsProductFromQuery(productFromQueryExisting,ingredientListFromOurDB);
  await getIngredientsProductFromQuery(productFromQueryExistingNoIngredients,ingredientListFromOurDB);


  group("Product from OpenFoodFacts database test", ()
  {
    test('Check product existing file', () async {
      expect(productFromQueryExisting.productName, equals("Nutella Ferrero"));
    });

    test('Verify product does not exist ', () async {
      expect(productFromQueryNotExisting, equals(null));
    });

    test('test list ingredients product with correspondence ', () async {
      expect(productFromQueryExisting.productName, equals("Nutella Ferrero"));
      expect(productFromQueryExisting.ingredients.length, greaterThan(0));
      //il prodotto corrisponde alla nutella e il nostro algoritmo trova 4 corrispondenze di ingredienti
      expect(ingredientsExistingProduct.length, equals(4));
    });

    test('test list ingredients product , no correspondence', () async {
      //il prodotto corrisponde non ha alcuna corrispondenza con i nostri ingredienti
      expect(productFromQueryExistingNoIngredients.productName, equals("Chiacchiere"));
      expect(productFromQueryExistingNoIngredients.ingredients, equals(null));
      expect(noIngredientsExistingProduct.length, equals(0));
    });
  });
}