// ignore_for_file: file_names, unused_import, avoid_function_literals_in_foreach_calls, avoid_print

import 'package:new_test/CRUDFIREBASE/CourseModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<String> docID = [];
Future getDocID() async {
  await FirebaseFirestore.instance
      .collection("Course")
      .get()
      .then((snapshot) => snapshot.docs.forEach((documnet) {
            print(documnet.reference);
            docID.add(documnet.reference.id);
            print(docID.length);
          }));
}

Future<List<Course>> getCourse() async {
  List<Course> course = [];
  await FirebaseFirestore.instance
      .collection("Course")
      .get()
      .then((snapshot) => snapshot.docs.forEach((documnet) {
            course.add(Course.fromJson(documnet.data()));
            print("Hehehehe +>${documnet.data()['DateStart']}");
          }));
  print("Hehheehhe +>${course.length}");
  return course;
}
