import 'package:flutter/material.dart';
import 'Models/foodStore.dart';
import 'Database/Dish.dart';
import 'dart:math';
import 'package:provider/provider.dart';

class AddDishForm extends StatefulWidget {
  @override
  _AddDishFormState createState() => _AddDishFormState();
}

class _AddDishFormState extends State<AddDishForm>{
  final categoryCt = TextEditingController();
  final nameCt = TextEditingController();
  String id;
  final qtyCt = TextEditingController();

  void addDish(){
    Random random = new Random();
    int randomNumber = random.nextInt(100);
    Dish dish = new Dish(
      id:randomNumber.toString(),
      name:nameCt.text,
      qty: int.parse(qtyCt.text)
    );

    context.read<FoodStore>().addDishWithCategory(dish, categoryCt.text);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create New Dish"),
        ),
        body: Column(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal:10,vertical: 16.0),
                child:
                Column(
                    children: <Widget>[
                      TextField(
                        controller: categoryCt,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Category',
                        ),
                      ),
                      TextField(
                        controller: nameCt,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                        ),
                      ),
                      TextField(
                        controller: qtyCt,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Qty',
                        ),
                      ),
                    ]
                )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  addDish();
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                },
                child: Text('Add Dish'),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                // Navigate back to first route when tapped.
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),
          ],
        )
    );
  }
}