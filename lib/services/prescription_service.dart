import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PrescriptionService {
  static const String baseUrl =
      'http://10.0.2.2:8080/pharmacy-system-backend-1.0-SNAPSHOT/api';

  Future<List<Map<String, dynamic>>> getPatientPrescriptions(
      int patientId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/$patientId/ordonnances'),
        headers: {'Content-Type': 'application/json'},
      );

      switch (response.statusCode) {
        case 200:
          final List<dynamic> prescriptionsJson = json.decode(response.body);
          return prescriptionsJson
              .map((json) => json as Map<String, dynamic>)
              .toList();
        case 404:
          final error = json.decode(response.body);
          throw Exception(error['message']);
        default:
          throw Exception('Erreur lors de la récupération des ordonnances');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> createPrescription(
      int patientId, int pharmacyId, File imageFile) async {
    try {
      // Convertir l'image en base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final encodedImage = 'data:image/jpeg;base64,$base64Image';

      final response = await http.post(
        Uri.parse('$baseUrl/patients/$patientId/ordonnances'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'pharmacieId': pharmacyId,
          'encodedImage': encodedImage,
        }),
      );

      switch (response.statusCode) {
        case 201:
          return json.decode(response.body);
        case 400:
          final error = json.decode(response.body);
          throw Exception(error['message']);
        case 404:
          final error = json.decode(response.body);
          throw Exception(error['message']);
        default:
          throw Exception('Erreur lors de la création de l\'ordonnance');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
