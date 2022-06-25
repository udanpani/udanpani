import 'package:flutter/material.dart';
import 'package:udanpani/presentation/screens/home_pages/listed_jobs_screen.dart';
import 'package:udanpani/presentation/screens/home_pages/profile_screen.dart';
import 'package:udanpani/presentation/screens/home_pages/work_available_screen.dart';

const int webScreenWidth = 600;
const Duration animationDuration = Duration(milliseconds: 500);

List<BottomNavigationBarItem> navItems = [
  const BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    label: '',
    activeIcon: Icon(Icons.home),
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.add_box_outlined),
    label: '',
    activeIcon: Icon(Icons.add_box),
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.person_outline_rounded),
    label: '',
    activeIcon: Icon(Icons.person_rounded),
  ),
];

List<Widget> pages = [
  const WorkAvailable(),
  const JobsListed(),
  const ProfileScreen(),
];
