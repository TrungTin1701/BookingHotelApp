// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:new_test/HomePage/homepage.dart';
import 'package:new_test/CRUDFIREBASE/CourseModel.dart';

class OneCourse extends StatefulWidget {
  final Course? course;
  const OneCourse({required this.course, Key? key}) : super(key: key);

  @override
  State<OneCourse> createState() => _OneCourseState();
}

class _OneCourseState extends State<OneCourse> {
  late DragStartDetails _startdetails;
  late DragUpdateDetails _updatedetails;
  double _top = 1000;
  String DateFormat(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (dragDetails) {
        _startdetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        _updatedetails = dragDetails;
      },
      onVerticalDragEnd: (endDetails) {
        double dx =
            _updatedetails.globalPosition.dx - _startdetails.globalPosition.dx;
        double dy =
            _updatedetails.globalPosition.dy - _startdetails.globalPosition.dy;
        double? velocity = endDetails.primaryVelocity;
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        if (velocity! < 0) {
          setState(() {
            _top = 0;
          });
        } else if (velocity > 0) {
          setState(() {
            _top = 1000;
          });
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                spreadRadius: 5,
                offset: Offset(0, 5),
              )
            ]),
        child: Stack(children: [
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              image: DecorationImage(
                  image: NetworkImage(widget.course!.Image!, scale: 1),
                  fit: BoxFit.cover),
            ),
          ),

          AnimatedPositioned(
            top: _top,

            duration: Duration(milliseconds: 500),
            // top: -MediaQuery.of(context).size.height / 3.5,
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              height: MediaQuery.of(context).size.height / 3.5,
              padding: EdgeInsets.all(10),
              child: Stack(children: [
                Container(
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${widget.course!.Name}",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 10),
                      Text(" ${widget.course!.Description}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 212, 207, 207))),
                      SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: '\$',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 36, 35, 35))),
                            TextSpan(
                                text: "${widget.course!.Price}",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 36, 35, 35))),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Date Start: ${DateFormat(widget.course!.DateStart?.toDate() ?? DateTime.now())}",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 212, 207, 207))),
                        Text(
                            "Date End: ${DateFormat(widget.course!.DateEnd?.toDate() ?? DateTime.now())}",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 212, 207, 207))),
                      ],
                    ),
                  ),
                ),
              ]),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: kPrimaryColor),
            ),
          )
          // Expanded(
          //     flex: 2,
          //     child: Container(
          //       color: Colors.amber,
          //     ))
        ]),
      ),
    );
  }
}
