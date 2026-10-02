import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _notifications =
    FlutterLocalNotificationsPlugin();

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool _initialized = false;
  int _waterIntervalHours = 2;
  TimeOfDay _medicineTime = const TimeOfDay(hour: 9, minute: 0);
  bool _waterOn = false;
  bool _medicineOn = false;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _notifications.initialize(initSettings);
    setState(() => _initialized = true);
  }

  Future<void> _toggleWaterReminder(bool value) async {
    setState(() => _waterOn = value);
    if (value) {
      await _notifications.periodicallyShow(
        1,
        'Paani peene ka time! 💧',
        'Hydrated rehna zaroori hai, ek glass paani piyein.',
        RepeatInterval.hourly, // base interval; interval hours shown as info
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'water_channel',
            'Water Reminders',
            channelDescription: 'Reminds you to drink water',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    } else {
      await _notifications.cancel(1);
    }
  }

  Future<void> _toggleMedicineReminder(bool value) async {
    setState(() => _medicineOn = value);
    if (value) {
      await _scheduleMedicineNotification();
    } else {
      await _notifications.cancel(2);
    }
  }

  Future<void> _scheduleMedicineNotification() async {
    // Simple daily reminder using periodicallyShow as a lightweight approach.
    await _notifications.periodicallyShow(
      2,
      'Dawai lene ka time! 💊',
      'Apni dawai lena na bhoolein.',
      RepeatInterval.daily,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminders',
          channelDescription: 'Reminds you to take medicine',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> _pickMedicineTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _medicineTime,
    );
    if (picked != null) {
      setState(() => _medicineTime = picked);
      if (_medicineOn) await _scheduleMedicineNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Water & Medicine Reminder')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('💧 Water Reminder',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Switch(
                        value: _waterOn,
                        onChanged: _initialized ? _toggleWaterReminder : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Har $_waterIntervalHours ghante mein reminder aayega'),
                  Slider(
                    value: _waterIntervalHours.toDouble(),
                    min: 1,
                    max: 4,
                    divisions: 3,
                    label: '$_waterIntervalHours hrs',
                    onChanged: (v) =>
                        setState(() => _waterIntervalHours = v.round()),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('💊 Medicine Reminder',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Switch(
                        value: _medicineOn,
                        onChanged:
                            _initialized ? _toggleMedicineReminder : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Time: '),
                      Text(_medicineTime.format(context),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      TextButton(
                        onPressed: _pickMedicineTime,
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Note: Notification reliably kaam karein, iske liye phone ki battery '
            'optimization settings mein is app ko "unrestricted" karna padega.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
