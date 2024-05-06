// ignore_for_file: public_member_api_docs, sort_constructors_first
class StateLogin {
  final bool isSelect;
  final String text;
  StateLogin({
    this.isSelect = false,
    this.text = '',
  });

  StateLogin copyWith({
    bool? isSelect,
    String? text,
  }) {
    return StateLogin(
      isSelect: isSelect ?? this.isSelect,
      text: text ?? this.text,
    );
  }

  @override
  bool operator ==(covariant StateLogin other) {
    if (identical(this, other)) return true;
  
    return 
      other.isSelect == isSelect &&
      other.text == text;
  }

  @override
  int get hashCode => isSelect.hashCode ^ text.hashCode;
}
