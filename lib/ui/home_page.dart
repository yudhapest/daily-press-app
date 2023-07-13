import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:daily_press/common/styles.dart';
import 'package:daily_press/ui/article_detail_page.dart';
import 'package:daily_press/ui/article_list_page.dart';
import 'package:daily_press/ui/bookmarks_page.dart';
import 'package:daily_press/ui/settings_page.dart';
import 'package:daily_press/utils/notification_helper.dart';
import 'package:daily_press/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home-page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  int _bottomNavIndex = 0;

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.news : Icons.public),
      label: "Headline",
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS
          ? CupertinoIcons.bookmark
          : Icons.collections_bookmark),
      label: "Bookmarks",
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
      label: "Setting",
    ),
  ];

  final List<Widget> _listWidget = [
    const ArticleListPage(),
    const BookmarksPage(),
    const SettingsPage(),
  ];

  Widget _buildAndroid(BuildContext context) {
    Color backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[900]!
        : secondaryColor;
    Color iconColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.black;

    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: Theme.of(context).iconTheme.copyWith(color: iconColor),
        ),
        child: CurvedNavigationBar(
          backgroundColor: backgroundColor,
          height: 55,
          items: const [
            Icon(Icons.public),
            Icon(Icons.collections_bookmark),
            Icon(Icons.settings),
          ],
          onTap: (selected) {
            setState(() {
              _bottomNavIndex = selected;
            });
          },
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: secondaryColor,
        items: _bottomNavBarItems,
      ),
      tabBuilder: (context, index) {
        return _listWidget[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(ArticleDetailPage.routeName);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectNotificationSubject.close();
    super.dispose();
  }
}
