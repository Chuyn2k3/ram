import 'package:flutter/material.dart';

import '../../core/enums/connection_status.dart';

class StatusBadge extends StatelessWidget {
  final ConnectionStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    IconData icon;

    switch (status) {
      case ConnectionStatus.connected:
        text =
            'Connected to RAMPEDA'; // TODO: Thay text trạng thái kết nối ở đây
        color = Colors.green;
        icon = Icons.wifi;
        break;
      case ConnectionStatus.disconnected:
        text = 'Disconnected'; // TODO: Thay text khi mất kết nối ở đây
        color = Colors.redAccent;
        icon = Icons.wifi_off;
        break;
      case ConnectionStatus.unknown:
      default:
        text = 'Searching...'; // TODO: Thay text khi đang dò tìm thiết bị ở đây
        color = Colors.grey;
        icon = Icons.help_outline;
        break;
    }

    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
