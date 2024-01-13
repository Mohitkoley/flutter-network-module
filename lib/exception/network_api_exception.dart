import 'package:network/exception/base_api_exception.dart';

class FetchDataException extends BaseApiException {
  FetchDataException([String? message, String? prefixMessage])
      : super(message ?? "", 500, prefixMessage);
}

class BadRequestException extends BaseApiException {
  BadRequestException([String? message, String? prefixMessage])
      : super(message ?? "", 400, prefixMessage);
}

class TemporaryUnavailableException extends BaseApiException {
  TemporaryUnavailableException([String? message, String? prefixMessage])
      : super(message ?? "", 503, prefixMessage);
}

class UnAuthorizedException extends BaseApiException {
  UnAuthorizedException([String? message, String? prefixMessage])
      : super(message ?? "", 401, prefixMessage);
}

class InvalidInputException extends BaseApiException {
  InvalidInputException([String? message, String? prefixMessage])
      : super(message ?? "", 422, prefixMessage);
}

class InvalidFormatException extends BaseApiException {
  InvalidFormatException([String? message, String? prefixMessage])
      : super(message ?? "", 406, prefixMessage);
}

class NotFoundException extends BaseApiException {
  NotFoundException([String? message, String? prefixMessage])
      : super(message ?? "", 404, prefixMessage);
}

class NoInternetException extends BaseApiException {
  NoInternetException([String? message, String? prefixMessage])
      : super(message ?? "", 503, prefixMessage);
}
