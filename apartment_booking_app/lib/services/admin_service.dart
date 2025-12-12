import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class PendingUser {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String dateOfBirth;
  final String type; // 'owner' or 'renter'

  PendingUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.dateOfBirth,
    required this.type,
  });

  factory PendingUser.fromJson(Map<String, dynamic> json, String type) {
    return PendingUser(
      id: json['id'] as int,
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      dateOfBirth: json['DateofBirth']?.toString() ?? '',
      type: type,
    );
  }
}

class AdminService {
  final _client = apiClient;

  Future<void> login({
    required String phone,
    required String password,
  }) async {
    final http.Response resp = await _client.post('adminLogin', body: {
      'phone': phone,
      'password': password,
    });

    final data = jsonDecode(resp.body);

    if (resp.statusCode >= 400) {
      throw Exception(data['message'] ?? 'Admin login failed.');
    }

    final token = data['token'] as String?;
    if (token == null) {
      throw Exception('No token in response.');
    }

    _client.setToken(token);
  }

  Future<List<PendingUser>> getPendingRegistrations() async {
    final http.Response resp = await _client.get('adminPending');

    if (resp.statusCode >= 400) {
      throw Exception('Failed to load pending registrations: ${resp.body}');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    
    final List<PendingUser> allPending = [];

    // Parse pending owners
    final ownersList = (data['pending_owners'] as List?) ?? [];
    for (var owner in ownersList) {
      allPending.add(PendingUser.fromJson(owner as Map<String, dynamic>, 'owner'));
    }

    // Parse pending renters
    final rentersList = (data['pending_renters'] as List?) ?? [];
    for (var renter in rentersList) {
      allPending.add(PendingUser.fromJson(renter as Map<String, dynamic>, 'renter'));
    }

    return allPending;
  }

  Future<void> approveUser(int id, String type) async {
    final endpoint = type == 'owner' 
        ? 'adminApproveOwner/$id' 
        : 'adminApproveRenter/$id';

    final http.Response resp = await _client.post(endpoint, body: {});

    if (resp.statusCode >= 400) {
      final data = jsonDecode(resp.body);
      throw Exception(data['message'] ?? 'Failed to approve user.');
    }
  }

  Future<void> rejectUser(int id, String type) async {
    final endpoint = type == 'owner' 
        ? 'adminRejectOwner/$id' 
        : 'adminRejectRenter/$id';

    final http.Response resp = await _client.delete(endpoint);

    if (resp.statusCode >= 400) {
      final data = jsonDecode(resp.body);
      throw Exception(data['message'] ?? 'Failed to reject user.');
    }
  }

  Future<void> logout() async {
    final http.Response resp = await _client.post('adminLogout', body: {});

    if (resp.statusCode >= 400) {
      final data = jsonDecode(resp.body);
      throw Exception(data['message'] ?? 'Logout failed.');
    }

    _client.setToken(null);
  }
}

final adminService = AdminService();

