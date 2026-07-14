import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/request_form_screen.dart';

void main() {
  runApp(const LeaveRequestApp());
}

class LeaveRequestApp extends StatelessWidget {
  const LeaveRequestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leave Request',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/request': (context) => const RequestFormScreen(),
      },
    );
  }
}
