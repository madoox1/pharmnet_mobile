import 'package:flutter/material.dart';
import 'package:pharmnet_mobile/screens/map_screen.dart';
import '../services/prescription_service.dart';
import '../widgets/loading_overlay.dart';

class PrescriptionManagementScreen extends StatefulWidget {
  const PrescriptionManagementScreen({super.key});

  @override
  State<PrescriptionManagementScreen> createState() => _PrescriptionManagementScreenState();
}

class _PrescriptionManagementScreenState extends State<PrescriptionManagementScreen> {
  final PrescriptionService _prescriptionService = PrescriptionService();
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _prescriptions = [];

  @override
  void initState() {
    super.initState();
    _loadPrescriptions();
  }

  Future<void> _loadPrescriptions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Remplacer 1 par l'ID du patient connecté
      final prescriptions = await _prescriptionService.getPatientPrescriptions(1);
      setState(() {
        _prescriptions = prescriptions;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Ordonnances'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPrescriptions,
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green[50]!, Colors.white],
            ),
          ),
          child: _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: _loadPrescriptions,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _prescriptions.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final prescription = _prescriptions[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.description,
                          color: Colors.green[600],
                        ),
                        title: Text('Ordonnance #${prescription['id']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${_formatDate(prescription['dateEnvoi'] as int)}'),
                            Text('Statut: ${prescription['statut']}'),
                          ],
                        ),
                        trailing: Icon(Icons.chevron_right, color: Colors.green[300]),
                        onTap: () {
                          // TODO: Afficher les détails de l'ordonnance
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapScreen(), // Rediriger vers la carte des pharmacies
            ),
          );
        },
        backgroundColor: Colors.green[700],
        tooltip: 'Choisir une pharmacie',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
