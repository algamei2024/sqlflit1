import 'package:flutter/material.dart';

class buildTextF extends StatelessWidget {
  final String txt;
  var controlle;
  buildTextF(this.txt, this.controlle);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:controlle,
      decoration: InputDecoration(
        labelText:"$txt",
      ),
       validator: (value) {
        if (value!.isEmpty) {
          return 'Ple7ase enter a $txt';
        }
        return null;
      },
    );
  }
}
