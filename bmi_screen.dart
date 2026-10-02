import 'package:flutter/material.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _pulseCtrl = TextEditingController();

  double? _bmi;
  String _bmiCategory = '';
  String _pulseZone = '';

  void _calcBmi() {
    final h = double.tryParse(_heightCtrl.text.trim());
    final w = double.tryParse(_weightCtrl.text.trim());
    if (h == null || w == null || h <= 0 || w <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Height (cm) aur Weight (kg) sahi daalein')),
      );
      return;
    }
    final heightM = h / 100;
    final bmi = w / (heightM * heightM);
    String category;
    if (bmi < 18.5) {
      category = 'Underweight';
    } else if (bmi < 25) {
      category = 'Normal';
    } else if (bmi < 30) {
      category = 'Overweight';
    } else {
      category = 'Obese';
    }
    setState(() {
      _bmi = bmi;
      _bmiCategory = category;
    });
  }

  void _calcPulse() {
    final p = int.tryParse(_pulseCtrl.text.trim());
    if (p == null || p <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pulse (beats per minute) sahi daalein')),
      );
      return;
    }
    String zone;
    if (p < 60) {
      zone = 'Normal se kam (Bradycardia ho sakta hai)';
    } else if (p <= 100) {
      zone = 'Normal (Resting Heart Rate)';
    } else {
      zone = 'Normal se zyada (Tachycardia ho sakta hai)';
    }
    setState(() => _pulseZone = zone);
  }

  Color _bmiColor() {
    switch (_bmiCategory) {
      case 'Normal':
        return Colors.green;
      case 'Underweight':
      case 'Overweight':
        return Colors.orange;
      case 'Obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI & Pulse Calculator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('BMI Calculator',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          TextField(
            controller: _heightCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _weightCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _calcBmi, child: const Text('Calculate BMI')),
          if (_bmi != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Card(
                color: _bmiColor().withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'BMI: ${_bmi!.toStringAsFixed(1)} — $_bmiCategory',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _bmiColor(),
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          const Divider(height: 40),
          const Text('Pulse Rate Checker',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          const Text(
            '60 second tak apni pulse ginein (kalai par 2 ungli rakhkar) aur yahan daalein.',
            style: TextStyle(fontSize: 12.5, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _pulseCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Pulse (beats per minute)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _calcPulse, child: const Text('Check Pulse Zone')),
          if (_pulseZone.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_pulseZone,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
