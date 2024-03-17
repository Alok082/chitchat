import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    // var _controller = locator<HomeController>();
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            title: _isTitleVisible
                ? Image.asset(
                    "asset/icons/Appbar_logo.png",
                    height: 40,
                  )
                : null,
            flexibleSpace: FlexibleSpaceBar(
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
                              Get.toNamed("/UserProfile");
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
              childCount: 50, // Adjust this according to your requirement
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FloatingActionButton(
          elevation: 10,
          isExtended: true,
          splashColor: Color.fromARGB(255, 168, 209, 241),
          onPressed: () {
            // Add your onPressed logic here
            print('FAB pressed');
          },
          child: Icon(
            Icons.person_add,
            size: 30,
            color: Colors.white,
          ), // Icon for the FAB
        ),
      ),
    );
  }
}
