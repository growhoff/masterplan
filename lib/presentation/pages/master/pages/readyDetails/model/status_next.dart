// ignore_for_file: public_member_api_docs, sort_constructors_first
class StatusNext {
  final int status;
  final int count;
  final String comment;
  StatusNext({
    required this.status,
    required this.count,
    required this.comment,
  });

  StatusNext copyWith({
    int? status,
    int? count,
    String? comment,
  }) {
    return StatusNext(
      status: status ?? this.status,
      count: count ?? this.count,
      comment: comment ?? this.comment,
    );
  }
}
