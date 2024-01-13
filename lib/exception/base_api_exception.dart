class BaseApiException implements Exception {
  final String? _prefix;
  final String _message;
  final int _code;

  BaseApiException(
    this._message,
    this._code,
    this._prefix,
  );

  @override
  String toString() {
    return '$_prefix$_message$_code';
  }
}
