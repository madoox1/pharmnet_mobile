import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_state.dart';
import '../services/user_service.dart'; // Changement ici
import '../models/user.dart';
import '../theme/text_styles.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService(); // Changement ici
  bool _isLoading = false;
  bool _showChangePassword = false;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String? _formError;

  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _emailController;
  late TextEditingController _adresseController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthState>().user;
    if (user == null) {
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    }

    _nomController = TextEditingController(text: user.nom);
    _prenomController = TextEditingController(text: user.prenom);
    _emailController = TextEditingController(text: user.email);
    _adresseController = TextEditingController(text: user.adresse);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _adresseController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    final user = context.read<AuthState>().user!;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32), // Ajusté le padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green[700]!, Colors.green[500]!],
        ),
      ),
      child: SafeArea(
        // Ajouté SafeArea
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ajouté cette ligne
          children: [
            CircleAvatar(
              radius: 40, // Réduit la taille
              backgroundColor: Colors.white,
              child: Text(
                '${user.prenom[0]}${user.nom[0]}',
                style: TextStyle(
                  fontSize: 28, // Réduit la taille de la police
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ),
            const SizedBox(height: 12), // Réduit l'espacement
            Text(
              '${user.prenom} ${user.nom}',
              style: AppTextStyles.headingText.copyWith(
                color: Colors.white,
                fontSize: 20, // Réduit la taille de la police
              ),
            ),
            const SizedBox(height: 4), // Réduit l'espacement
            Text(
              user.email,
              style: AppTextStyles.emailText.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14, // Réduit la taille de la police
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -3),
            blurRadius: 10,
          )
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_formError != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _formError!,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              ),
            const Text(
              'Informations personnelles',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Nom',
                    _nomController,
                    icon: Icons.person,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Champ requis' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'Prénom',
                    _prenomController,
                    icon: Icons.person_outline,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Champ requis' : null,
                  ),
                ),
              ],
            ),
            _buildTextField(
              'Email',
              _emailController,
              icon: Icons.email,
              readOnly: true,
              helperText: 'L\'email ne peut pas être modifié',
            ),
            _buildTextField(
              'Adresse',
              _adresseController,
              icon: Icons.location_on,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Champ requis' : null,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text('Changer le mot de passe'),
              leading: const Icon(Icons.security),
              onExpansionChanged: (expanded) {
                setState(() => _showChangePassword = expanded);
              },
              children: [
                _buildTextField(
                  'Ancien mot de passe',
                  _oldPasswordController,
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                _buildTextField(
                  'Nouveau mot de passe',
                  _newPasswordController,
                  icon: Icons.lock,
                  isPassword: true,
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.save),
                          SizedBox(width: 12),
                          Text(
                            'Enregistrer les modifications',
                            style: TextStyle(
                              fontSize: 16,
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
    );
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authState = context.read<AuthState>();
      final currentUser = authState.user;

      if (currentUser == null) {
        throw Exception('Non connecté');
      }

      final updatedUser = User(
        id: currentUser.id,
        nom: _nomController.text,
        prenom: _prenomController.text,
        email: _emailController.text,
        adresse: _adresseController.text,
        password: currentUser.password,
        role: 'Patient',
      );

      final result = await _userService.updateProfile(
        currentUser.id,
        updatedUser,
      );

      if (!mounted) return;

      authState.setUser(result);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil mis à jour avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    IconData? icon,
    String? helperText,
    String? Function(String?)? validator,
    bool isPassword = false,
    int? maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        obscureText: isPassword,
        maxLines: maxLines,
        style: AppTextStyles.baseStyle.copyWith(
          fontSize: 16,
          color: readOnly ? Colors.grey[600] : Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          helperStyle: AppTextStyles.baseStyle.copyWith(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: readOnly ? Colors.grey[50] : Colors.white,
          labelStyle: AppTextStyles.baseStyle.copyWith(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthState>(
        builder: (context, authState, _) {
          if (authState.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: Colors.green[700],
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeader(),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildForm(),
              ),
            ],
          );
        },
      ),
    );
  }
}
