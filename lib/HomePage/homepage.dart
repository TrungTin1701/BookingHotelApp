// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:new_test/HotelPage/Details/details.dart';
import 'package:new_test/Search_Categories/Search_Screen.dart';
import 'package:new_test/FlutterToNative/Battery.dart';

// ignore: implementation_imports
const kPrimaryColor = Color(0xFF0C9869);
const kTextColor = Color(0xFF3C4046);
const kBackgroundColor = Color(0xFFF9F8FD);

class Home1 extends StatefulWidget {
  const Home1({Key? key}) : super(key: key);

  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  final mycontroller = TextEditingController();

  Filter? filter;

  @override
  void dispose() {
    mycontroller.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.3 - 50,
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20 + 50),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Row(
                        children: [
                          Text(
                            "Travel Hola",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const Spacer(),
                        ],
                      ),
                    )),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  child: GestureDetector(
                    onTap: () => showModalBottomSheet(
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30))),
                        context: context,
                        builder: (context) => SearchScreen(
                              filter: filter,
                            )).then((value) {
                      print("hhaahaahhahaahha => $value");
                      filter = value;
                    }),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(41, 0, 0, 0),
                              offset: Offset(0, 10),
                              blurRadius: 20),
                        ],
                      ),
                      height: 49,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: mycontroller,
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                hintText: "Search for Hotel, City, Area",
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                hintStyle: TextStyle(
                                  color: kPrimaryColor.withOpacity(0.5),
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  width: 49.7,
                  height: 49.7,
                  right: 17.1,
                  bottom: 20.2,
                  child: FloatingActionButton(
                      backgroundColor: kPrimaryColor,
                      onPressed: () => {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(mycontroller.text),
                                    contentPadding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 10, bottom: 10),
                                  );
                                }),
                          },
                      child: const Icon(
                        Icons.search,
                      )),
                ),
              ],
            ),
          ),
          const image_1(), //Search
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class image_1 extends StatefulWidget {
  const image_1({Key? key}) : super(key: key);

  @override
  State<image_1> createState() => _image_1State();
}

// ignore: camel_case_types
class _image_1State extends State<image_1> {
  late List<Widget> imageroll = [
    travelCard(
      '/image/hotel2.jpg',
      'Park Hyatt',
      'Le Thanh Ton , District 1 , HCM',
      3,
    ),
    travelCard(
      '/image/hotel3.jpg',
      'Park Hyatt',
      'Le Thanh Ton , District 1 , HCM',
      4,
    ),
    travelCard(
      '/image/hotel4.jpg',
      'Park Hyatt',
      'Le Thanh Ton , District 1 , HCM',
      4,
    ),
    travelCard(
      '/image/hotel4.jpg',
      'Park Hyatt',
      'Le Thanh Ton , District 1 , HCM',
      4,
    ),
    travelCard(
      '/image/hotel2.jpg',
      'Park Hyatt',
      'Le Thanh Ton , District 1 , HCM',
      4,
    ),
  ];
  late PageController _pageController;
  int activePage = 0;

  late Timer timer;
  late Duration autoplayDuration = const Duration(seconds: 3);
  late Duration animationDuration = const Duration(seconds: 2);
  late Duration backDuration = const Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.99, initialPage: 0);

    WidgetsBinding.instance?.addPostFrameCallback(
        (_) => timer = Timer.periodic(autoplayDuration, (timer) {
              var length = (imageroll.length) - 1;
              if (_pageController.hasClients) {
                if ((_pageController.page?.round()) == length) {
                  _pageController.animateToPage(0,
                      duration: backDuration, curve: Curves.easeInOut);
                } else {
                  _pageController.nextPage(
                      duration: animationDuration, curve: Curves.easeInOut);
                }
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: imageroll.length,
        itemBuilder: (BuildContext context, int index) {
          return imageroll[index];
        },
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            activePage = index;
          });
        },
      ),
    );
  }

  Widget travelCard(
      String imgUrl, String hotelName, String location, int rating) {
    return Builder(builder: (context) {
      return Card(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 0.0,
        child: InkWell(
          onTap: () {},
          child: Container(
            height: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(imgUrl),
              fit: BoxFit.cover,
            )),
            width: MediaQuery.of(context).size.width - 22,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      for (var i = 0; i < rating; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Icon(
                            Icons.star,
                            color: Color.fromARGB(255, 235, 221, 102),
                          ),
                        ),
                    ],
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, right: 0),
                        child: Text(
                          hotelName,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 196, 235, 238)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          location,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 166, 201, 207)),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

//Button
Widget buildButton(
  String imgurl,
  // ignore: non_constant_identifier_names
  String Hotelname,
  String location,
  BuildContext context,
  // ignore: non_constant_identifier_names
  String Date1,
  String date2,
) {
  return Row(
    //Button
    children: <Widget>[
      Expanded(
        // ignore: duplicate_ignore
        child: OutlinedButton(
          onPressed: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => (chitiet(
                        imgurl, Hotelname, location, context, Date1, date2)))),
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            primary: Colors.blueAccent,
            side: const BorderSide(
              color: Colors.blueAccent,
              width: 1,
            ),
          ),
          child: Text(
            ("Xem Chi Tiết"),
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 100, 179, 239)),
          ),
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: OutlinedButton(
          onPressed: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BatteryLevel(),
                ))
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            primary: Colors.redAccent,
            side: BorderSide(
              color: Colors.redAccent,
              width: 1,
            ),
          ),
          child: Text(
            "Thông Tin Hoàn Tiền",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 231, 60, 41)),
          ),
        ),
      )
    ],
  );
}
