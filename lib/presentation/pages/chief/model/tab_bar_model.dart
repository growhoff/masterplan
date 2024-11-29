import 'package:flutter/material.dart';

class TabBarModel {
  final String title;
  final List<Widget> actions;
  final Widget page;
  final IconData icon;
  TabBarModel({
    required this.title,
    required this.actions,
    required this.page,
    required this.icon,
  });
}