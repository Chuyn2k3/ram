import 'package:flutter/material.dart';

enum RampedaFeature {
  dateTime,
  clear,
  formatSd,
  export,
  readSd,
  restart,
  // <--- NÚT MỚI
  config,
  closeApp,
}

extension RampedaFeatureX on RampedaFeature {
  String get label {
    switch (this) {
      case RampedaFeature.dateTime:
        return 'Date/Heure';
      case RampedaFeature.clear:
        return 'Effacer';
      case RampedaFeature.formatSd:
        return 'Format SD';
      case RampedaFeature.export:
        return 'Exporter';
      case RampedaFeature.readSd:
        return 'Lire SD';
      case RampedaFeature.restart:
        return 'Redémarrer';
      case RampedaFeature.closeApp:
        return 'Fermer app'; // <---
      case RampedaFeature.config:
        return 'Config';
    }
  }

  IconData get icon {
    switch (this) {
      case RampedaFeature.dateTime:
        return Icons.schedule_rounded;
      case RampedaFeature.clear:
        return Icons.delete_sweep_rounded;
      case RampedaFeature.formatSd:
        return Icons.sd_card_rounded;
      case RampedaFeature.export:
        return Icons.ios_share_rounded;
      case RampedaFeature.readSd:
        return Icons.folder_open_rounded;
      case RampedaFeature.restart:
        return Icons.power_settings_new_rounded;
      case RampedaFeature.closeApp:
        return Icons.exit_to_app_rounded; // <---
      case RampedaFeature.config:
        return Icons.tune_rounded;
    }
  }

  List<Color> get gradient {
    switch (this) {
      case RampedaFeature.dateTime:
        return const [Color(0xFF8B5CF6), Color(0xFF6366F1)];
      case RampedaFeature.clear:
        return const [Color(0xFF64748B), Color(0xFF475569)];
      case RampedaFeature.formatSd:
        return const [Color(0xFFEF4444), Color(0xFFDC2626)];
      case RampedaFeature.export:
        return const [Color(0xFF14B8A6), Color(0xFF0D9488)];
      case RampedaFeature.readSd:
        return const [Color(0xFF06B6D4), Color(0xFF0891B2)];
      case RampedaFeature.restart:
        return const [Color(0xFFF97316), Color(0xFFEA580C)];
      case RampedaFeature.closeApp:
        return const [Color(0xFF111827), Color(0xFF4B5563)]; // <---
      case RampedaFeature.config:
        return const [Color(0xFF22C55E), Color(0xFF16A34A)];
    }
  }
}
