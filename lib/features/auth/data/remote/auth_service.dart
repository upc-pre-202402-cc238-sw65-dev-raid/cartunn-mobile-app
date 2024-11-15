import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:cartunn/core/app_constants.dart';
import 'package:cartunn/features/auth/data/remote/login_request.dart';
import 'package:cartunn/features/auth/data/remote/login_dto.dart';

class AuthService {
  String? _token;

  Future<LoginDto?> login(String username, String password) async {
    http.Response response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/authentication/sign-in'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            LoginRequest(username: username, password: password).toMap()));
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> json = jsonDecode(response.body);
      final loginDto = LoginDto.fromJson(json);
      _token = json['token'];
      return loginDto;
    }

    return null;
  }

  String? get token => _token;
}
