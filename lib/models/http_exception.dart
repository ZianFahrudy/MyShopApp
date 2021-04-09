part of 'models.dart';

class HttpExceptionz implements Exception {
  final String message;

  HttpExceptionz(this.message);

  @override
  String toString() {
    return message;
    // return super.toString();
  }
}
