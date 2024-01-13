import 'package:flutter/material.dart';
import 'package:network/index.dart';

class Examples {
  final NetworkApiServices _networkApiServices = NetworkApiServices();

  Future<dynamic> getApiCall() async {
    try {
      final response = await _networkApiServices
          .getApiResponse('/Mohitkoley/dummy_api/main/person_dev.json', {});
      debugPrint(response.toString());
    } catch (e) {
      rethrow;
    }
  }
}
