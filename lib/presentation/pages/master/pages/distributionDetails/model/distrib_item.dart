// ignore_for_file: public_member_api_docs, sort_constructors_first
class DistribItem {
  final String stageNumber;
  final String detailNumber;
  final String operationName;
  final int count;
  final String? setMachine;
  final int? setCount;
  final bool isSelected;
  DistribItem({
    required this.stageNumber,
    required this.detailNumber,
    required this.operationName,
    required this.count,
    this.setMachine,
    this.setCount,
    required this.isSelected,
  });

  DistribItem copyWith({
    String? stageNumber,
    String? detailNumber,
    String? operationName,
    int? count,
    String? setMachine,
    int? setCount,
    bool? isSelected,
  }) {
    return DistribItem(
      stageNumber: stageNumber ?? this.stageNumber,
      detailNumber: detailNumber ?? this.detailNumber,
      operationName: operationName ?? this.operationName,
      count: count ?? this.count,
      setMachine: setMachine ?? this.setMachine,
      setCount: setCount ?? this.setCount,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
