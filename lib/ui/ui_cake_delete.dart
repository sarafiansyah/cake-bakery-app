import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CakeService {
  static Future<bool> deleteCake(String cakeId) async {
    final apiUrl = 'https://611a268fcbf1b30017eb5527.mockapi.io/cakes/$cakeId';
    final response = await http.delete(Uri.parse(apiUrl));

    return response.statusCode == 200;
  }
}
