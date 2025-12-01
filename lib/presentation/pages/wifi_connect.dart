import 'package:wifi_iot/wifi_iot.dart';
import 'package:flutter/material.dart';

class WifiConnectionPage extends StatefulWidget {
  const WifiConnectionPage({super.key});

  @override
  _WifiConnectionPageState createState() => _WifiConnectionPageState();
}

class _WifiConnectionPageState extends State<WifiConnectionPage> {
  String _deviceIP = "Fetching IP...";

  @override
  void initState() {
    super.initState();
    _getDeviceIP();
  }

  Future<void> _getDeviceIP() async {
    try {
      String ip = await WiFiForIoTPlugin.getIP() ??
          "k lấy đc ip"; // Lấy địa chỉ IP của thiết bị
      setState(() {
        _deviceIP = ip;
      });
    } catch (e) {
      setState(() {
        _deviceIP = "Error fetching IP: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get Device IP')),
      body: Center(
        child: Text(
          'Device IP: $_deviceIP',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
