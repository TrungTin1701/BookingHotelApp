// ignore_for_file: file_names, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:new_test/CRUDFIREBASE/CourseModel.dart';
import 'package:new_test/main.dart';
import 'package:new_test/CRUDFIREBASE/Function/LoadData.dart';
import '../../HomePage/homepage.dart';
import 'OneCourse.dart';

class CourceScreen extends StatefulWidget {
  const CourceScreen({Key? key}) : super(key: key);

  @override
  State<CourceScreen> createState() => _CourceScreenState();
}

class _CourceScreenState extends State<CourceScreen> {
  List<Course> course = [];
  @override
  void initState() {
    getCourse().then((value) => setState(() {
          course = value;
          print("Hehehehe1 +>${course.length}");
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text('Courses', style: TextStyle(color: Colors.white)),
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
        body: ListView.builder(
          itemCount: course.length,
          itemBuilder: (context, index) {
            return OneCourse(course: course[index]);
          },
        ));
  }
}
