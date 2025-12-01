abstract class RampedaService {
  Future<bool> ping();
  Future<String> getLogs();
  Future<void> eraseSd();
  Future<void> coupeWifi();
  Future<void> adjustTime(DateTime dateTime);
}
