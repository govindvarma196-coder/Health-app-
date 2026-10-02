import 'package:flutter/material.dart';
import 'screens/temperature_screen.dart';
import 'screens/symptom_screen.dart';
import 'screens/bmi_screen.dart';
import 'screens/reminder_screen.dart';
import 'screens/nearby_screen.dart';

void main() {
  runApp(const HealthCheckApp());
}

class HealthCheckApp extends StatelessWidget {
  const HealthCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Check',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const HomeNav(),
    );
  }
}

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int _index = 0;

  final List<Widget> _screens = const [
    TemperatureScreen(),
    SymptomScreen(),
    BmiScreen(),
    ReminderScreen(),
    NearbyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.thermostat), label: 'Fever'),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Symptoms'),
          NavigationDestination(icon: Icon(Icons.monitor_weight), label: 'BMI'),
          NavigationDestination(icon: Icon(Icons.alarm), label: 'Reminder'),
          NavigationDestination(icon: Icon(Icons.local_hospital), label: 'Nearby'),
        ],
      ),
    );
  }
}
