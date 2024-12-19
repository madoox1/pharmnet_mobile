import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String _selectedFilter = 'Tout';

  final orderHistory = [
    {
      'id': 'CMD-2024-001',
      'date': '15/03/2024',
      'pharmacy': 'Pharmacie Centrale',
      'total': '250 DH',
      'status': 'En cours',
      'items': '3 médicaments'
    },
    {
      'id': 'CMD-2024-002',
      'date': '10/03/2024',
      'pharmacy': 'Pharmacie du Marché',
      'total': '180 DH',
      'status': 'Livrée',
      'items': '2 médicaments'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Commandes'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green[700],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Historique des commandes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Tout'),
                      _buildFilterChip('En cours'),
                      _buildFilterChip('Livrée'),
                      _buildFilterChip('Annulée'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistory[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/order_tracking',
                      arguments: order['id'],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order['id']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              _buildStatusChip(order['status']!),
                            ],
                          ),
                          const Divider(),
                          _buildOrderDetail('Pharmacie', order['pharmacy']!),
                          _buildOrderDetail('Date', order['date']!),
                          _buildOrderDetail('Total', order['total']!),
                          _buildOrderDetail('Articles', order['items']!),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: _selectedFilter == label,
        onSelected: (bool selected) {
          setState(() => _selectedFilter = selected ? label : 'Tout');
        },
        selectedColor: Colors.green[100],
        checkmarkColor: Colors.green[700],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color? chipColor;
    switch (status) {
      case 'En cours':
        chipColor = Colors.orange[100];
        break;
      case 'Livrée':
        chipColor = Colors.green[100];
        break;
      case 'Annulée':
        chipColor = Colors.red[100];
        break;
    }
    return Chip(
      label: Text(status),
      backgroundColor: chipColor,
    );
  }

  Widget _buildOrderDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
