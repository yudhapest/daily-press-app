// ignore_for_file: library_private_types_in_public_api, unused_element

import 'package:daily_press/common/styles.dart';
import 'package:daily_press/ui/home_page.dart';
import 'package:daily_press/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  static const routeName = '/splash-screen-page';
  const SplashScreenPage({super.key});

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/logo_daily.png'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: secondaryColor,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/logo_daily.png'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
