import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/pharmacy_service.dart';
import '../models/pharmacy.dart';

class PharmacyListScreen extends StatefulWidget {
  const PharmacyListScreen({super.key});

  @override
  State<PharmacyListScreen> createState() => _PharmacyListScreenState();
}

class _PharmacyListScreenState extends State<PharmacyListScreen> {
  final PharmacyService _pharmacyService = PharmacyService();
  final MapController _mapController = MapController();
  bool _isLoading = true;
  String? _error;
  List<Pharmacy> _pharmacies = [];
  static const LatLng casablancaCenter = LatLng(33.5731104, -7.5898434);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Pharmacy> get _filteredPharmacies => _pharmacies
      .where((pharmacy) =>
          pharmacy.nom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pharmacy.adresse.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  @override
  void initState() {
    super.initState();
    _loadPharmacies();
  }

  Future<void> _loadPharmacies() async {
    try {
      final pharmacies = await _pharmacyService.getPharmacies();
      setState(() {
        _pharmacies = pharmacies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _centerOnPharmacy(Pharmacy pharmacy) {
    _mapController.move(
      LatLng(pharmacy.latitude, pharmacy.longitude),
      15,
    );
  }

  Widget _buildPharmacyListItem(Pharmacy pharmacy) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _centerOnPharmacy(pharmacy),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: pharmacy.status == 'Active'
                          ? Colors.green[50]
                          : Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.local_pharmacy,
                      color: pharmacy.status == 'Active'
                          ? Colors.green[700]
                          : Colors.red[700],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pharmacy.nom,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pharmacy.adresse,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: pharmacy.status == 'Active'
                          ? Colors.green[100]
                          : Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      pharmacy.status,
                      style: TextStyle(
                        color: pharmacy.status == 'Active'
                            ? Colors.green[800]
                            : Colors.red[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/create_prescription/${pharmacy.id}',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Sélectionner'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacies'),
        backgroundColor: Colors.green[700],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Rechercher une pharmacie...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                      ),
                    ),
                    // Carte
                    SizedBox(
                      height: 300,
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: casablancaCenter,
                          initialZoom: 12,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          MarkerLayer(
                            markers: _pharmacies.map((pharmacy) {
                              return Marker(
                                point: LatLng(
                                    pharmacy.latitude, pharmacy.longitude),
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.location_on,
                                  color: pharmacy.status == 'Active'
                                      ? Colors.green[700]
                                      : Colors.red[700],
                                  size: 40,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    // Liste des pharmacies
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, -3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pharmacies (${_filteredPharmacies.length})',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.green.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      'Actives: ${_filteredPharmacies.where((p) => p.status == 'Active').length}',
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: ListView.builder(
                                  key: ValueKey(_searchQuery),
                                  itemCount: _filteredPharmacies.length,
                                  itemBuilder: (context, index) =>
                                      _buildPharmacyListItem(
                                          _filteredPharmacies[index]),
                                ),
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
