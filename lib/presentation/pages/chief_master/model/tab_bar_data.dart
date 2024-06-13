import 'package:flutter/material.dart';

class TabBarDataChiefMaster {
  final String title;
  final List<Widget> actions;
  final Widget page;
  final IconData icon;
  TabBarDataChiefMaster({
    required this.title,
    required this.actions,
    required this.page,
    required this.icon,
  });
}