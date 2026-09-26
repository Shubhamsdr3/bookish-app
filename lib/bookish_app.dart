class BookishApp {

  static final BookishApp _singleton = BookishApp._internal();

  factory BookishApp() {
    return _singleton;
  }

  BookishApp._internal();
}
