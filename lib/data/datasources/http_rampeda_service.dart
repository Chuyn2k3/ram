import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/rampeda_config.dart';
import 'rampeda_service.dart';

class HttpRampedaService implements RampedaService {
  final String baseUrl;
  final Duration timeout;
  final int maxRetries;

  HttpRampedaService({
    this.baseUrl = '192.168.4.1', // ESP32 RAMPEDA
    this.timeout = const Duration(seconds: 5), // timeout mỗi request
    this.maxRetries = 3, // số lần retry nhẹ
  });

  Future<http.Response> _getWithRetry(String path) async {
    //final uri = Uri.parse('$baseUrl$path');
    final uri = Uri.http(baseUrl, path);
    Object? lastError;

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final resp = await http.get(uri).timeout(timeout);
        return resp;
      } on TimeoutException catch (e) {
        lastError = e;
      } on Exception catch (e) {
        lastError = e;
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }

    throw lastError ?? Exception('HTTP GET $path failed');
  }

  @override
  Future<bool> ping() async {
    final resp = await _getWithRetry('/ping');
    return resp.statusCode == 200 && resp.body.trim() == 'OK';
  }

  @override
  Future<String> getLogs() async {
    final resp = await _getWithRetry('/consulta');
    if (resp.statusCode == 200) {
      // Xóa file log cũ trước khi ghi lại dữ liệu mới
      final directory = await getApplicationDocumentsDirectory();
      final logFile = File('${directory.path}/log.txt');

      // Kiểm tra nếu file đã tồn tại, xóa nó đi
      if (await logFile.exists()) {
        await logFile.delete();
      }

      // Tạo lại file và ghi dữ liệu logs vào đó
      await logFile.writeAsString(resp.body);
      return resp.body;
    }
    throw Exception('Erreur /consulta: ${resp.statusCode}');
  }

  @override
  Future<void> eraseSd() async {
    final resp = await _getWithRetry('/erasesd');
    if (resp.statusCode != 200) {
      throw Exception('Erreur /erasesd: ${resp.statusCode}');
    }
  }

  @override
  Future<void> coupeWifi() async {
    final resp = await _getWithRetry('/coupewifi');
    if (resp.statusCode != 200) {
      throw Exception('Erreur /coupewifi: ${resp.statusCode}');
    }
  }

  @override
  Future<void> adjustTime(DateTime dt) async {
    // **DDMMYYYYhhmmss đúng format ESP32
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yyyy = dt.year.toString().padLeft(4, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    final ss = dt.second.toString().padLeft(2, '0');

    final payload = '**$dd$mm$yyyy$hh$mi$ss';

    final resp = await _getWithRetry('/$payload'); // → /**DDMMYYYYhhmmss
    if (resp.statusCode != 200) {
      throw Exception('Erreur adjustTime: ${resp.statusCode}');
    }
  }

  @override
  Future<void> updateConfig({
    required int distance,
    required int redMs,
    required int greenMs,
  }) async {
    // Clamp & validate theo yêu cầu thiết bị
    final d = distance.clamp(100, 700);
    final r = redMs.clamp(1000, 7000);
    final g = greenMs.clamp(1000, 7000);

    // Format: /&&DDDrrrrgggg
    // DDD: 3 chữ số, rrrr & gggg: 4 chữ số (theo ví dụ 12310002000)
    final dStr = d.toString().padLeft(3, '0');
    final rStr = r.toString().padLeft(4, '0');
    final gStr = g.toString().padLeft(4, '0');

    final payload = '$dStr$rStr$gStr';

    final resp = await _getWithRetry('/&&$payload');
    if (resp.statusCode != 200) {
      throw Exception('Erreur update config: ${resp.statusCode}');
    }
  }

  @override
  Future<RampedaConfig> getConfig() async {
    final resp = await _getWithRetry('/param');
    if (resp.statusCode != 200) {
      throw Exception('Erreur /param: ${resp.statusCode}');
    }

    final body = resp.body.trim();
    // aaabbbbcccc: 3 + 4 + 4 = 11 ký tự
    if (body.length < 11) {
      throw Exception('Réponse /param invalide: "$body"');
    }

    final distanceStr = body.substring(0, 3);
    final redStr = body.substring(3, 7);
    final greenStr = body.substring(7, 11);

    final distance = int.tryParse(distanceStr) ?? 0;
    final redMs = int.tryParse(redStr) ?? 0;
    final greenMs = int.tryParse(greenStr) ?? 0;

    return RampedaConfig(
      distance: distance,
      redMs: redMs,
      greenMs: greenMs,
    );
  }
}
