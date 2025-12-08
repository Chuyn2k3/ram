import 'package:flutter/material.dart';

enum RampedaConfigField {
  distance,
  redMs,
  greenMs,
}

extension RampedaConfigFieldX on RampedaConfigField {
  // Label hiển thị
  String get label {
    switch (this) {
      case RampedaConfigField.distance:
        return 'Distance de détection (mm)';
      case RampedaConfigField.redMs:
        return 'Durée laser rouge (ms)';
      case RampedaConfigField.greenMs:
        return 'Durée laser verte (ms)';
    }
  }

  // Đơn vị hiển thị bên cạnh TextField
  String get unit {
    switch (this) {
      case RampedaConfigField.distance:
        return 'mm';
      case RampedaConfigField.redMs:
      case RampedaConfigField.greenMs:
        return 'ms';
    }
  }

  // Hint trong TextField
  String get hint {
    switch (this) {
      case RampedaConfigField.distance:
        return '100–700';
      case RampedaConfigField.redMs:
      case RampedaConfigField.greenMs:
        return '1000–7000';
    }
  }

  // Màu cho từng nhóm (dùng luôn cho SliderTheme & TextField border)
  // Màu cho từng nhóm
  Color get color {
    switch (this) {
      case RampedaConfigField.distance:
        return const Color(0xFF3B82F6); // xanh dương
      case RampedaConfigField.redMs:
        return const Color(0xFFEF4444); // đỏ
      case RampedaConfigField.greenMs:
        return const Color(0xFF22C55E); // xanh lá
    }
  }

  int get min {
    switch (this) {
      case RampedaConfigField.distance:
        return 100;
      case RampedaConfigField.redMs:
      case RampedaConfigField.greenMs:
        return 1000;
    }
  }

  int get max {
    switch (this) {
      case RampedaConfigField.distance:
        return 700;
      case RampedaConfigField.redMs:
      case RampedaConfigField.greenMs:
        return 7000;
    }
  }

  // bước cho slider (distance: 1, ms: 1000)
  int get step {
    switch (this) {
      case RampedaConfigField.distance:
        return 25;
      case RampedaConfigField.redMs:
      case RampedaConfigField.greenMs:
        return 500;
    }
  }

  int get divisions {
    final range = max - min;
    final s = step;
    if (s <= 0) return range;
    return range ~/ s;
  }
}
