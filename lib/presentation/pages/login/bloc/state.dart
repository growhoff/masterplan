// ignore_for_file: public_member_api_docs, sort_constructors_first
class StateLogin {
  final bool isSelect;
  final String text;
  final String login;
  final String password;
  final String company;
  StateLogin({
    this.isSelect = false,
    this.text = '',
    this.login = '',
    this.password = '',
    this.company = '',
  });



  StateLogin copyWith({
    bool? isSelect,
    String? text,
    String? login,
    String? password,
    String? company,
  }) {
    return StateLogin(
      isSelect: isSelect ?? this.isSelect,
      text: text ?? this.text,
      login: login ?? this.login,
      password: password ?? this.password,
      company: company ?? this.company,
    );
  }

  @override
  bool operator ==(covariant StateLogin other) {
    if (identical(this, other)) return true;
  
    return 
      other.isSelect == isSelect &&
      other.text == text &&
      other.login == login &&
      other.password == password &&
      other.company == company;
  }

  @override
  int get hashCode {
    return isSelect.hashCode ^
      text.hashCode ^
      login.hashCode ^
      password.hashCode ^
      company.hashCode;
  }
}
