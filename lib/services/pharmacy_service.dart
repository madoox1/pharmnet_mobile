import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pharmacy.dart';

class PharmacyService {
  static const String _baseUrl = 'http://10.0.2.2:8080/pharmacy-system-backend-1.0-SNAPSHOT/api';

  Future<List<Pharmacy>> getPharmacies() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/pharmacies'));

      if (response.statusCode == 200) {
        final List<dynamic> pharmaciesJson = json.decode(response.body);
        return pharmaciesJson.map((json) => Pharmacy.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des pharmacies');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}
