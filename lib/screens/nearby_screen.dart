import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyScreen extends StatelessWidget {
  const NearbyScreen({super.key});

  Future<void> _openMaps(BuildContext context, String query) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maps nahi khul paya')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Nearby Doctor', Icons.medical_services, 'doctor near me'),
      ('Nearby Hospital', Icons.local_hospital, 'hospital near me'),
      ('Nearby Pharmacy/Medical Store', Icons.local_pharmacy,
          'pharmacy near me'),
      ('Nearby Clinic', Icons.health_and_safety, 'clinic near me'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Help')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final (title, icon, query) = items[i];
          return Card(
            child: ListTile(
              leading: Icon(icon, color: Colors.teal),
              title: Text(title),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _openMaps(context, query),
            ),
          );
        },
      ),
    );
  }
}
