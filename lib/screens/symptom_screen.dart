import 'package:flutter/material.dart';

class Symptom {
  final String name;
  final IconData icon;
  final String tip;
  bool selected;
  Symptom(this.name, this.icon, this.tip, {this.selected = false});
}

class SymptomScreen extends StatefulWidget {
  const SymptomScreen({super.key});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  final List<Symptom> _symptoms = [
    Symptom('Bukhar', Icons.thermostat,
        'Aaram karein, paani/ORS zyada piyein, halka bhojan lein.'),
    Symptom('Sardi/Zukam', Icons.ac_unit,
        'Bhaap lein, garam paani piyein, aaram karein.'),
    Symptom('Khansi', Icons.sick,
        'Garam paani/shahad-adrak ka seva karein, dhool se bachein.'),
    Symptom('Sir Dard', Icons.psychology_alt,
        'Andhere kamre mein aaram karein, paani piyein, screen time kam karein.'),
    Symptom('Gale mein Dard', Icons.record_voice_over,
        'Namak-paani se gargle karein, garam tarl padarth piyein.'),
    Symptom('Pet Dard', Icons.restaurant,
        'Halka bhojan lein, tala-bhuna avoid karein, paani piyein.'),
    Symptom('Kamzori/Thakan', Icons.battery_alert,
        'Poora aaram karein, poshtik bhojan aur paani lein.'),
    Symptom('Ulti/Jee Michlana', Icons.sick_outlined,
        'Thoda-thoda paani piyein, bhari bhojan avoid karein.'),
  ];

  List<Symptom> get _selected => _symptoms.where((s) => s.selected).toList();

  bool get _needsDoctor {
    // Simple heuristic: 4+ symptoms together, suggest seeing a doctor
    return _selected.length >= 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Symptom Checklist')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.amber.shade100,
            padding: const EdgeInsets.all(12),
            child: const Text(
              'Ye app diagnosis nahi karta — sirf general self-care tips deta hai. '
              'Agar lakshan zyada din rahein ya gambhir hon, doctor se zaroor milein.',
              style: TextStyle(fontSize: 12.5),
            ),
          ),
          Expanded(
            child: ListView(
              children: _symptoms.map((s) {
                return CheckboxListTile(
                  secondary: Icon(s.icon),
                  title: Text(s.name),
                  value: s.selected,
                  onChanged: (v) => setState(() => s.selected = v ?? false),
                );
              }).toList(),
            ),
          ),
          if (_selected.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _needsDoctor
                    ? Colors.red.shade50
                    : Colors.teal.shade50,
                border: const Border(top: BorderSide(color: Colors.black12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_needsDoctor)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        '⚠️ Itne saare lakshan saath mein hain — kripya doctor se milein.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                  const Text('Self-care tips:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ..._selected.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• ${s.name}: ${s.tip}'),
                      )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
