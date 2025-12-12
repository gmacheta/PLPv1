import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';

class Apartment {
  final int id;
  final String province;
  final String city;
  final double monthlyPrice;
  final int rooms;

  Apartment({
    required this.id,
    required this.province,
    required this.city,
    required this.monthlyPrice,
    required this.rooms,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['id'] as int,
      province: json['Province']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      monthlyPrice: (json['monthlyPrice'] as num).toDouble(),
      rooms: json['rooms'] as int,
    );
  }
}

class ApartmentsService {
  final _client = apiClient;

  Future<List<Apartment>> fetchAll() async {
    final http.Response resp = await _client.get('apartments');

    if (resp.statusCode >= 400) {
      throw Exception('Error ${resp.statusCode}: ${resp.body}');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final list = (data['apartments'] as List?) ?? [];

    return list
        .map((e) => Apartment.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final apartmentsService = ApartmentsService();
