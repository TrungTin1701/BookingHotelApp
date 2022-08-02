// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_final_fields, avoid_print, unused_field

import 'dart:async';
import 'dart:developer';
import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:new_test/Map_Hotel/Components/CustomMaker/MyPaint.dart';
import 'package:new_test/Map_Hotel/Components/HotelCard/HotelCard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:new_test/provider/changeapi.dart';
import 'package:provider/provider.dart';

List<Marker> _list = const [
  Marker(
    zIndex: 0,
    markerId: MarkerId('1'),
    position: LatLng(37.42830266604936, -122.09190431982279),
  ),
  Marker(
    zIndex: 0,
    markerId: MarkerId('2'),
    position: LatLng(37.429816002294984, -122.09238041192293),
  ),
  Marker(
      markerId: MarkerId('3'),
      position: LatLng(37.43397778545293, -122.08606280386448)),
  Marker(
      zIndex: 0,
      markerId: MarkerId('4'),
      position: LatLng(37.42796133580664, -122.085749655962),
      infoWindow: InfoWindow(title: 'a')),
  Marker(
      zIndex: 0,
      markerId: MarkerId('5'),
      position: LatLng(37.43231091684314, -122.0917095243931),
      infoWindow: InfoWindow(title: "hehe")),
  Marker(
      zIndex: 0,
      markerId: MarkerId('6'),
      position: LatLng(37.42796133580664, -122.089),
      infoWindow: InfoWindow(title: 'b')),
];

class MapBody extends StatefulWidget {
  const MapBody({Key? key}) : super(key: key);

  @override
  State<MapBody> createState() => _MapBodyState();
}

