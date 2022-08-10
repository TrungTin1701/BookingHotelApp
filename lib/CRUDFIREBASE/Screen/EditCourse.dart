// ignore_for_file: file_names, must_call_super, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_test/HomePage/homepage.dart';

class EditCourse extends StatefulWidget {
  final DocumentSnapshot? documentSnapshot;
  const EditCourse({this.documentSnapshot, Key? key}) : super(key: key);

  @override
  State<EditCourse> createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  Future<void> _update(DocumentSnapshot? documentSnapshot) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['Name'];
      _descriptionController.text = documentSnapshot['Description'];
      _priceController.text = documentSnapshot['Price'].toString();
    }
  }

  final CollectionReference _courses =
      FirebaseFirestore.instance.collection('Course');

  @override
  void initState() {
    _update(widget.documentSnapshot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Edit Course', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                ),
                child: Text('Update'),
                onPressed: () async {
                  final String name = _nameController.text;
                  final String description = _descriptionController.text;
                  final int? price = int.tryParse(_priceController.text);
                  await _courses.doc(widget.documentSnapshot!.id).update({
                    'Name': name,
                    'Description': description,
                    'Price': price,
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
