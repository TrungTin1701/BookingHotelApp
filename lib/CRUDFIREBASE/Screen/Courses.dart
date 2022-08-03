// ignore_for_file: file_names, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart' show AppBar, BuildContext, Center, Column, Key, MainAxisAlignment, Scaffold, StatelessWidget, Text, Widget;
import 'package:firebase_database/firebase_database.dart';
 class CourceScreen extends StatelessWidget {
  const CourceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Courses'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
            ],
          ),
        ),
      );
  }
}