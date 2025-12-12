import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'api_client.dart';

enum UserRole { owner, renter }

String roleLabel(UserRole role) =>
    role == UserRole.owner ? 'Owner' : 'Renter';

class AuthService {
  final _client = apiClient;

  String _pathForRole(UserRole role, String action) {
    final prefix = role == UserRole.owner ? 'owner' : 'renter';
    return '$prefix$action'; // e.g. ownerLogin, renterLogin
  }

  Future<void> login({
    required UserRole role,
    required String phone,
    required String password,
  }) async {
    final path = _pathForRole(role, "Login");
    final http.Response resp = await _client.post(path, body: {
      'phone': phone,
      'password': password,
    });

    final data = jsonDecode(resp.body);

    if (resp.statusCode == 403) {
      // Not approved by admin
      throw Exception(data['message'] ?? 'Account not approved yet.');
    }

    if (resp.statusCode >= 400) {
      throw Exception(data['message'] ?? 'Login failed.');
    }

    final token = data['token'] as String?;
    if (token == null) {
      throw Exception('No token in response.');
    }

    _client.setToken(token);
  }

  Future<void> register({
    required UserRole role,
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String phone,
    required String password,
    required XFile personalPhoto,
    required XFile idPhoto,
  }) async {
    final path = _pathForRole(role, "Register");

    // Build multipart image files (works on web with readAsBytes)
    final files = <http.MultipartFile>[
      http.MultipartFile.fromBytes(
        'Personal_photo',
        await personalPhoto.readAsBytes(),
        filename: personalPhoto.name,
      ),
      http.MultipartFile.fromBytes(
        'Id_photo',
        await idPhoto.readAsBytes(),
        filename: idPhoto.name,
      ),
    ];

    final resp = await _client.postMultipart(
      path,
      fields: {
        'firstName': firstName,
        'lastName': lastName,
        'DateofBirth': dateOfBirth,
        'phone': phone,
        'password': password,
      },
      files: files,
    );

    final data = jsonDecode(resp.body);

    if (resp.statusCode >= 400) {
      throw Exception(data['message'] ?? 'Registration failed.');
    }

    // Backend returns OTP etc.; for now we just assume success if no error.
  }
}

final authService = AuthService();
