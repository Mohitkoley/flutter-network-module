import 'package:network/network.dart';

class ApiResponse<T> {
  Status? status;
  String? errorMessage;
  int? code;
  T? data;

  ApiResponse({this.status, this.errorMessage, this.code, this.data});

  ApiResponse.loading() : status = Status.loading;

  ApiResponse.completed(this.data) : status = Status.completed;

  ApiResponse.error(this.errorMessage, this.code) : status = Status.error;

  ApiResponse.initial() : status = Status.initial;

  @override
  String toString() {
    return "Status : $status \n Message: $errorMessage \n Data: $data \n Code: $code";
  }
}
