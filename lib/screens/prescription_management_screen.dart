import 'package:flutter/material.dart';
import 'package:pharmnet_mobile/screens/prescription_image_screen.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart'; // Ajout de l'import logging
import '../services/prescription_service.dart';
import '../services/auth_state.dart';
import '../models/prescription.dart';
import '../widgets/error_banner.dart';

class PrescriptionManagementScreen extends StatefulWidget {
  const PrescriptionManagementScreen({super.key});

  @override
  State<PrescriptionManagementScreen> createState() =>
      _PrescriptionManagementScreenState();
}

class _PrescriptionManagementScreenState
    extends State<PrescriptionManagementScreen> {
  final PrescriptionService _prescriptionService = PrescriptionService();
  final _logger = Logger('PrescriptionManagementScreen');
  bool _isLoading = true;
  String? _error;
  List<Prescription> _prescriptions = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _statusFilter = 'ALL'; // 'ALL', 'PENDING', 'COMPLETED'

  List<Prescription> get _filteredPrescriptions => _prescriptions
      .where((prescription) =>
          (_statusFilter == 'ALL' || prescription.statut == _statusFilter) &&
          (prescription.id.toString().contains(_searchQuery.toLowerCase())))
      .toList();

  @override
  void initState() {
    super.initState();
    print("Initializing PrescriptionManagementScreen"); // Ajoutez cette ligne
    // Initialiser le logging
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
    _loadPrescriptions();
  }

  Future<void> _loadPrescriptions() async {
    if (!mounted) return;

    try {
      // Get AuthState without using Provider.of directly
      final authState = context.read<AuthState>();

      // Check if user exists, if not redirect to login
      if (authState.user == null) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }

      final userId = authState.user!.id;
      final prescriptions = await _prescriptionService.getPrescriptions(userId);

      if (!mounted) return;

      setState(() {
        _prescriptions = prescriptions;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher une ordonnance...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Toutes'),
                  selected: _statusFilter == 'ALL',
                  onSelected: (bool selected) {
                    setState(() => _statusFilter = 'ALL');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('En attente'),
                  selected: _statusFilter == 'PENDING',
                  onSelected: (bool selected) {
                    setState(() => _statusFilter = 'PENDING');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Complétées'),
                  selected: _statusFilter == 'COMPLETED',
                  onSelected: (bool selected) {
                    setState(() => _statusFilter = 'COMPLETED');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard(Prescription prescription, String imageUrl) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrescriptionImageScreen(
            prescriptionId: prescription.id,
            patientId: context.read<AuthState>().user!.id,
          ),
        ),
      ),
      child: Card(
        elevation: 8,
        shadowColor: Colors.green.withOpacity(0.2),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Stack(
                children: [
                  Hero(
                    tag: 'prescription_${prescription.id}',
                    child: Image.network(
                      imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported,
                                  size: 50, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text('Image non disponible',
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: prescription.statut == 'PENDING'
                            ? Colors.orange.withOpacity(0.9)
                            : Colors.green.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            prescription.statut == 'PENDING'
                                ? Icons.pending
                                : Icons.check_circle,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            prescription.statut == 'PENDING'
                                ? 'En attente'
                                : 'Traitée',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ordonnance #${prescription.id.toString()}', // Assurez-vous de convertir en String
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 8),
                                Text(
                                  'Envoyée le ${prescription.dateEnvoi.toString().split(' ')[0]}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigation vers les détails
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('Détails'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune ordonnance trouvée',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez votre première ordonnance',
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/map'),
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Nouvelle ordonnance'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the Scaffold with a Builder to ensure proper context
    return Consumer<AuthState>(
      builder: (context, authState, _) {
        if (authState.user == null) {
          // Redirect to login if no user
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/login');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mes Ordonnances'),
            backgroundColor: Colors.green[700],
            elevation: 0,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green[50]!, Colors.white],
              ),
            ),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: ErrorBanner(message: _error!))
                    : _prescriptions.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: _loadPrescriptions,
                            child: CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: _buildSearchBar(),
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total: ${_filteredPrescriptions.length}',
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
                                            color: Colors.green[100],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            'En attente: ${_filteredPrescriptions.where((p) => p.statut == 'PENDING').length}',
                                            style: TextStyle(
                                              color: Colors.green[700],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final prescription =
                                            _filteredPrescriptions[index];
                                        final userId = authState.user!.id;
                                        final imageUrl = _prescriptionService
                                            .getPrescriptionImageUrl(
                                          userId,
                                          prescription.id,
                                        );
                                        return _buildPrescriptionCard(
                                            prescription, imageUrl);
                                      },
                                      childCount: _filteredPrescriptions.length,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, '/map'),
            backgroundColor: Colors.green[700],
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Nouvelle ordonnance'),
          ),
        );
      },
    );
  }
}
