import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ralali_bakery/models/cake_model.dart';

class ApiService {
  static const baseUrl = 'https://611a268fcbf1b30017eb5527.mockapi.io';

  Future<List<CakeModel>> getCakes() async {
    final response = await http.get(Uri.parse('$baseUrl/cakes'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => CakeModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch cakes');
    }
  }

  Future<CakeModel> getCakeDetails(String cakeId) async {
    final response = await http.get(Uri.parse('$baseUrl/cakes/$cakeId'));
    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);
      return CakeModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to fetch cake details');
    }
  }

  Future<void> addCake(CakeModel cake) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cakes'),
      body: jsonEncode(cake.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add cake');
    }
  }

  Future<void> deleteCake(String cakeId) async {
    final response = await http.delete(Uri.parse('$baseUrl/cakes/$cakeId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete cake');
    }
  }
}
