import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyScaffold extends StatelessWidget {
  final Widget body;

  const MyScaffold({required this.body});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0Xff285e2f),
          title: Text("Examen ingreso"),
        ),
        body: body
      );
    }
}