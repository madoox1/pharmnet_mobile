import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../services/prescription_service.dart';

class PrescriptionImageScreen extends StatelessWidget {
  final int prescriptionId;
  final int patientId;

  const PrescriptionImageScreen({
    super.key,
    required this.prescriptionId,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Ordonnance'),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<Uint8List>(
        future: PrescriptionService().getPrescriptionImage(patientId, prescriptionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Aucune image disponible'));
          }

          return InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4,
            child: Center(
              child: Image.memory(
                snapshot.data!,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
