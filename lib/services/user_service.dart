import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  static const String baseUrl =
      'http://10.0.2.2:8080/pharmacy-system-backend-1.0-SNAPSHOT/api';

  Future<User> updateProfile(int userId, User user) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/patients/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      switch (response.statusCode) {
        case 200:
          return User.fromJson(json.decode(response.body));
        case 409:
          final error = json.decode(response.body);
          throw Exception(error['message']);
        default:
          throw Exception('Erreur lors de la mise à jour du profil');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
