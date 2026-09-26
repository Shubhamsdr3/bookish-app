extension on String? {
  bool toBoolean() {
    if(!this.isNullOrEmpty() && this!.toLowerCase() == "true") {
      return true;
    } else {
      return false;
    }
  }

  bool isNullOrEmpty() => this != null  && this!.isNotEmpty;
}