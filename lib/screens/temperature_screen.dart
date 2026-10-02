import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TempEntry {
  final double value;
  final DateTime time;
  TempEntry(this.value, this.time);

  Map<String, dynamic> toJson() => {
        'value': value,
        'time': time.toIso8601String(),
      };

  factory TempEntry.fromJson(Map<String, dynamic> json) =>
      TempEntry(json['value'], DateTime.parse(json['time']));
}

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  final _controller = TextEditingController();
  List<TempEntry> _entries = [];
  static const _key = 'temp_entries';

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    setState(() {
      _entries = raw
          .map((e) => TempEntry.fromJson(jsonDecode(e)))
          .toList()
        ..sort((a, b) => b.time.compareTo(a.time));
    });
  }

  Future<void> _addEntry() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final value = double.tryParse(text);
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sahi number daalein (jaise 98.6)')),
      );
      return;
    }
    final entry = TempEntry(value, DateTime.now());
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    raw.add(jsonEncode(entry.toJson()));
    await prefs.setStringList(_key, raw);
    _controller.clear();
    _loadEntries();
  }

  Future<void> _clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    _loadEntries();
  }

  String _feverStatus(double f) {
    if (f < 97.0) return 'Normal se kam';
    if (f <= 99.5) return 'Normal';
    if (f <= 102.0) return 'Halka bukhar';
    return 'Tez bukhar — doctor se sampark karein';
  }

  Color _statusColor(double f) {
    if (f <= 99.5) return Colors.green;
    if (f <= 102.0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fever Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _entries.isEmpty ? null : _clearAll,
            tooltip: 'Sab delete karein',
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Temperature (°F)',
                      hintText: 'jaise 99.2',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _addEntry,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          if (_entries.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _feverStatus(_entries.first.value),
                  style: TextStyle(
                    color: _statusColor(_entries.first.value),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          const Divider(height: 24),
          Expanded(
            child: _entries.isEmpty
                ? const Center(child: Text('Abhi koi reading nahi hai'))
                : ListView.builder(
                    itemCount: _entries.length,
                    itemBuilder: (context, i) {
                      final e = _entries[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _statusColor(e.value),
                          child: Text(
                            e.value.toStringAsFixed(1),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                          ),
                        ),
                        title: Text('${e.value}°F — ${_feverStatus(e.value)}'),
                        subtitle: Text(
                            DateFormat('dd MMM, hh:mm a').format(e.time)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
