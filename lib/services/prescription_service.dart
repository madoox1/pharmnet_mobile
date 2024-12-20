import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/prescription.dart';

class PrescriptionService {
  static const String _baseUrl =
      'http://10.0.2.2:8080/pharmacy-system-backend-1.0-SNAPSHOT/api';

  Future<List<Prescription>> getPrescriptions(int patientId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/patients/$patientId/ordonnances'),
      );

      switch (response.statusCode) {
        case 200:
          final List<dynamic> prescriptionsJson = json.decode(response.body);
          return prescriptionsJson.map((json) => Prescription.fromJson(json)).toList();
        case 404:
          return []; // Retourne une liste vide pour le cas où aucune ordonnance n'est trouvée
        default:
          throw Exception('Erreur lors de la récupération des ordonnances');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  String getPrescriptionImageUrl(int patientId, int prescriptionId) {
    return '$_baseUrl/patients/$patientId/ordonnances/$prescriptionId/image';
  }

  Future<Map<String, dynamic>> createPrescription(
      int patientId, int pharmacyId, File imageFile) async {
    try {
      // Convertir l'image en base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final encodedImage = 'data:image/jpeg;base64,$base64Image';

      final response = await http.post(
        Uri.parse('$_baseUrl/patients/$patientId/ordonnances'),
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

  Future<Uint8List> getPrescriptionImage(
      int patientId, int prescriptionId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/patients/$patientId/ordonnances/$prescriptionId/image'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Erreur lors de la récupération de l\'image');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
