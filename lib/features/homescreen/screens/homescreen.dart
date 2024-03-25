import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/core/models/user_data_model.dart';
import 'package:chitchat/features/homescreen/services/home_controller.dart';
import 'package:chitchat/firebaseservises/firebaseservice.dart';
import 'package:chitchat/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../dependency_injection.dart';
import '../widgets/contacts_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ScrollController _scrollController = ScrollController();

  bool _isTitleVisible = false;

  @override
  // void initState() {
  //   super.initState();

  //   _scrollController.addListener(() {
  //     setState(() {
  //       _isTitleVisible = _scrollController.offset >= 170;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.sizeOf(context);
    var controller = locator<HomeController>();
    return GestureDetector(
      onTap: () {
        if (controller.isSearching) {
          FocusManager.instance.primaryFocus!.unfocus();
          controller.changeSearch();
        }
        if (controller.viewprofile) {
          controller.setvisibilityprofile();
        }
      },
      child: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (_) {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 168, 209, 241),
              body: Stack(
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
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
                                preferredSize: const Size(0, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.home_outlined,
                                          color: Colors.white,
                                          size: 30,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          Get.toNamed("/UserProfile",
                                              arguments: FirebaseServises.me);
                                        },
                                        icon: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 30,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          print(controller.isSearching);
                                          controller.changeSearch();
                                        },
                                        icon: controller.isSearching
                                            ? const Icon(
                                                CupertinoIcons
                                                    .clear_circled_solid,
                                                color: Colors.white,
                                              )
                                            : const Icon(
                                                Icons.search,
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
                            stream: FirebaseServises.getalluser(),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                case ConnectionState.none:
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  final data = snapshot.data?.docs;
                                  controller.userdatalist = data
                                          ?.map((e) =>
                                              UserData.fromJson(e.data()))
                                          .toList() ??
                                      [];

                                  if (controller.userdatalist.isNotEmpty) {
                                    return ListView.builder(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: controller.isSearching
                                          ? controller.searchlist.length
                                          : controller.userdatalist.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Get.toNamed(AppRoutes.chatScreen,
                                                arguments: controller
                                                    .userdatalist[index]);
                                          },
                                          child: ChatUserCard(
                                            userdata: controller.isSearching
                                                ? controller.searchlist[index]
                                                : controller
                                                    .userdatalist[index],
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 200),
                                        child: Image.asset(
                                            "asset/icons/No_connection.png"));
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
                  Visibility(
                    visible: controller.isSearching && _isTitleVisible == false,
                    child: Positioned(
                        top: mq.height * 0.17,
                        // left: mq.width * 0.2,
                        child: Container(
                            margin: const EdgeInsets.all(5),
                            // color: Colors.blue,
                            // height: 50,
                            width: mq.width * 0.7,
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Name,Email...",
                                contentPadding: const EdgeInsets.all(10),
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(25)),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 168, 209, 241),
                              ),
                              onChanged: (value) {
                                controller.searching(value);
                              },
                            ))),
                  ),
                  Visibility(
                    visible: controller.viewprofile,
                    child: AnimatedContainer(
                        margin: const EdgeInsets.symmetric(vertical: 150),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25)),
                        height: controller.viewprofile ? mq.height * 0.6 : 0,
                        width: controller.viewprofile ? mq.height * 0.8 : 0,
                        alignment: Alignment.center,
                        curve: Curves.linear,
                        duration: const Duration(milliseconds: 1000),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: CachedNetworkImage(
                                // height: ,
                                fit: BoxFit.cover,
                                imageUrl: controller.currentuserimage,
                                placeholder: (context, url) =>
                                    const CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'asset/icons/applogo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Positioned(
                            //     right: 20,
                            //     top: 25,
                            //     child: Container(
                            //       decoration: BoxDecoration(
                            //           color: const Color.fromARGB(
                            //               255, 255, 255, 255),
                            //           borderRadius: BorderRadius.circular(100)),
                            //       child: IconButton(
                            //         icon: Icon(
                            //           Icons.info_outline,
                            //           size: 30,
                            //         ),
                            //         onPressed: () {
                            //           Get.toNamed(AppRoutes.viewOthersProfile);
                            //           controller.setvisibilityprofile();
                            //         },
                            //       ),
                            //     ))
                          ],
                        )),
                  ),
                ],
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FloatingActionButton(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color.fromARGB(255, 168, 209, 241),
                  elevation: 10,
                  // mini: true,

                  // shape: Border.all(
                  //     color: Colors.black,
                  //     style: BorderStyle.solid,
                  //     width: 10),
                  isExtended: true,
                  splashColor: const Color.fromARGB(255, 0, 0, 0),
                  onPressed: () {
                    // Add your onPressed logic here
                    print('FAB pressed');
                  },
                  child: const Icon(
                    Icons.person_add,
                    size: 30,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ), // Icon for the FAB
                ),
              ),
            );
          }),
    );
  }
}
