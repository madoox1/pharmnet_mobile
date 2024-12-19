import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderStatus = [
      'Commande reçue',
      'En cours de traitement',
      'En cours de livraison',
      'Livrée',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi de commande'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'État de la commande',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 20),
              ...orderStatus.map((status) => Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(status),
                      leading: Icon(Icons.check_circle_outline, color: Colors.green[600]),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
