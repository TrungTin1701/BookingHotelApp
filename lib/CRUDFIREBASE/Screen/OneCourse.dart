import 'package:flutter/material.dart';
import 'package:new_test/HomePage/homepage.dart';
class Cource extends StatefulWidget {
  const Cource({Key? key}) : super(key: key);

  @override
  State<Cource> createState() => _CourceState();
}

class _CourceState extends State<Cource> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(  context ).size.height/3.5,
      width: MediaQuery.of(  context ).size.width,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        
        ),
        boxShadow: [BoxShadow(
          color: Colors.black26,
          blurRadius: 5,
          spreadRadius: 5,
        offset: Offset(0, 5),
        
        )]
      ),
      
    );
  }
}