// ignore_for_file: file_names, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:new_test/CRUDFIREBASE/CourseModel.dart';
import 'package:new_test/CRUDFIREBASE/Screen/CreateCourse.dart';
import 'package:new_test/CRUDFIREBASE/Screen/EditCourse.dart';
import 'package:new_test/main.dart';
import 'package:new_test/CRUDFIREBASE/Function/LoadData.dart';
import '../../HomePage/homepage.dart';
import 'OneCourse.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_core/firebase_core.dart';

class CourceScreen extends StatefulWidget {
  const CourceScreen({Key? key}) : super(key: key);

  @override
  State<CourceScreen> createState() => _CourceScreenState();
}

class _CourceScreenState extends State<CourceScreen> {
  List<Course> course = [];
  final CollectionReference _courses =
      FirebaseFirestore.instance.collection('Course');
  Future<void> _delete(String id) async {
    await _courses.doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: kPrimaryColor,
        content: Text("You have successfully deleted the course")));
  }

  @override
  void initState() {
    _courses.snapshots().listen((event) {
      setState(() {
        ///get id

        course = event.docs
            .map((doc) => Course.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    });

    // getCourse().then((value) => setState(() {
    //       course = value;
    //       print("Hehehehe1 +>${course.length}");
    //     }));

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
                    builder: (context) => CreateCourse(),
                  ),
                );
              },
            ),
          ],
        ),
        body: StreamBuilder(
            stream: _courses.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                print("HEHEHHE=> ${streamSnapshot.data?.docs.length}");
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    //var course1 = Course.fromJson(document);
                    return Slidable(
                        key: ValueKey(index),
                        startActionPane:
                            ActionPane(motion: ScrollMotion(), children: [
                          SlidableAction(
                            icon: Icons.delete,
                            backgroundColor: Color.fromRGBO(255, 82, 82, 1),
                            label: "Delete",
                            onPressed: (context) {
                              _delete(documentSnapshot.id);
                            },
                          ),
                          SlidableAction(
                              onPressed: (context) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditCourse(
                                      documentSnapshot: documentSnapshot,
                                    ),
                                  ),
                                );
                              },
                              icon: Icons.edit,
                              backgroundColor: kPrimaryColor,
                              label: "Edit "),
                        ]),
                        child: OneCourse(course: course[index]));
                  },
                );
              }

              return Center(child: CircularProgressIndicator());
            }));
  }
}
