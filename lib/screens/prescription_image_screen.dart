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
        title: const Text('Détails Ordonnance'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              // Ajouter la fonctionnalité de téléchargement
            },
            tooltip: 'Télécharger l\'ordonnance',
          ),
        ],
      ),
      body: Container(
        color: Colors.black87,
        child: FutureBuilder<Uint8List>(
          future: PrescriptionService().getPrescriptionImage(patientId, prescriptionId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }
            
            if (snapshot.hasError) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, 
                           size: 64, 
                           color: Colors.red[700]),
                      const SizedBox(height: 16),
                      Text(
                        'Erreur: ${snapshot.error}',
                        style: TextStyle(color: Colors.red[700]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4,
              child: Center(
                child: Hero(
                  tag: 'prescription_$prescriptionId',
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ajouter la fonctionnalité de partage
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.share),
      ),
    );
  }
}
