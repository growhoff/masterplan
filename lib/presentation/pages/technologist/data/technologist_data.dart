import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/technologist/archive_page/archive_page.dart';


import '../../chief/model/tab_bar_model.dart';

abstract class TechnologistData {
  static List<TabBarModel> listPage = [
    TabBarModel(
        title: 'Архив',
        actions: [],
        page:  ArchivePage(),
        icon: Icons.archive_rounded),
    TabBarModel(
        title: ' ',
        actions: [],
        page:  Container(),
        icon: Icons.stop_circle_rounded),
  ];
}
