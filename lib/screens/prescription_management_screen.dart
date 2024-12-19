import 'package:flutter/material.dart';

class PrescriptionManagementScreen extends StatelessWidget {
  const PrescriptionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prescriptions = [
      {'date': '15/03/2024', 'status': 'En attente'},
      {'date': '10/03/2024', 'status': 'Traitée'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Ordonnances'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: ListView.builder(
          itemCount: prescriptions.length,
          itemBuilder: (context, index) {
            final prescription = prescriptions[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Icon(
                  Icons.description,
                  color: Colors.green[600],
                ),
                title: Text('Ordonnance du ${prescription['date']}'),
                subtitle: Text('Status: ${prescription['status']}'),
                trailing: Icon(Icons.chevron_right, color: Colors.green[300]),
                onTap: () {
                  // Afficher les détails de l'ordonnance
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ajouter une nouvelle ordonnance
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add),
      ),
    );
  }
}
