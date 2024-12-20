import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/profile_edit_screen.dart';
import '../screens/home_dashboard.dart';
import '../screens/prescription_management_screen.dart';
import '../screens/create_prescription_screen.dart';
import '../screens/order_tracking_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/pharmacy_list_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Remove leading slash and split path
    final path = settings.name?.replaceFirst(RegExp(r'^/'), '') ?? '';

    // Handle empty path as login
    if (path.isEmpty) {
      return _buildRoute(const LoginScreen());
    }

    // Split path for handling parameters
    final segments = path.split('/');
    final firstSegment = segments.first;

    switch (firstSegment) {
      case 'login':
        return _buildRoute(const LoginScreen());
      case 'home_dashboard':
        return _buildRoute(const HomeDashboard());
      case 'profile_edit':
        return _buildRoute(const ProfileEditScreen());
      case 'prescription_management':
        return _buildRoute(const PrescriptionManagementScreen());
      case 'order_tracking':
        return _buildRoute(const OrderTrackingScreen());
      case 'order_history':
        return _buildRoute(const OrderHistoryScreen());
      case 'pharmacies':
        return _buildRoute(const PharmacyListScreen());
      case 'create_prescription':
        if (segments.length == 2) {
          final pharmacyId = int.tryParse(segments[1]);
          if (pharmacyId != null) {
            return _buildRoute(
                CreatePrescriptionScreen(pharmacyId: pharmacyId));
          }
        }
        return _buildErrorRoute('Invalid prescription creation route');
      default:
        return _buildErrorRoute('Route not found: ${settings.name}');
    }
  }

  static MaterialPageRoute _buildRoute(Widget screen) {
    return MaterialPageRoute(builder: (_) => screen);
  }

  static MaterialPageRoute _buildErrorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text(message, style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
