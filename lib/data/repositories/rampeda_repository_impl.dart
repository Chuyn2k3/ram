import '../../core/enums/connection_status.dart';
import '../../domain/repositories/rampeda_repository.dart';
import '../datasources/rampeda_service.dart';

class RampedaRepositoryImpl implements RampedaRepository {
  final RampedaService service;

  RampedaRepositoryImpl(this.service);

  @override
  Future<ConnectionStatus> ping() async {
    try {
      final ok = await service.ping();
      return ok ? ConnectionStatus.connected : ConnectionStatus.disconnected;
    } catch (_) {
      return ConnectionStatus.disconnected;
    }
  }

  @override
  Future<String> getLogs() => service.getLogs();

  @override
  Future<void> eraseSd() => service.eraseSd();

  @override
  Future<void> coupeWifi() => service.coupeWifi();

  @override
  Future<void> adjustTime(DateTime dateTime) => service.adjustTime(dateTime);
}
