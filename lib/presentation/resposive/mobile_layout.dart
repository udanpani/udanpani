import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:udanpani/core/colors.dart';
import 'package:udanpani/core/constants.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;

  PageController pageController = PageController();

  void navigationTapped(int page) {
    pageController.animateToPage(page,
        duration: animationDuration, curve: Curves.easeOut);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: pages,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        currentIndex: _page,
        onTap: navigationTapped,
        items: navItems,
      ),
    );
  }
}
