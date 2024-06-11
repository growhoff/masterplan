// ignore_for_file: public_member_api_docs, sort_constructors_first
class StatusNext {
  final int status;
  final int count;
  StatusNext({
    required this.status,
    required this.count,
  });

  StatusNext copyWith({
    int? status,
    int? count,
  }) {
    return StatusNext(
      status: status ?? this.status,
      count: count ?? this.count,
    );
  }
}
