import 'package:flutter/material.dart';

class HomePageWidget extends StatelessWidget {
  final Color color;

  HomePageWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: const Text('Press the button below!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.navigation),
        backgroundColor: color,
      ),
    );
  }
}