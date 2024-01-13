import 'dart:io';

import 'package:http/http.dart';

abstract class BaseApiServices {
  Future<dynamic> getApiResponse(
      String path, Map<String, dynamic> queryParameter,
      [String baseUrl]);

  Future<dynamic> postApiResponse(
      String path, Map<String, dynamic> queryParameter,
      [String baseUrl]);

  Future<dynamic> putApiResponse(
    String path,
    dynamic queryParameter,
  );

  Future<dynamic> getPostMultiPartApiResponse(
      String url, Map<String, String> data, File image);

  Future<dynamic> deleteApiResponse(
    String path,
    dynamic queryParameter,
  );

  Future<Response> convertStreamedResponseToResponse(
      StreamedResponse streamedResponse);

  Future<void> connectSocketIO(String email);

  Stream<dynamic> listenToSocketIO(String event);

  Future<void> disconnectSocketIO();
}
