// ignore_for_file: deprecated_member_use, unnecessary_brace_in_string_interps, prefer_const_constructors, duplicate_ignore, prefer_final_fields, non_constant_identifier_names, avoid_print

import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:new_test/Profile/Components/Info.dart';
import 'package:new_test/Profile/EditProfile_Controller.dart';
import 'package:new_test/Profile/Editprofile_Screen.dart';
import 'package:new_test/provider/Marker_provider.dart';
import 'package:new_test/provider/changeapi.dart';
import 'Http_Users/List_Users.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_test/provider/font_provider.dart';
import 'package:provider/provider.dart';
import 'HotelPage/hotelcart.dart' show HotelCard;
import 'HomePage/homepage.dart';
import 'Map_Hotel/Map_Screen.dart';
import 'Profile/profile.dart';
import 'HotelPage/hotelcart.dart';
import 'Search_Categories/Search_Screen.dart';
import 'Login Page/login_Page.dart';

DateTime today = DateTime.now();
String weekday =
    today.weekday < 7 ? 'Thứ ' + (today.weekday + 1).toString() : 'CN';
String min =
    today.minute < 10 ? '0' + today.minute.toString() : today.minute.toString();
late String dateSlug =
    "${weekday} /${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')},  ${today.hour}:${min}";
String _date1 = dateSlug.toString();

String weekday3 =
    today.weekday + 3 < 7 ? 'Thứ ' + (today.weekday + 4).toString() : 'CN';
late String dateSlug2 =
    "${weekday3} /${(today.year).toString()}-${today.month.toString().padLeft(2, '0')}-${(today.day).toString().padLeft(2, '0')},  ${today.hour}:${min}";

void main() {
  int Case = 1;
  Get.put(EditProfile());
  switch (Case) {
    case 1:
      return runApp(MyApp());

    case 2:
      return runApp(
          DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp()));
  }

  //
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final StreamController currentScreenObserver = StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChangeLocation()),
        ChangeNotifierProvider(
          create: (_) => FontProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChangeMarker(),
        ),
      ],
      child: Consumer<FontProvider>(
        builder: (context, value, child) => MaterialApp(
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          title: 'TRAVEL HOLA',
          debugShowCheckedModeBanner: false,
          home: MyHomePage(title: "Travel "),
          theme: ThemeData(fontFamily: value.fontFamily),
          initialRoute: '/map',
          routes: {
            '/profile': (context) => const ProfileApp(),
            '/Home': (context) => const StackOver(),
            '/Home1': (context) => const Home1(),
            '/Users': (context) => const Postpage(),
            '/Search': (context) => SearchScreen(),
            '/editprofile': (context) => EditProfileScreen(),
            '/loginpage': (context) => LoginPage(),
            '/map': (context) => MapScreen(),
          },
        ),
      ),
    );
  }
}

class StackOver extends StatefulWidget {
  const StackOver({Key? key}) : super(key: key);

  @override
  _StackOverState createState() => _StackOverState();
}

