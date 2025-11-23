import 'dart:convert';

import 'package:http/http.dart' as http;

class THttpHelper {
  static const String _baseApiUrl = "https://testapi.talentlenshub.com/";

  // Helper method for GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse("$_baseApiUrl/$endpoint"));
    return _handleResponse(response);
  }

  // Helper method for POST request
  static Future<Map<String, dynamic>> post(
      String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse("$_baseApiUrl/$endpoint"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  //Handle the HTTP response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  }
}
