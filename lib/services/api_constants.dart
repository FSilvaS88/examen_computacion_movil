import 'dart:convert';

class ApiConstants {
  static const String baseUrl = "http://10.109.12.39:8000/api/";
  static const String user = 'test';
  static const String pass = 'test2023';

  static Map<String, String> get headers => {
    'Authorization': 'Basic ${base64Encode(utf8.encode('$user:$pass'))}',
    'Content-Type': 'application/json',
  };
}
