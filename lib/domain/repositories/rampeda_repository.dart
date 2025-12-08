import '../../core/enums/connection_status.dart';
import '../entities/rampeda_config.dart';

abstract class RampedaRepository {
  Future<ConnectionStatus> ping();
  Future<String> getLogs();
  Future<void> eraseSd();
  Future<void> coupeWifi();
  Future<void> adjustTime(DateTime dateTime);
  Future<void> updateConfig(int distance, int redMs, int greenMs);
  Future<RampedaConfig?> getConfig();
}
