// ignore: file_names
// ignore_for_file: import_of_legacy_library_into_null_safe, file_names, prefer_const_constructors, duplicate_ignore, prefer_final_fields, non_constant_identifier_names, avoid_print, deprecated_member_use, sized_box_for_whitespace

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:flutter/material.dart';
import 'package:new_test/HomePage/homepage.dart';
import 'package:new_test/provider/Favour.dart';
import 'package:provider/provider.dart';
import 'Users.dart';
import 'http_service.dart';
import 'package:new_test/Http_Users/ProfileUsers/profileusers.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:new_test/Http_Users/Users.dart';

class Postpage extends StatefulWidget {
  const Postpage({Key? key}) : super(key: key);

  @override
  State<Postpage> createState() => _PostpageState();
}

class _PostpageState extends State<Postpage> {
  late bool enableLoadingWhenNoData;
  HttpService httpService = HttpService();
  int page = 1;
  RefreshController _refreshController = RefreshController();
  List<Person> Posts = [];
  bool isFavorite = false;
  GlobalKey _contenKey = GlobalKey();
  GlobalKey _refreshIndicatorKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    httpService.getPosts().then((value) => {
          setState(() {
            Posts = value;
          })
        });
  }

  void _onFresh() async {
    print("On Fresh");
    await Future.delayed(Duration(seconds: 2));
    var list = await httpService.getPosts(page: 1);
    Posts.clear();
    page = 1;
    Posts.addAll(list);
    setState(() {
      _refreshController.refreshCompleted();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void Remove(String id) {
    Posts.removeWhere((element) => element.email == id);

    setState(() {
      Posts;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: kPrimaryColor,
      content: Text("Removed",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 247, 242, 242))),
      duration: Duration(seconds: 1),
    ));
  }

  void SortListUser() {
    Posts.sort((a, b) => a.firstName.compareTo(b.firstName));
    setState(() {
      Posts;
    });
  }

  void _onLoading() async {
    print("On Loading");
    page++;
    var list = await httpService.getPosts(page: page);
    //page++;
    await Future.delayed(Duration(seconds: 1));
    //
    if (list.isEmpty) {
      print('No more data');

      setState(() {
        enableLoadingWhenNoData = false;
        _refreshController.loadComplete();
      });
    } else {
      Posts.addAll(list);

      //
      setState(() {
        _refreshController.loadComplete();
      });
    }
    // if (Posts['total_pages'] == page.toString()) {
    //   _refreshController.loadNoData();
    // } else {
    //   _refreshController.loadComplete();
    // }
  }

  Widget buildCTN() {
    return ListView.separated(
      key: _contenKey,
      itemBuilder: (context, index) {
        return Slidable(
          key: ValueKey(index),
          startActionPane: ActionPane(motion: ScrollMotion(), children: [
            SlidableAction(
                icon: Icons.delete,
                backgroundColor: kPrimaryColor,
                label: "Delete",
                onPressed: (context) {
                  Remove(Posts[index].email);
                }),
            SlidableAction(
                onPressed: (context) {
                  setState(() {
                    Posts[index].isFavour = !Posts[index].isFavour;
                    context.read<Favour>().changeFavour(
                        Posts[index].email, Posts[index].isFavour);
                  });
                },
                icon: Icons.favorite_border_outlined,
                backgroundColor: Colors.redAccent,
                label: "Like"),
          ]),
          child: GestureDetector(
              onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetail(
                          post: Posts[index],
                        ),
                      ),
                    ),
                  },
              child: OneUSer(
                person: Posts[index],
                isFavorite: isFavorite,
              )),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.black,
        );
      },
      itemCount: Posts.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "List Users",
              style: TextStyle(fontSize: 18),
            ),
            backgroundColor: kPrimaryColor,
            actions: [
              IconButton(
                onPressed: SortListUser,
                icon: Icon(
                  Icons.sort,
                  color: Colors.white,
                ),
              )
            ]),
        body: SmartRefresher(
          controller: _refreshController,
          key: _refreshIndicatorKey,
          enablePullDown: true,
          enablePullUp: true,
          child: buildCTN(),
          physics: BouncingScrollPhysics(),
          footer: ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
          ),
          onLoading: _onLoading,
          onRefresh: _onFresh,
          header: WaterDropMaterialHeader(
            color: Colors.white,
            backgroundColor: kPrimaryColor,
          ),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            backgroundColor: kPrimaryColor,
            child: Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {
              _onLoading();
              //_refreshController.requestLoading();
            },
            heroTag: null,
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            backgroundColor: kPrimaryColor,
            child: Icon(Icons.refresh_outlined),
            onPressed: () {
              _onFresh();
            },
            heroTag: null,
          )
        ]));
  }
}

class OneUSer extends StatefulWidget {
  final Person person;
  final bool isFavorite;
  // ignore: use_key_in_widget_constructors
  const OneUSer({
    required this.person,
    required this.isFavorite,
  });

  @override
  State<OneUSer> createState() => _OneUSerState();
}

class _OneUSerState extends State<OneUSer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CachedNetworkImage(
              imageBuilder: (context, imageProvider) => Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.0, color: Colors.transparent),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imageProvider,
                    ),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(2, 2),
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.1))
                    ]),
              ),
              fit: BoxFit.cover,
              imageUrl: widget.person.avatar,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(
                Icons.error,
                size: 100,
                color: Colors.red,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                  child: Text(
                    widget.person.firstName + " " + widget.person.lastName,
                    style: const TextStyle(
                        fontFamily: 'Roboto1',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Email: ",
                            style: const TextStyle(
                                fontFamily: 'Roboto1',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: widget.person.email,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 10.5,
                ),
              ],
            ),
          ),
          Consumer<Favour>(
            builder: (context, value, child) {
              value.isFavour == widget.person.email
                  ? widget.person.isFavour = value.isChoose
                  : log("message");
              return Container(
                height: 100,
                width: 100,
                child: widget.person.isFavour
                    ? Icon(
                        Icons.favorite_rounded,
                        color: Colors.red,
                      )
                    : Icon(Icons.favorite_border, color: Colors.red),
              );
            },
          )
        ],
      ),
    );
  }
}
