class HttpExeceptionM implements Exception {
  final String message;
  HttpExeceptionM(this.message);
  @override
  String toString() => "HttpException: $message";
}
