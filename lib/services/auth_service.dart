import 'dart:convert';
import 'package:FlutterVerse/111_shahid/login_screen.dart';
import 'package:FlutterVerse/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../constants/api_constants.dart';
import '../providers/user_provider.dart';
import '../utils/token_storage.dart';

class AuthService {
  static Future<String?> signup(
      String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(signupUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'username': username, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return "ok"; // success
      } else {
        await TokenStorage.saveUserData(jsonEncode(response.body));
        final json = jsonDecode(response.body);

        return json['msg'] ?? 'Signup failed';
      }
    } catch (e) {
      return 'Network error';
    }
  }

  static Future<Map<String, dynamic>> verifyOTP(
      String email, String otp) async {
    final res = await http.post(
      Uri.parse(verifyUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );
    final data = jsonDecode(res.body);
    return {
      'success': res.statusCode == 200,
      'message': data['msg'],
    };
  }

  static Future<UserModel?> login(String email, String password) async {
    final res = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return UserModel.fromJson(data);
    } else {
      return null; // login failed
    }
  }

  static Future<String?> forgotPassword(String email) async {
    final res = await http.post(
      Uri.parse(forgotUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return _extractMessage(res);
  }

  static Future<String?> resetPassword(
      String email, String otp, String newPassword) async {
    final res = await http.post(
      Uri.parse(resetUrl),
      headers: {'Content-Type': 'application/json'},
      body:
          jsonEncode({'email': email, 'otp': otp, 'newPassword': newPassword}),
    );
    return _extractMessage(res);
  }

  static Future<void> logout(BuildContext context) async {
    await TokenStorage.clearToken();
    Provider.of<UserProvider>(context, listen: false).clearUser();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
  Future<bool> updateUserProfile({
  required String userId,
  required String username,
  required String bio,
  required String newEmail,
  required String profilePicture, // Cloudinary URL or base64
}) async {
  final url = Uri.parse('$userProfileUrl/$userId/update-profile');
  final response = await http.patch(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'bio': bio,
      'newEmail': newEmail,
      'profilePicture': profilePicture,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    print("❌ ${jsonDecode(response.body)['msg']}");
    return false;
  }
}


  static String? _extractMessage(http.Response res) {
    final body = jsonDecode(res.body);
    return body['msg'] ?? 'Something went wrong';
  }
}
