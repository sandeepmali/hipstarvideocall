import 'dart:convert';

import 'package:hipstarvideocall/helper/logs.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  static late HttpClient _instance;
  final String baseUrl;

  HttpClient._internal(this.baseUrl);

  static void init({required String baseUrl}) {
    _instance = HttpClient._internal(baseUrl);
  }

  static HttpClient get instance => _instance;

  // Example POST method
  Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$path');

    // Log URL, headers, and body
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': 'reqres-free-v1'
    };

    Logs.debug('POST Request: $url');
    Logs.debug('Headers: $headers');
    Logs.debug('Body: ${jsonEncode(body)}');

    try {
      final response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      Logs.debug('Response Status: ${response.statusCode}');
      Logs.debug('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('HttpClient Error: $e');
    }
  }

  // Example GET method
  Future<Map<String, dynamic>> get(String path,
      {Map<String, String>? queryParams}) async {
    final uri =
        Uri.parse('$baseUrl/$path').replace(queryParameters: queryParams);

    // Headers (same as POST)
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': 'reqres-free-v1',
    };

    Logs.debug('GET Request: $uri');
    Logs.debug('Headers: $headers');

    try {
      final response = await http.get(uri, headers: headers);

      Logs.debug('Response Status: ${response.statusCode}');
      Logs.debug('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      Logs.error('HttpClient GET Error: $e');
      throw Exception('HttpClient Error: $e');
    }
  }
}
