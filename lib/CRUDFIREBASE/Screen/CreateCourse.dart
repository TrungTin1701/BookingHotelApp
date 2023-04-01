// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_test/CRUDFIREBASE/CourseModel.dart';
import 'package:new_test/HomePage/homepage.dart';

class CreateCourse extends StatefulWidget {
  final DocumentSnapshot? documentSnapshot;
  const CreateCourse({this.documentSnapshot, Key? key}) : super(key: key);

  @override
  State<CreateCourse> createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  final CollectionReference _courses =
      FirebaseFirestore.instance.collection('Course');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  Timestamp? dateStart, dateEnd;
  StreamController dateStream = StreamController<DateTime?>.broadcast();
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
                controller: _imageController,
                decoration: InputDecoration(
                  labelText: 'Image',
                ),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text('Start Day'),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialEntryMode: DatePickerEntryMode.input,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: kPrimaryColor,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                    lastDate: DateTime(2050))
                                .then((date) {
                              dateStream.sink.add(date);
                              setState(() {
                                dateStart = Timestamp.fromDate(date!);

                                print("HUhuhuhuhu+>${dateStart!.toDate()}");
                              });
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                      stream: dateStream.stream,
                      builder: (context, snapshot) {
                        print("hahahahahah123 +> ${snapshot.data.runtimeType}");

                        print("DateTimeNow +> ${DateTime.now()}");
                        return Container(
                          child: Row(
                            children: [
                              Text('End Day'),
                              IconButton(
                                icon: Icon(Icons.calendar_today),
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialEntryMode:
                                              DatePickerEntryMode.input,
                                          initialDate: snapshot.hasData
                                              ? snapshot.data as DateTime
                                              : DateTime.now(),
                                          firstDate: snapshot.hasData
                                              ? snapshot.data as DateTime
                                              : DateTime.now(),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: kPrimaryColor,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                          lastDate: DateTime(2050))
                                      .then((date) {
                                    setState(() {
                                      dateEnd = Timestamp.fromDate(date!);
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                ],
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
                child: Text('Create'),
                onPressed: () async {
                  final String name = _nameController.text;
                  final String description = _descriptionController.text;
                  final int? price = int.tryParse(_priceController.text);
                  final String image = _imageController.text;
                  final Timestamp? start = dateStart;
                  final Timestamp? end = dateEnd;
                  await _courses.add({
                    'Name': name,
                    'Description': description,
                    'Price': price,
                    'Image': image,
                    'DateStart': start,
                    'DateEnd': end,
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