class _MapBodyState extends State<MapBody> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState

    _loadListMarkers(
      _list,
      () {
        trueMarkers = _markers;
        _notifier.value = _markers;
        _sinkMarkers.add(_markers);

        WidgetsBinding.instance?.addPostFrameCallback((_) {
          //_loadListMarkers(_list);

          CameraPosition cameraPosition = CameraPosition(
            target: _markers.first.position,
            zoom: 16,
          );

          context.read<ChangeLocation>().changeLocation(cameraPosition);
        });
      },
    );

    super.initState();
  }

  // My Location
  late Position myPosition;
  var geolocator = Geolocator();
  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.error("Location service is not enabled");
      // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission is not granted");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission is not granted");
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  // Load Custom Marker
  Future<Uint8List?> _myPainterToMap(String Label, Color color) async {
    ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final canvas = ui.Canvas(pictureRecorder);
    MyPainter myPainter = MyPainter(Label, color);
    myPainter.paint(canvas, Size(300, 100));
    final ui.Image picture =
        await pictureRecorder.endRecording().toImage(300, 100);
    final ByteData? byteData =
        await picture.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  int count = 0;
  late GoogleMapController _controller;
  //
  CarouselController _carouselController = CarouselController();
  // Load List Data
  Set<Marker> trueMarkers = {};
  Set<Marker> _markers = {};
  Set<Marker> temp = {};
  ValueNotifier<Set<Marker>> _notifier = ValueNotifier(<Marker>{});
  // New Stream
  final _streamState = StreamController<int>();
  StreamSink<int> get _sinkState => _streamState.sink;
  Stream<int> get streamState => _streamState.stream;
// Use Stream to catch Data
  final _streamMarkers = StreamController<Set<Marker>>.broadcast();
  StreamSink<Set<Marker>> get _sinkMarkers => _streamMarkers.sink;
  Stream<Set<Marker>> get streamMarkers => _streamMarkers.stream;
  bool onpagechange = true;
  void _loadListMarkers(List<Marker> listtemp, Function() onFinsh) async {
    var newlist = listtemp;
    // _markers.clear();

    var bytes = await _myPainterToMap("4.500.000", Colors.white);
    var bytes1 = await _myPainterToMap("4.500.000", Colors.blue);
    bool isClick = newlist.first == listtemp.first;

    for (var i in listtemp) {
      Marker marker = Marker(
          zIndex: i == listtemp.first ? 1 : 0,
          markerId: i.markerId,
          position: i.position,

          //infoWindow: InfoWindow(title: "${count++}"),
          icon:
              BitmapDescriptor.fromBytes(i == newlist.first ? bytes1! : bytes!),
          onTap: () {
            count = 1;
            onpagechange = false;
            _sinkState.add(1);
            _carouselController.animateToPage(_list.indexOf(i),
                duration: Duration(milliseconds: 600), curve: Curves.ease);
            isClick = !isClick;
            if (!isClick) {
              final index = listtemp
                  .indexWhere((element) => element.markerId == i.markerId);

              print("hhahahaha3312312 => $index");

              try {
                listtemp = List.of(listtemp)
                  ..insert(0, newlist[index].copyWith())
                  ..removeAt(index + 1);
              } catch (e) {
                print('hahahahahahaha => $e');
              }

              // setState(() {
              //   print("hehe");
              _loadListMarkers(listtemp, onFinsh);

              // });
            }
          });

      _markers.add(marker);
    }

    onFinsh.call();
  }

  @override
  Widget build(BuildContext context) {
    log("Rebuild MapBody");

    return StreamBuilder<Set<Marker>>(
        stream: streamMarkers,
        builder: (context, snapshot) {
          return Stack(children: [
            Consumer<ChangeLocation>(builder: ((context, value, child) {
              return Positioned.fill(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: ui.Color.fromARGB(255, 29, 167, 176),
                  child: ValueListenableBuilder<Set<Marker>>(
                    valueListenable: _notifier,
                    builder: (context, value1, child) {
                      return GoogleMap(
                          mapType: MapType.normal,
                          onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                            getLocation();
                          },
                          markers: snapshot.data!,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: true,
                          zoomGesturesEnabled: true,
                          initialCameraPosition: value.kGooglePlex1);
                    },
                  ),
                ),
              );
            })),
            Positioned(
              // child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height * 0.45,
              //     child: HotelCard()),
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                //  margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset: Offset(3.0, 3.0), // changes position of shadow
                      )
                    ]),
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                    aspectRatio: 2.0,
                    initialPage: 0,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    onPageChanged: (index, reason) {
                      Marker temp = _list.elementAt(index);

                      if (onpagechange) {
                        _controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: temp.position,
                              zoom: 16,
                            ),
                          ),
                        );
                        List<Marker> newList = _list.toList();
                        newList.insert(0, temp.copyWith());
                        newList.removeAt(index + 1);
                        print(newList.length);
                        print("HGeee");

                        _loadListMarkers(newList,
                            () => {_sinkMarkers.add(_markers), print("Huuhu")});

                        print("index => $index");
                      }
                      Future.delayed(Duration(milliseconds: 500), () {
                        onpagechange = true;
                      });
                    },
                  ),
                  items: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: HotelCard()),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: HotelCard()),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: HotelCard()),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: HotelCard()),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: HotelCard()),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: HotelCard()),
                  ],
                  carouselController: _carouselController,
                ),
              ),
              bottom: MediaQuery.of(context).size.height / 10,
              left: 0,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: FloatingActionButton(
                onPressed: () async {
                  Position? postition;
                  try {
                    postition = await getLocation();
                  } catch (e) {
                    ///show ppermission
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text("Access Dinied"),
                              content: Text(
                                  "Do you want this app to access your location"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => AppSettings.openAppSettings()
                                      .then((value) =>
                                          Navigator.pop(context, 'Ok')),
                                  child: const Text('OK'),
                                ),
                              ],
                            ));
                    return;
                  }

                  ImageConfiguration configuration =
                      createLocalImageConfiguration(context);
                  var icon1 = await BitmapDescriptor.fromAssetImage(
                      configuration, 'assets/mylocation.jpg');
                  Marker marker = Marker(
                    markerId: MarkerId("${postition.latitude}"),
                    position: LatLng(postition.latitude, postition.longitude),
                    icon: icon1,
                    infoWindow: InfoWindow(
                      title: "Your Location",
                    ),
                  );
                  _markers.add(marker);
                  _sinkMarkers.add(_markers);
                  _controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(postition.latitude, postition.longitude),
                        zoom: 17,
                      ),
                    ),
                  );
                },
                child: Icon(Icons.my_location),
              ),
            ),
          ]);
        });
  }
}
