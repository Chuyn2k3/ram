// lib/domain/entities/rampeda_config.dart
class RampedaConfig {
  final int distance;
  final int redMs;
  final int greenMs;

  const RampedaConfig({
    required this.distance,
    required this.redMs,
    required this.greenMs,
  });

  static const zero = RampedaConfig(
    distance: 0,
    redMs: 0,
    greenMs: 0,
  );
}
