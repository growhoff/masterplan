// ignore_for_file: public_member_api_docs, sort_constructors_first
class OperatorOperations {
  final int id;
  final int order;
  final String region;
  final String company;
  final int time;
  final int timeStart;
  final int timeWorking;
  final String status;
  final int stageOperationId;
  final int stageMasterOperationId;
  final String equipment;
  final String details;
  OperatorOperations({
    required this.id,
    required this.order,
    required this.region,
    required this.company,
    required this.time,
    required this.timeStart,
    required this.timeWorking,
    required this.status,
    required this.stageOperationId,
    required this.stageMasterOperationId,
    required this.equipment,
    required this.details,
  });

  OperatorOperations copyWith({
    int? id,
    int? order,
    String? region,
    String? company,
    int? time,
    int? timeStart,
    int? timeWorking,
    String? status,
    int? stageOperationId,
    int? stageMasterOperationId,
    String? equipment,
    String? details,
  }) {
    return OperatorOperations(
      id: id ?? this.id,
      order: order ?? this.order,
      region: region ?? this.region,
      company: company ?? this.company,
      time: time ?? this.time,
      timeStart: timeStart ?? this.timeStart,
      timeWorking: timeWorking ?? this.timeWorking,
      status: status ?? this.status,
      stageOperationId: stageOperationId ?? this.stageOperationId,
      stageMasterOperationId: stageMasterOperationId ?? this.stageMasterOperationId,
      equipment: equipment ?? this.equipment,
      details: details ?? this.details,
    );
  }
}
