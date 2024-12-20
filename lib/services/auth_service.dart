import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Update the base URL to use IP address
  static const String _baseUrl =
      'http://10.0.2.2:8080/pharmacy-system-backend-1.0-SNAPSHOT/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'motDePasse': password,
        }),
      );

      switch (response.statusCode) {
        case 200:
          final userData = json.decode(response.body);
          if (userData['role'] != 'Patient') {
            throw Exception(
                'Cette application est réservée aux patients. Veuillez utiliser l\'application web.');
          }
          return userData;
        case 401:
          throw Exception('Email ou mot de passe invalide');
        case 404:
          throw Exception('Compte non trouvé');
        default:
          throw Exception('Une erreur est survenue');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
