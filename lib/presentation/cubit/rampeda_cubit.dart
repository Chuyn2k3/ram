import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/enums/connection_status.dart';
import '../../domain/entities/rampeda_config.dart';
import '../../domain/repositories/rampeda_repository.dart';
import 'rampeda_state.dart';

class RampedaCubit extends Cubit<RampedaState> {
  final RampedaRepository repository;
  Timer? _pingTimer;

  RampedaCubit(this.repository) : super(const RampedaState());

  void startPolling() {
    _pingTimer?.cancel();
    _pingOnce();
    _pingTimer = Timer.periodic(const Duration(seconds: 5), (_) => _pingOnce());
  }

  void stopPolling() {
    _pingTimer?.cancel();
  }

  Future<void> _pingOnce() async {
    final status = await repository.ping();
    emit(state.copyWith(connectionStatus: status));
  }

  bool get isConnected => state.connectionStatus == ConnectionStatus.connected;

  Future<void> loadLogs() async {
    if (!isConnected || state.isBusy) return;
    emit(state.copyWith(isBusy: true, message: null));
    try {
      final logs = await repository.getLogs();
      emit(state.copyWith(isBusy: false, logs: logs));
    } catch (e) {
      emit(state.copyWith(
        isBusy: false,
        message: 'Erreur de lecture des logs: $e',
      ));
    }
  }

  void clearScreen() {
    emit(state.copyWith(logs: ''));
  }

  Future<void> formatSdAndWaitRestart() async {
    if (!isConnected || state.isBusy) return;
    emit(state.copyWith(isBusy: true, message: null));
    try {
      await repository.eraseSd();
    } catch (e) {
      emit(state.copyWith(message: 'Erreur format SD: $e'));
    }
    await _waitForReconnect();
    emit(state.copyWith(isBusy: false));
  }

  Future<void> coupeWifiAndWaitRestart() async {
    if (!isConnected || state.isBusy) return;
    emit(state.copyWith(isBusy: true, message: null));
    try {
      await repository.coupeWifi();
    } catch (e) {
      emit(state.copyWith(message: 'Erreur fermeture: $e'));
    }
    await _waitForReconnect();
    emit(state.copyWith(isBusy: false));
  }

  Future<void> adjustTimeAndWaitRestart(DateTime dateTime) async {
    if (!isConnected || state.isBusy) return;
    emit(state.copyWith(isBusy: true, message: null));
    try {
      await repository.adjustTime(dateTime);
    } catch (e) {
      emit(state.copyWith(message: 'Erreur mise à jour date: $e'));
    }
    await _waitForReconnect();
    emit(state.copyWith(isBusy: false));
  }

  Future<void> _waitForReconnect({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final start = DateTime.now();
    emit(state.copyWith(connectionStatus: ConnectionStatus.disconnected));
    while (DateTime.now().difference(start) < timeout) {
      await Future.delayed(const Duration(seconds: 2));
      final status = await repository.ping();
      if (status == ConnectionStatus.connected) {
        emit(state.copyWith(connectionStatus: status));
        return;
      }
    }
  }

  Future<RampedaConfig> loadConfig() async {
    try {
      final cfg = await repository.getConfig();

      if (cfg == null) {
        // Lỗi → mặc định 0, có message báo lỗi
        emit(state.copyWith(
          message:
              'Erreur de lecture des paramètres (valeurs par défaut 0 appliquées).',
        ));
        return RampedaConfig.zero;
      }

      emit(state.copyWith(
        message: 'Paramètres chargés avec succès.',
      ));

      return cfg;
    } catch (e) {
      emit(state.copyWith(
        message: 'Erreur de lecture des paramètres: $e',
      ));
      return RampedaConfig.zero;
    }
  }

  Future<void> updateConfig({
    required int distance,
    required int redMs,
    required int greenMs,
  }) async {
    if (!isConnected || state.isBusy) return;

    emit(state.copyWith(isBusy: true, message: null));
    try {
      await repository.updateConfig(distance, redMs, greenMs);
      emit(state.copyWith(
        isBusy: false,
        message: 'Configuration mise à jour avec succès',
      ));
    } catch (e) {
      emit(state.copyWith(
        isBusy: false,
        message: 'Erreur mise à jour config: $e',
      ));
    }
  }
}
