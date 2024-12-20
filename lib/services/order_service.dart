import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  static const String _baseUrl = 'http://10.0.2.2:8080/pharmacy-system-backend-1.0-SNAPSHOT/api';

  Future<List<Order>> getOrders(int patientId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/patients/$patientId/commandes'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> ordersJson = json.decode(response.body);
        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        // Retourner une liste vide si aucune commande n'est trouvée
        return [];
      } else {
        throw Exception('Erreur lors de la récupération des commandes');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}
