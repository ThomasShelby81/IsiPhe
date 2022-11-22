import 'package:flutter/material.dart';

class OpenMealRoute extends StatelessWidget {
  const OpenMealRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahlzeit auswählen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: const Text('Zurück'),
        ),
      ),
    );
  }
}
