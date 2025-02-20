import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transithub/Fun&Item/item_ChatScreen.dart';
import 'package:transithub/Post/Post%20Create.dart';
import 'package:transithub/Post/Post%20Show.dart';
import 'package:transithub/Screens/Splash%20Screen.dart';

import '../Account manegement/Account_manage_API.dart';
import '../Fun&Item/SettingsDialog.dart';
import '../Fun&Item/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userId;
  String? _userImageUrl;

  @override
  void initState() {
    super.initState();
    _initializeUserData();

    setState(() {});
  }

  Future<void> _initializeUserData() async {
    _userId = await Access().getUserId();
    UserImageManager.getUserImageById(userId: _userId!);
    _userImageUrl = await Access().getUserImageProfileUrl();
    setState(() {
      _userId;
      _userImageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: _showSettingsDialog,
            icon: Container(
              height: screenHeight * 0.168,
              width: screenWidth,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: NetworkImage(_userImageUrl ??
                      _userImageUrl ??
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                ),
              ),
            ),
          ),
          title: CupertinoButton(
            padding: const EdgeInsets.all(5),
            borderRadius: BorderRadius.circular(5000),
            color: const Color.fromRGBO(220, 245, 250, 0.6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  // _userId!,
                  'Search for a trip or delivery',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const Icon(
                  CupertinoIcons.search,
                  color: Colors.blueAccent,
                )
              ],
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PostSearchScreen()));
            },
          ),
        ),
        body: TabBarView(children: [
          //Tab 1
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverList(
                    delegate: SliverChildListDelegate([
                  Text(
                    'Nearest Delivery',
                    style: TextStyle(fontSize: screenWidth * 0.06),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: LocalPostWidgetShow(),
                  ),
                ]))
              ],
              body: PostWidgetShow(),
            ),
          ),
          // Tab 2
          ListView(
            padding: EdgeInsets.only(
              left: screenWidth * 0.012,
              right: screenWidth * 0.012,
            ),
            children: [
              ItemChatScreen(
                chatTitle: 'محمود ناصر محمود',
                subTitle: 'كيف الحال',
                timeLastMassage: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                notification: true,
                route: const Splash_Screen(),
                phoneNumber: 55555,
              )
            ],
          ),
          // Tab 3
          ListView(
            padding: EdgeInsets.only(
              left: screenWidth * 0.012,
              right: screenWidth * 0.012,
            ),
            children: [
              const PostWidgetCreate(),
            ],
          ),
        ]),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: screenHeight * 0.022,
            left: screenWidth * 0.07,
            right: screenWidth * 0.07,
          ),
          child: Container(
            height: screenHeight * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
              color: const Color.fromRGBO(198, 216, 255, 1),
            ),
            child: TabBar(
              padding: EdgeInsets.all(screenWidth * 0.02),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(100000),
                color: const Color.fromRGBO(236, 254, 255, 1),
                border: Border.all(style: BorderStyle.solid),
              ),
              tabs: [
                tab('Home', CupertinoIcons.home),
                tab('Chat', CupertinoIcons.chat_bubble),
                tab('Advert', null),
              ],
            ),
          ),
        ),
        extendBody: true,
      ),
    );
  }

  Widget tab(
    String TabName,
    IconData? IconName,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (IconName != null)
          Text(
            TabName,
            style: TextStyle(
              fontSize: screenWidth * 0.048,
              color: const Color.fromRGBO(0, 83, 44, 1),
            ),
          ),
        if (IconName == null)
          Center(
            child: Text(
              TabName,
              style: TextStyle(
                fontSize: screenWidth * 0.048,
                color: const Color.fromRGBO(0, 83, 44, 1),
              ),
            ),
          ),
        if (IconName != null)
          Icon(
            IconName,
            color: const Color.fromRGBO(0, 83, 44, 1),
            size: screenWidth * 0.048,
          ),
      ],
    );
  }

  void _showSettingsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SettingsDialog();
        });
  }
}
