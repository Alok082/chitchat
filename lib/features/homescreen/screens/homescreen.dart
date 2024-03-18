import 'dart:convert';
import 'dart:math';

import 'package:chitchat/core/constants/constant.dart';
import 'package:chitchat/core/models/user_data_model.dart';
import 'package:chitchat/firebaseservises/firebaseservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/chat_screen_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();
  bool _isTitleVisible = false;
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _isTitleVisible = _scrollController.offset >= 170;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<UserData> userdatalist = [];
    // var _controller = locator<HomeController>();
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            scrolledUnderElevation: BorderSide.strokeAlignCenter,
            centerTitle: true,
            title: _isTitleVisible
                ? Image.asset(
                    "asset/icons/Appbar_logo.png",
                    height: 40,
                  )
                : null,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              centerTitle: true,
              background: Image.asset(
                "asset/icons/sliverapp_logo.png",
                fit: BoxFit.fitWidth,
              ),
            ),
            collapsedHeight: 60,
            bottom: !_isTitleVisible
                ? PreferredSize(
                    preferredSize: Size(0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.home_outlined,
                              color: Colors.white,
                              size: 30,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 30,
                            )),
                        IconButton(
                            onPressed: () {
                              Get.toNamed("/UserProfile",
                                  arguments: userdatalist[0]);
                            },
                            icon: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            )),
                      ],
                    ))
                : null,
            expandedHeight: 170,
          ),
          // SliverToBoxAdapter(

          //   child: StreamBuilder(
          //       stream: Constents.firestore.collection('Users').snapshots(),
          //       builder: (context, snapshot) {
          // if (snapshot.hasData) {
          //   final data = snapshot.data?.docs;
          //   final itemCount = data?.length ?? 0;
          //   for (var i in data!) {
          //     print("data ${i.data()}");
          //   }
          // }
          //         return ListView.builder(
          //           physics: AlwaysScrollableScrollPhysics(),
          //           shrinkWrap: true,
          //           itemCount: 10, // Set your itemCount dynamically
          //           itemBuilder: (BuildContext context, int index) {
          //             return ChatUserCard(
          //               name: "list[index]",
          //               indexes: index,
          //             );
          //           },
          //         );
          //       }),
          // ),
          SliverToBoxAdapter(
            child: StreamBuilder(
                stream:
                    FirebaseServises.firestore.collection('Users').snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      userdatalist = data
                              ?.map((e) => UserData.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (userdatalist.isNotEmpty) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: userdatalist.length,
                          itemBuilder: (context, index) {
                            return ChatUserCard(
                              userdata: userdatalist[index],
                            );
                          },
                        );
                      } else {
                        return Padding(
                            padding: EdgeInsets.symmetric(vertical: 200),
                            child:
                                Image.asset("asset/icons/No_connection.png"));
                      }
                  }
                }),
          )

          // SliverToBoxAdapter(
          //   child: SizedBox(
          //     height: MediaQuery.of(context).size.height -
          //         kToolbarHeight -
          //         MediaQuery.of(context).padding.top * 5,
          //   ),
          // ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FloatingActionButton(
          foregroundColor: Colors.black,
          backgroundColor: Color.fromARGB(255, 168, 209, 241),
          elevation: 10,
          // mini: true,

          // shape: Border.all(
          //     color: Colors.black,
          //     style: BorderStyle.solid,
          //     width: 10),
          isExtended: true,
          splashColor: Color.fromARGB(255, 0, 0, 0),
          onPressed: () {
            // Add your onPressed logic here
            print('FAB pressed');
          },
          child: Icon(
            Icons.person_add,
            size: 30,
            color: Color.fromARGB(255, 0, 0, 0),
          ), // Icon for the FAB
        ),
      ),
    );
  }
}
