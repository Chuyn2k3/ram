import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cubit/rampeda_state.dart';

class RampedaTerminal extends StatelessWidget {
  final RampedaState state;
  final bool isDark;

  const RampedaTerminal({
    super.key,
    required this.state,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final hasLogs =
        //false;
        state.logs.isNotEmpty;

    return Container(
      constraints: const BoxConstraints(minHeight: 400, maxHeight: 600),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? const Color(0xFF0D1117) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // En-tête du terminal
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161B22) : const Color(0xFFF6F8FA),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF30363D)
                      : const Color(0xFFE5E7EB),
                ),
              ),
            ),
            child: Row(
              children: [
                _buildDot(const Color(0xFFEF4444)),
                _buildDot(const Color(0xFFF59E0B)),
                _buildDot(const Color(0xFF10B981)),
                const SizedBox(width: 16),
                Icon(
                  Icons.terminal_rounded,
                  size: 18,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                const SizedBox(width: 8),
                Text(
                  'Terminal',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const Spacer(),
                if (hasLogs)
                  IconButton(
                    icon: Icon(
                      Icons.content_copy_rounded,
                      size: 18,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: state.logs));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 12),
                              Text('Copié dans le presse-papiers'),
                            ],
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0xFF10B981),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    tooltip: 'Copier',
                  ),
              ],
            ),
          ),

          // Corps du terminal
          Expanded(
            child: hasLogs
                ? Container(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        state.logs,
                        style: GoogleFonts.jetBrainsMono(
                          color: isDark
                              ? const Color(0xFF58A6FF)
                              : const Color(0xFF0969DA),
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 64,
                          color: isDark ? Colors.white24 : Colors.black26,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun log chargé',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Appuyez sur "Lire SD" pour charger',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
