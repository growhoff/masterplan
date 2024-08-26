import 'package:flutter/material.dart';
import 'package:master_plan/presentation/widgets/in_development_page.dart';


import '../../chief/model/tab_bar_model.dart';
import '../archive_page/archive_page.dart';

abstract class TechnologistData {
  static List<TabBarModel> listPage = [
    TabBarModel(
        title: 'Архив',
        actions: [],
        page:  DispatcherArchivePage(),
        icon: Icons.archive_rounded),
    TabBarModel(
        title: ' ',
        actions: [],
        page:  InDevelopmentPage(),
        icon: Icons.stop_circle_rounded),
  ];
}