class _StackOverState extends State<StackOver>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _tabs = ["Tất cả", "Đang chờ phục vụ", "Đang phục vụ"];
  bool _isVisible = true;
  bool isScrollingDown = false;
  ScrollController _scrollController = ScrollController();
  void Show() {
    setState(() {
      _isVisible = true;
    });
  }

  Filter? filter;
  void show_sheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        context: context,
        builder: (context) => SearchScreen(
              filter: filter,
            )).then((value) {
      print("hhaahaahhahaahha => $value");
      filter = value;
    });
  }

  void Hide() {
    setState(() {
      _isVisible = false;
    });
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  void initState() {
    _tabController = TabController(length: _tabs.length, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          Hide();
          setState(() {});
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          Show();
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: Column(
            children: [
              Visibility(
                visible: _isVisible,
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        color: Colors.white,
                        child: Opacity(
                          opacity: 1,
                          child: const Center(
                              child: Text(
                            "Đặt phòng khác sạn",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                        color: Colors.white,
                        onPressed: () {
                          _openEndDrawer();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // give the tab bar a height [can change hheight to preferred height]
              Container(
                padding: const EdgeInsets.only(top: 0),
                height: 40,
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,

                  // give the indicator a decoration (color and border radius)
                  indicatorColor: Colors.blue,
                  indicatorWeight: 1,
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: const Color.fromARGB(255, 13, 10, 10),
                  labelColor: Colors.blue,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                  labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                  tabs: [
                    for (var i = 0; i < _tabs.length; i++)
                      Tab(
                        child: Text(
                          _tabs[i],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              // tab bar view here
              Expanded(
                flex: 3,
                child: TabBarView(controller: _tabController, children: [
                  for (var i = 0; i < _tabs.length; i++)
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: ListView(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          children: [
                            HotelCard(
                                '/image/hotel2.jpg',
                                'Tôi và em',
                                '400 Ung Van khiem',
                                context,
                                _date1,
                                dateSlug2),
                            HotelCard(
                                '/image/hotel3.jpg',
                                'Tôi và em',
                                '400 Ung Van khiem',
                                context,
                                _date1,
                                dateSlug2),
                            HotelCard(
                                '/image/hotel4.jpg',
                                'Tôi và em',
                                '400 Ung Van khiem',
                                context,
                                _date1,
                                dateSlug2),
                            HotelCard(
                                '/image/hotel4.jpg',
                                'Tôi và em',
                                '400 Ung Van khiem',
                                context,
                                _date1,
                                dateSlug2),
                          ],
                        ),
                      ),
                    ),
                ]),
              ),
            ],
          ),
          endDrawer: Drawer(
            child: Center(
                child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Trang chủ',
                      style: TextStyle(color: Colors.blue)),
                  onTap: () {
                    Navigator.pushNamed(context, "");
                  },
                ),
                ListTile(
                    leading: const Icon(Icons.person),
                    title:
                        Text('Profile', style: TextStyle(color: Colors.blue)),
                    onTap: () => show_sheet()),
              ],
            )),
          ),
          endDrawerEnableOpenDragGesture: false,
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 30,
            title: Center(
                child: Text(
              "Booking Room",
              style: TextStyle(color: Colors.black, fontSize: 17),
            )),
            //centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.menu),
                color: Colors.black,
                iconSize: 17,
                onPressed: () {},
              )
            ],
            //backgroundColor: Colors.purple,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [
                    Color.fromARGB(255, 236, 232, 237),
                    Color.fromARGB(255, 227, 225, 225)
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            bottom: TabBar(
              //isScrollable: true,
              indicatorColor: Colors.blue,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2,
              unselectedLabelColor: Color.fromARGB(255, 13, 10, 10),
              labelColor: Colors.blue,
              labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),

              tabs: const [
                Tab(text: 'Tất Cả'),
                Tab(text: 'Đang Phục Vụ'),
                Tab(text: 'Đang Chờ Phục Vụ'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: TabBarView(children: [
                Container(
                  color: Color.fromARGB(255, 212, 209, 209),
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      HotelCard('/image/hotel2.jpg', 'Tôi và em',
                          '400 Ung Van khiem', context, _date1, dateSlug2),
                      HotelCard('/image/hotel3.jpg', 'Tôi và em',
                          '400 Ung Van khiem', context, _date1, dateSlug2),
                      HotelCard('/image/hotel4.jpg', 'Tôi và em',
                          '400 Ung Van khiem', context, _date1, dateSlug2),
                      HotelCard('/image/hotel4.jpg', 'Tôi và em',
                          '400 Ung Van khiem', context, _date1, dateSlug2),
                    ],
                  ),
                ),
                Container(
                  color: Color.fromARGB(255, 212, 209, 209),
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      HotelCard('/image/hotel2.jpg', 'Tôi và em',
                          '400 Ung Van khiem', context, _date1, dateSlug2),
                      HotelCard('/image/hotel3.jpg', 'Tôi và em',
                          '400 Ung Van khiem', context, _date1, dateSlug2),
                      HotelCard('/image/hotel4.jpg', 'Tôi và em',
                          '400 Ung Van khiem', context, _date1, dateSlug2),
                      HotelCard('/image/hotel4.jpg', 'Tôi và em',
                          '400 Ung Van khiem', context, _date1, dateSlug2),
                    ],
                  ),
                ),
                Container(
                  // ignore: prefer_const_constructors
                  color: Color.fromARGB(255, 212, 209, 209),
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      HotelCard('/image/hotel2.jpg', 'Tôi và em',
                          '400 Ung Van khiem', context, _date1, dateSlug2),
                      HotelCard('/image/hotel3.jpg', 'Tôi và em',
                          '400 Ung Van khiem', context, _date1, dateSlug2),
                      HotelCard('/image/hotel4.jpg', 'Tôi và em',
                          '400 Ung Van khiem', context, _date1, dateSlug2),
                      HotelCard('/image/hotel4.jpg', 'Tôi và em',
                          '400 Ung Van khiem', context, _date1, dateSlug2),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final StreamController currentScreenObserver = StreamController.broadcast();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int select = 0;
  // void initState() {
  //   _tabController = TabController(length: _widgetOptions.length, vsync: this);
  //   super.initState();
  // }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Home1(),
    StackOver(),
    ProfileApp(),
  ];
  @override
  Widget build(BuildContext context) {
    // var scaffold = MaterialApp(
    //     home: Scaffold(
    //   body: Center(child: _widgetOptions.elementAt(select)),
    //   bottomNavigationBar: BottomNavigationBar(
    //     items: const <BottomNavigationBarItem>[
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.home),
    //         label: 'Home',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.hotel),
    //         label: 'Hotel',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(
    //           Icons.person,
    //         ),
    //         label: 'Profile',
    //       ),
    //     ],
    //     currentIndex: select,
    //     selectedItemColor: Colors.amber[800],
    //     onTap: (int index) {
    //       setState(() {
    //         select = index;
    //       });
    //     },
    //   ),
    // ));
    var scaffold = Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          title: const Text("HOME PAGE"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _openEndDrawer();
              },
            ),
          ],
          backgroundColor: kPrimaryColor,
        ),
        body: Center(child: _widgetOptions.elementAt(select)),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0.0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.hotel),
              label: 'Hotel',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: select,
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            switch (index) {
              case 0:
                setState(() {
                  select = index;
                });
                break;
              case 1:
                Navigator.pushNamed(context, '/Home');
                break;
              case 2:
                // setState(() {
                //   select = index;
                // });
                Navigator.pushNamed(context, '/profile');
            }
          },
        ),
        endDrawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 59, 160, 175),
          child: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              Info(),
              const SizedBox(
                height: 60,
                child: DrawerHeader(
                  child: Text(
                    "Custom Settings",
                    style: TextStyle(fontSize: 16),
                  ),
                  margin: EdgeInsets.only(top: 10),
                ),
              ),
              ListTile(
                title: Text("Font 1"),
                onTap: () => context.read<FontProvider>().changeFont("Hehe"),
              ),
              ListTile(
                title: Text("Font 2"),
                onTap: () =>
                    context.read<FontProvider>().changeFont("DancingScript"),
              ),
              ListTile(
                title: Text("Font 3"),
                onTap: () => context.read<FontProvider>().changeFont("Roboto1"),
              ),
            ],
          ),
        ));
    return scaffold;
  }
}
