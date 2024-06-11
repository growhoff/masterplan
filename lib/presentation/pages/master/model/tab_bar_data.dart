import 'package:flutter/material.dart';

class TabBarData {
  final String title;
  final List<Widget> actions;
  final Widget page;
  final IconData icon;
  TabBarData({
    required this.title,
    required this.actions,
    required this.page,
    required this.icon,
  });
}