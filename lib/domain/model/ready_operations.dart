// ignore_for_file: public_member_api_docs, sort_constructors_first
class ReadyOperations {
  final int id;
  final int timePlan;
  final int timeFact;
  final int timeStart;
  final int timeStop;
  final String status;
  final int stageOperationId;
  final String details;
  final String equipment;
  final String user;
  final bool isUploaded;
  ReadyOperations({
    required this.id,
    required this.timePlan,
    required this.timeFact,
    required this.timeStart,
    required this.timeStop,
    required this.status,
    required this.stageOperationId,
    required this.details,
    required this.equipment,
    required this.user,
    required this.isUploaded,
  });
}
