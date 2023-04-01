// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  Timestamp? DateStart;
  Timestamp? DateEnd;
  String? Name;
  String? Description;

  String? Image;
  int? Price;
  Course({
    this.DateStart,
    this.DateEnd,
    this.Name,
    this.Description,
    this.Image,
    this.Price,
  });
  factory Course.fromJson(Map<String, dynamic> json) => Course(
        DateStart: json["DateStart"],
        DateEnd: json["DateEnd"],
        Name: json["Name"],
        Description: json["Description"],
        Image: json["Image"],
        Price: json["Price"],
      );
}
