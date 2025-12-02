import '../../core/enums/connection_status.dart';

abstract class RampedaRepository {
  Future<ConnectionStatus> ping();
  Future<String> getLogs();
  Future<void> eraseSd();
  Future<void> coupeWifi();
  Future<void> adjustTime(DateTime dateTime);
  Future<void> updateConfig(int distance, int redMs, int greenMs);
}
