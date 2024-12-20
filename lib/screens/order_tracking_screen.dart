import 'package:flutter/material.dart';
import '../theme/text_styles.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  Widget _buildStatusStep(
      String status, int index, bool isActive, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green[700]
                  : isActive
                      ? Colors.green[100]
                      : Colors.grey[200],
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted
                    ? Colors.green[700]!
                    : isActive
                        ? Colors.green[700]!
                        : Colors.grey[400]!,
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.green[700] : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          if (index < 3) // Ne pas afficher la ligne pour la dernière étape
            Expanded(
              child: Container(
                height: 2,
                color: isCompleted ? Colors.green[700] : Colors.grey[300],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Commande #12345', style: AppTextStyles.headingText),
              Chip(
                label: const Text('En cours'),
                backgroundColor: Colors.orange[100],
                labelStyle: TextStyle(color: Colors.orange[800]),
              ),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Adresse de livraison'),
            subtitle: const Text('123 Rue Example, Ville'),
            contentPadding: EdgeInsets.zero,
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Temps estimé'),
            subtitle: const Text('30-45 minutes'),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderStatus = [
      'Commande reçue',
      'En préparation',
      'En livraison',
      'Livrée',
    ];

    const currentStep = 1; // À remplacer par la vraie étape

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderDetails(),
                const SizedBox(height: 24),
                Text(
                  'Progression',
                  style: AppTextStyles.headingText,
                ),
                const SizedBox(height: 24),
                // Étapes de progression
                ...orderStatus.asMap().entries.map((entry) {
                  final index = entry.key;
                  final status = entry.value;
                  return Column(
                    children: [
                      _buildStatusStep(
                        status,
                        index,
                        index == currentStep,
                        index < currentStep,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 56),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    status,
                                    style: AppTextStyles.bodyText.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: index <= currentStep
                                          ? Colors.black87
                                          : Colors.grey[600],
                                    ),
                                  ),
                                  if (index <= currentStep)
                                    Text(
                                      '12:30',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Action pour contacter le livreur
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('Contacter le livreur'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
}
