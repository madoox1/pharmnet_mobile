import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample local data
    final pharmacies = [
      {'name': 'Pharmacy A', 'status': 'Active'},
      {'name': 'Pharmacy B', 'status': 'Inactive'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy Map'),
      ),
      body: ListView.builder(
        itemCount: pharmacies.length,
        itemBuilder: (context, index) {
          final pharmacy = pharmacies[index];
          return ListTile(
            title: Text(pharmacy['name']!),
            subtitle: Text('Status: ${pharmacy['status']}'),
            leading: Icon(
              pharmacy['status'] == 'Active' ? Icons.check_circle : Icons.cancel,
              color: pharmacy['status'] == 'Active' ? Colors.green : Colors.red,
            ),
          );
        },
      ),
    );
  }
}
