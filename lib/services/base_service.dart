import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class BaseService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<T> handleResponse<T>(http.Response response, T Function(Map<String, dynamic>) fromJson) async {
    switch (response.statusCode) {
      case 200:
      case 201:
        return fromJson(json.decode(response.body));
      case 401:
        throw Exception(AppConstants.sessionExpiredMessage);
      case 404:
        throw Exception('Resource not found');
      default:
        try {
          final error = json.decode(response.body);
          throw Exception(error['message'] ?? AppConstants.defaultErrorMessage);
        } catch (_) {
          throw Exception(AppConstants.defaultErrorMessage);
        }
    }
  }

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };
}
