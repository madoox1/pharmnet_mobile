import 'package:flutter/material.dart';
import 'package:pharmnet_mobile/screens/create_prescription_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pharmacies = [
      {
        'name': 'Pharmacie Centrale',
        'status': 'Active',
        'distance': '0.5 km',
        'address': '123 Rue Mohammed V',
        'x': 0.3, // Position relative sur la carte (0-1)
        'y': 0.4, // Position relative sur la carte (0-1)
      },
      {
        'name': 'Pharmacie du Marché',
        'status': 'Active',
        'distance': '1.2 km',
        'address': '45 Avenue Hassan II',
        'x': 0.7,
        'y': 0.6,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacies à proximité'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green[300]!),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                // Fond de carte simple
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                // Points des pharmacies
                ...pharmacies.map((pharmacy) => Positioned(
                      left: MediaQuery.of(context).size.width * 
                            (pharmacy['x'] as double) * 0.8,
                      top: 300 * (pharmacy['y'] as double),
                      child: GestureDetector(
                        onTap: () => _showPharmacyDetails(context, pharmacy),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: pharmacy['status'] == 'Active' 
                                  ? Colors.green 
                                  : Colors.red,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.local_pharmacy,
                            color: pharmacy['status'] == 'Active' 
                                ? Colors.green 
                                : Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pharmacies.length,
              itemBuilder: (context, index) {
                final pharmacy = pharmacies[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.local_pharmacy,
                      color: pharmacy['status'] == 'Active' 
                          ? Colors.green[600] 
                          : Colors.red,
                    ),
                    title: Text(pharmacy['name'] as String),
                    subtitle: Text(pharmacy['address'] as String),
                    trailing: Text(pharmacy['distance'] as String),
                    onTap: () => _showPharmacyDetails(context, pharmacy),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPharmacyDetails(BuildContext context, Map<String, dynamic> pharmacy) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pharmacy['name'] as String,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Adresse: ${pharmacy['address']}'),
            Text('Distance: ${pharmacy['distance']}'),
            Text('Status: ${pharmacy['status']}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la modal
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePrescriptionScreen(pharmacyId: 1), // Remplacer 1 par pharmacy['id']
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('Envoyer une ordonnance'),
            ),
          ],
        ),
      ),
    );
  }
}
