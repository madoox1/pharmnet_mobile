class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8080/pharmacy-system-backend-1.0-SNAPSHOT/api';
  
  // API Endpoints
  static const String login = '/login';
  static const String pharmacies = '/pharmacies';
  static String patientPrescriptions(int patientId) => '/patients/$patientId/ordonnances';
  static String patientOrders(int patientId) => '/patients/$patientId/commandes';
}

class AppConstants {
  static const defaultErrorMessage = 'Une erreur est survenue';
  static const sessionExpiredMessage = 'Votre session a expiré';
  static const networkErrorMessage = 'Erreur de connexion';
}
