class httpException implements Exception{
  final String message;
  httpException(this.message);
  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}