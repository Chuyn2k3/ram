import 'dart:async';

import 'rampeda_service.dart';

class FakeRampedaService implements RampedaService {
  bool _isOnline = true;
  String _logs = '';

  @override
  Future<bool> ping() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _isOnline;
  }

  @override
  Future<String> getLogs() async {
    if (!_isOnline) throw Exception('Device offline');
    await Future.delayed(const Duration(milliseconds: 350));
    if (_logs.isEmpty) {
      _logs = '''
[2025-11-24 10:00:01] RAMPEDA démarré
[2025-11-24 10:01:10] Porte ouverte
[2025-11-24 10:02:35] Porte fermée
[2025-11-24 10:05:12] Anomalie détectée - capteur 3
[2025-11-24 10:06:45] Reset automatique terminé
''';
    }
    return _logs;
  }

  @override
  Future<void> eraseSd() async {
    if (!_isOnline) throw Exception('Device offline');
    await Future.delayed(const Duration(milliseconds: 300));
    _logs = '';
    _simulateRestart();
  }

  @override
  Future<void> coupeWifi() async {
    if (!_isOnline) throw Exception('Device offline');
    await Future.delayed(const Duration(milliseconds: 300));
    _simulateRestart();
  }

  @override
  Future<void> adjustTime(DateTime dateTime) async {
    if (!_isOnline) throw Exception('Device offline');
    await Future.delayed(const Duration(milliseconds: 300));

    final dd = dateTime.day.toString().padLeft(2, '0');
    final mm = dateTime.month.toString().padLeft(2, '0');
    final yyyy = dateTime.year.toString().padLeft(4, '0');
    final hh = dateTime.hour.toString().padLeft(2, '0');
    final mi = dateTime.minute.toString().padLeft(2, '0');
    final ss = dateTime.second.toString().padLeft(2, '0');

    final cmd = '**$dd$mm$yyyy$hh$mi$ss';
    _logs += '[${DateTime.now()}] Adjust time command: $cmd\n';

    _simulateRestart();
  }

  void _simulateRestart() {
    _isOnline = false;
    Timer(const Duration(seconds: 3), () {
      _isOnline = true;
      _logs += '[${DateTime.now()}] Device restarted\n';
    });
  }
}
