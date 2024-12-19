import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/home_dashboard.dart';
import 'screens/map_screen.dart';
import 'screens/prescription_management_screen.dart';
import 'screens/order_tracking_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/create_prescription_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PharmaNet',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Colors.green[800]), // was headline1
          titleLarge: TextStyle(
              fontSize: 20.0, color: Colors.green[700]), // was headline6
          bodyLarge:
              TextStyle(fontSize: 14.0, fontFamily: 'Hind'), // was bodyText1
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/profile_edit': (context) => const ProfileEditScreen(),
        '/home_dashboard': (context) => const HomeDashboard(),
        '/map': (context) => const MapScreen(),
        '/prescription_management': (context) =>
            const PrescriptionManagementScreen(),
        '/order_tracking': (context) => const OrderTrackingScreen(),
        '/order_history': (context) => const OrderHistoryScreen(),
        '/create_prescription': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return CreatePrescriptionScreen(pharmacyId: args['pharmacyId'] as int);
        },
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('Welcome to PharmaNet'),
      ),
    );
  }
}
