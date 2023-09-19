class Failure {
  final String message;
  final String code;

  Failure({required this.message, this.code = 'Generic'});

  @override
  String toString() {
    return 'Failure{message: $message, code: $code}';
  }
}
