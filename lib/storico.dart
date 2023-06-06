import 'package:flutter/material.dart';

class Storico extends StatefulWidget {
  const Storico({Key? key}) : super(key: key);

  @override
  StoricoState createState() => StoricoState();
}

class StoricoState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("STORICO"),
        centerTitle: true,
      ),
    );
  }
}
