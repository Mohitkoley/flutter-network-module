import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:network/index.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;

class NetworkApiServices extends BaseApiServices {
  final StreamController<dynamic> _webSocketStreamController =
      StreamController.broadcast();
  io.Socket? socket;
  static const int seconds = 60;

  Map<String, String> headers = {
    "Accept": "application/json",
    "Access-Control-Allow-Origin": "*",
    'Access-Control-Allow-Headers': 'Content-Type',
  };

  @override
  Future<dynamic> getApiResponse(
      String path, Map<String, dynamic> queryParameter,
      [String baseUrl = ApiEndpoints.baseurl]) async {
    dynamic responseJson;

    try {
      final response = await http
          .get(Uri.https(baseUrl, path, queryParameter), headers: headers)
          .timeout(
            const Duration(seconds: seconds),
          );
      responseJson = returnResponse(response);
      return responseJson;
    } on SocketException {
      throw NoInternetException("No Internet");
    }
  }

  @override
  Future<dynamic> postApiResponse(
      String path, Map<String, dynamic> queryParameter,
      [String baseUrl = ApiEndpoints.baseurl]) async {
    dynamic responseJson;

    try {
      final response = await http
          .post(Uri.https(baseUrl, path, queryParameter), headers: headers)
          .timeout(
            const Duration(seconds: seconds),
          );
      responseJson = returnResponse(response);
      return responseJson;
    } on SocketException {
      throw NoInternetException("No Internet");
    }
  }

  @override
  Future<dynamic> putApiResponse(
    String path,
    dynamic queryParameter,
  ) async {
    dynamic responseJson;

    try {
      final response = await http
          .put(Uri.https(ApiEndpoints.baseurl, path, queryParameter),
              headers: headers)
          .timeout(
            const Duration(seconds: seconds),
          );
      responseJson = returnResponse(response);
      return responseJson;
    } on SocketException {
      throw NoInternetException("No Internet");
    }
  }

  @override
  Future<dynamic> deleteApiResponse(
    String path,
    dynamic queryParameter,
  ) async {
    dynamic responseJson;

    try {
      final response = await http
          .delete(Uri.https(ApiEndpoints.baseurl, path, queryParameter),
              headers: headers)
          .timeout(
            const Duration(seconds: seconds),
          );
      responseJson = returnResponse(response);
      return responseJson;
    } on SocketException {
      throw NoInternetException("No Internet");
    }
  }

  /// multipart api call
  @override
  Future<dynamic> getPostMultiPartApiResponse(
      String url, Map<String, String> data, File image) async {
    dynamic responseJson;

    try {
      var request = MultipartRequest(
        'POST',
        Uri.https(
          ApiEndpoints.baseurl,
          url,
        ),
      );
      request.headers.addAll(headers);
      request.files.add(await MultipartFile.fromPath('file', image.path));
      request.fields.addAll(data);
      StreamedResponse streamResponse = await request.send().timeout(
            const Duration(seconds: seconds),
          );
      Response response =
          await convertStreamedResponseToResponse(streamResponse);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  @override
  Future<Response> convertStreamedResponseToResponse(
      StreamedResponse streamedResponse) async {
    final bytes = await streamedResponse.stream.toBytes();
    final response = Response.bytes(bytes, streamedResponse.statusCode,
        headers: streamedResponse.headers);
    return response;
  }

  /// Socket IO
  /// socket io connection
  @override
  Future<void> connectSocketIO(String email) async {
    try {
      socket = io.io(SocketEndPoint.baseUrl, {
        'autoConnect': false,
        'transports': ['websocket'],
      });
      socket!.connect();
      socket!.onConnect((data) {
        // log(data);
        // log("${data.runtimeType}");

        socket!.emit("subscribe", jsonEncode({"email": email}));
      });
    } on SocketException {
      throw NoInternetException("No Internet");
    }
  }

  @override
  Stream<dynamic> listenToSocketIO(String event) async* {
    try {
      if (socket!.connected) {
        socket!.on(event, (data) {
          final response = returnResponse(data);
          _webSocketStreamController.add(response);
        });
      }
      yield* _webSocketStreamController.stream;
    } on SocketException {
      throw NoInternetException("No Internet");
    }
  }

  @override
  Future<void> disconnectSocketIO() async {
    try {
      socket!.disconnect();
    } on SocketException {
      throw NoInternetException("No Internet");
    }
  }

  dynamic returnResponse(http.Response response) {
    String responseBody = jsonDecode(response.body).toString();
    switch (response.statusCode) {
      case 200:
        var responseJson = response.body;
        return jsonDecode(responseJson);
      case 400:
        throw BadRequestException(responseBody);
      case 401:
        throw UnAuthorizedException(responseBody);
      case 403:
        throw UnAuthorizedException(responseBody);
      case 404:
        throw NotFoundException(responseBody);
      case 406:
        throw InvalidFormatException(responseBody);
      case 422:
        throw InvalidInputException(responseBody);
      case 500:
        throw FetchDataException(responseBody);
      case 503:
        throw TemporaryUnavailableException(responseBody);
      default:
    }
  }
}
