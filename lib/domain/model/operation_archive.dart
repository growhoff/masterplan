import 'package:master_plan/domain/model/stage_archive.dart';

class OperationArchive {
  final int id;
  final String number;
  final String name;
  final String code;
  final int timepz;
  final int stageArchiveId;
  final StageArchive? stageArchive;
  final int timeSH;

  OperationArchive(
      {required this.id,
      required this.number,
      required this.name,
      required this.code,
      required this.timepz,
      required this.stageArchiveId,
      this.stageArchive,
      required this.timeSH});
}
