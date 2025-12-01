import 'package:equatable/equatable.dart';

import '../../core/enums/connection_status.dart';

class RampedaState extends Equatable {
  final ConnectionStatus connectionStatus;
  final bool isBusy;
  final String logs;
  final String? message; // message ngắn để show SnackBar / dialog

  const RampedaState({
    this.connectionStatus = ConnectionStatus.unknown,
    this.isBusy = false,
    this.logs = '',
    this.message,
  });

  RampedaState copyWith({
    ConnectionStatus? connectionStatus,
    bool? isBusy,
    String? logs,
    String? message,
  }) {
    return RampedaState(
      connectionStatus: connectionStatus ?? this.connectionStatus,
      isBusy: isBusy ?? this.isBusy,
      logs: logs ?? this.logs,
      message: message,
    );
  }

  @override
  List<Object?> get props => [connectionStatus, isBusy, logs, message];
}
