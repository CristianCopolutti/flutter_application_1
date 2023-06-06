import 'package:flutter/material.dart';

class Dispensa extends StatefulWidget {
  const Dispensa({Key? key}) : super(key: key);

  @override
  DispensaState createState() => DispensaState();
}

class DispensaState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DISPENSA"),
        centerTitle: true,
      ),
    );
  }
}
