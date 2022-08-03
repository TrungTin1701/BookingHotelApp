// ignore_for_file: file_names, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart' ;
import 'package:firebase_database/firebase_database.dart';
import 'package:new_test/CRUDFIREBASE/CourseModel.dart';
import 'package:new_test/main.dart';

import '../../HomePage/homepage.dart';
import 'OneCourse.dart';
 class CourceScreen extends StatelessWidget {
  const CourceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
        title: const Text('Courses',
                      style: TextStyle(color: Colors.white)),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(),
                              ),
                            );
                          },
                        ),
                      
                      ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Cource()
            ],
          ),
        ),
      );
  }
}
