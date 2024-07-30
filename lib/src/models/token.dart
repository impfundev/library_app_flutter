class Token {
  String key;

  Token(this.key);

  static Token? fromJson(data) {
    return Token(data['token']);
  }
}
