import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository {
  final String apiUrl = 'https://dummyjson.com/auth/login';
  final SharedPreferences sharedPreferences;


  AuthenticationRepository({required this.sharedPreferences});


  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final authToken = responseData['token'];

      await sharedPreferences.setString('authToken', authToken);

      return true;
    } else {
      return false;
    }
  }
}