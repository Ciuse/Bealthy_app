import 'package:Bealthy_app/Models/date_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'calendarHomePage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomePageWidget extends StatelessWidget {
  final Color color;

  HomePageWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        CalendarHomePage(),
        Observer(
            builder: (_) => Text(context.read<DateModel>().date.toString() +
                context.read<DateModel>().weekDay.toString())),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDishForm()),
          );
        },
        child: Icon(Icons.navigation),
        backgroundColor: color,
      ),
    );
  }
}




class AddDishForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Second Route"),
        ),
        body: Column(
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')));
                  }
                },
                child: Text('Submit'),
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
        ));
  }
}
