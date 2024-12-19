import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> orderDetails = {
      'orderId': 'CMD-2024-001',
      'date': '15/03/2024',
      'pharmacy': 'Pharmacie Centrale',
      'total': '250 DH',
      'status': <Map<String, dynamic>>[
        {
          'title': 'Commande reçue',
          'time': '15/03 - 10:30',
          'done': true,
        },
        {
          'title': 'Validation pharmacien',
          'time': '15/03 - 11:45',
          'done': true,
        },
        {
          'title': 'Préparation en cours',
          'time': '15/03 - 14:20',
          'done': true,
        },
        {
          'title': 'En cours de livraison',
          'time': 'En attente',
          'done': false,
        },
        {
          'title': 'Livrée',
          'time': 'En attente',
          'done': false,
        },
      ]
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Commande ${orderDetails['orderId']}'),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informations de la commande
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Détails de la commande',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        const Divider(),
                        _buildDetailRow('Pharmacie', orderDetails['pharmacy'] as String),
                        _buildDetailRow('Date', orderDetails['date'] as String),
                        _buildDetailRow('Total', orderDetails['total'] as String),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Timeline de statut
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Suivi de commande',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...(orderDetails['status'] as List<Map<String, dynamic>>)
                            .asMap()
                            .entries
                            .map((entry) {
                          final isLast = entry.key == 
                              (orderDetails['status'] as List).length - 1;
                          return _buildTimelineItem(
                            entry.value['title'] as String,
                            entry.value['time'] as String,
                            entry.value['done'] as bool,
                            isLast,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String time, bool done, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Icon(
                  done ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: done ? Colors.green : Colors.grey,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: done ? Colors.green : Colors.grey.withOpacity(0.5),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: done ? Colors.black : Colors.grey,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      color: done ? Colors.green[700] : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
