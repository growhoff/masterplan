class StateLogin {
    final String text;
  StateLogin({
    this.text = '',
  });

  StateLogin copyWith({
    String? text,
  }) {
    return StateLogin(
      text: text ?? this.text,
    );
  }
}
