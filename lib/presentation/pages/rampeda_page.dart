// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
//
// import '../../core/enums/connection_status.dart';
// import '../cubit/rampeda_cubit.dart';
// import '../cubit/rampeda_state.dart';
// import '../widgets/feature_button.dart';
// import '../widgets/status_badge.dart';
//
// class RampedaPage extends StatefulWidget {
//   const RampedaPage({super.key});
//
//   @override
//   State<RampedaPage> createState() => _RampedaPageState();
// }
//
// class _RampedaPageState extends State<RampedaPage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<RampedaCubit>().startPolling();
//     });
//   }
//
//   @override
//   void dispose() {
//     context.read<RampedaCubit>().stopPolling();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return BlocConsumer<RampedaCubit, RampedaState>(
//       listenWhen: (prev, curr) => curr.message != null && curr.message != '',
//       listener: (context, state) {
//         if (state.message != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.message!),
//               behavior: SnackBarBehavior.floating,
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         final disabled = state.connectionStatus != ConnectionStatus.connected ||
//             state.isBusy;
//
//         return Scaffold(
//           body: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [colorScheme.primaryContainer, colorScheme.surface],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//             child: SafeArea(
//               child: Column(
//                 children: [
//                   _buildHeader(context, state),
//                   const SizedBox(height: 12),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                     child: _buildButtonGrid(context, disabled),
//                   ),
//                   const SizedBox(height: 12),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: _buildLogCard(context, state),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildHeader(BuildContext context, RampedaState state) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
//       child: Row(
//         children: [
//           Expanded(
//             child: StatusBadge(status: state.connectionStatus),
//           ),
//           const SizedBox(width: 8),
//           if (state.isBusy)
//             const SizedBox(
//               width: 22,
//               height: 22,
//               child: CircularProgressIndicator(strokeWidth: 2),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildButtonGrid(BuildContext context, bool disabled) {
//     final cubit = context.read<RampedaCubit>();
//
//     final buttons = [
//       FeatureButton(
//         label: 'Mise à jour date', // TODO: Text nút cập nhật thời gian
//         icon: Icons.schedule,
//         onTap: disabled ? null : () => _onUpdateDate(context),
//       ),
//       FeatureButton(
//         label: 'Effacer écran', // TODO: Text nút xóa màn hình
//         icon: Icons.clear_all,
//         onTap: disabled ? null : cubit.clearScreen,
//       ),
//       FeatureButton(
//         label: 'Format SD', // TODO: Text nút format SD
//         icon: Icons.sd_storage,
//         onTap: disabled ? null : () => _onFormatSd(context),
//       ),
//       FeatureButton(
//         label: 'Exporter par e-mail', // TODO: Text nút xuất log qua email
//         icon: Icons.mail_outline,
//         onTap: disabled ? null : () => _onExportEmail(context),
//       ),
//       FeatureButton(
//         label: 'Lire SD', // TODO: Text nút đọc SD
//         icon: Icons.description_outlined,
//         onTap: disabled ? null : () => cubit.loadLogs(),
//       ),
//       FeatureButton(
//         label: 'Fermer', // TODO: Text nút tắt / đóng ứng dụng trên ESP32
//         icon: Icons.power_settings_new,
//         onTap: disabled ? null : () => _onFermer(context),
//       ),
//     ];
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final itemWidth = (constraints.maxWidth - 16) / 3;
//         return Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: buttons
//               .map(
//                 (b) => SizedBox(
//                   width: itemWidth,
//                   child: b,
//                 ),
//               )
//               .toList(),
//         );
//       },
//     );
//   }
//
//   Widget _buildLogCard(BuildContext context, RampedaState state) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 const Icon(Icons.terminal, size: 20),
//                 const SizedBox(width: 6),
//                 Text(
//                   'Logs', // TODO: Tiêu đề khu vực log
//                   style: textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const Spacer(),
//                 IconButton(
//                   icon: const Icon(Icons.copy),
//                   onPressed:
//                       state.logs.isEmpty ? null : () => _showCopyHint(context),
//                   tooltip: 'Copy logs', // TODO: Text tooltip copy
//                 ),
//               ],
//             ),
//             const Divider(),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 padding: const EdgeInsets.all(8),
//                 child: SingleChildScrollView(
//                   child: SelectableText(
//                     state.logs.isEmpty
//                         ? 'Aucun log pour le moment.\n\nUtilisez "Lire SD" pour afficher les logs (données demo).'
//                         // TODO: Nội dung hướng dẫn khi chưa có log
//                         : state.logs,
//                     style: const TextStyle(
//                       fontFamily: 'monospace',
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _onUpdateDate(BuildContext context) async {
//     final cubit = context.read<RampedaCubit>();
//     final now = DateTime.now();
//
//     final date = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//     if (date == null) return;
//
//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(now),
//     );
//     if (time == null) return;
//
//     final dt = DateTime(
//       date.year,
//       date.month,
//       date.day,
//       time.hour,
//       time.minute,
//     );
//
//     final ok = await _confirmDialog(
//       context,
//       'Mise à jour date', // TODO: Tiêu đề dialog xác nhận cập nhật thời gian
//       'L\'appareil va redémarrer.\nContinuer ?', // TODO: Nội dung dialog xác nhận
//     );
//     if (!ok) return;
//
//     await cubit.adjustTimeAndWaitRestart(dt);
//   }
//
//   Future<void> _onFormatSd(BuildContext context) async {
//     final cubit = context.read<RampedaCubit>();
//
//     final ok = await _confirmDialog(
//       context,
//       'Format SD', // TODO: Tiêu đề dialog format SD
//       'Supprimer tous les logs et redémarrer l\'appareil ?', // TODO: Nội dung dialog
//     );
//     if (!ok) return;
//
//     await cubit.formatSdAndWaitRestart();
//   }
//
//   Future<void> _onFermer(BuildContext context) async {
//     final cubit = context.read<RampedaCubit>();
//
//     final ok = await _confirmDialog(
//       context,
//       'Fermer', // TODO: Tiêu đề dialog Fermer
//       'Couper l\'application et redémarrer (simulation) ?', // TODO: Nội dung dialog Fermer
//     );
//     if (!ok) return;
//
//     await cubit.coupeWifiAndWaitRestart();
//   }
//
//   Future<void> _onExportEmail(BuildContext context) async {
//     final state = context.read<RampedaCubit>().state;
//     final logs = state.logs;
//     if (logs.isEmpty) {
//       await _infoDialog(
//         context,
//         'Exporter', // TODO: Tiêu đề dialog export
//         'Aucun log à exporter.\nUtilisez d\'abord "Lire SD".', // TODO: Nội dung dialog export
//       );
//       return;
//     }
//     await _exportLogsFile(logs);
//   }
//
//   Future<void> _showCopyHint(BuildContext context) async {
//     await _infoDialog(
//       context,
//       'Copy', // TODO: Tiêu đề dialog copy
//       'Có thể thêm chức năng copy vào Clipboard ở đây.', // TODO: Thông báo hướng dẫn copy
//     );
//   }
//
//   Future<bool> _confirmDialog(
//     BuildContext context,
//     String title,
//     String message,
//   ) async {
//     final result = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(_, false),
//             child: const Text('Annuler'),
//           ),
//           FilledButton(
//             onPressed: () => Navigator.pop(_, true),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//     return result ?? false;
//   }
//
//   Future<void> _infoDialog(
//     BuildContext context,
//     String title,
//     String message,
//   ) async {
//     await showDialog<void>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           FilledButton(
//             onPressed: () => Navigator.pop(_, null),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _exportLogsFile(String content) async {
//     final dir = await getTemporaryDirectory();
//     final file = File('${dir.path}/logs_demo.txt');
//     await file.writeAsString(content);
//
//     await Share.shareXFiles(
//       [XFile(file.path, mimeType: 'text/plain', name: 'logs_demo.txt')],
//       subject: 'Logs RAMPEDA (demo)', // TODO: Subject email khi export
//       text: 'Fichier de logs RAMPEDA (données demo).', // TODO: Nội dung email
//     );
//   }
// }
// lib/features/rampeda/presentation/pages/rampeda_page.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/enums/connection_status.dart';
import '../cubit/rampeda_cubit.dart';
import '../cubit/rampeda_state.dart';

class RampedaPage extends StatefulWidget {
  const RampedaPage({super.key});

  @override
  State<RampedaPage> createState() => _RampedaPageState();
}

class _RampedaPageState extends State<RampedaPage>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RampedaCubit>().startPolling();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    context.read<RampedaCubit>().stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<RampedaCubit, RampedaState>(
      listenWhen: (prev, curr) => curr.message?.isNotEmpty == true,
      listener: (context, state) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Row(
        //       children: [
        //         Icon(Icons.info_outline, color: Colors.white),
        //         const SizedBox(width: 12),
        //         Expanded(child: Text(state.message!)),
        //       ],
        //     ),
        //     behavior: SnackBarBehavior.floating,
        //     backgroundColor: theme.colorScheme.primary,
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        //     margin: const EdgeInsets.all(16),
        //     duration: const Duration(seconds: 3),
        //   ),
        // );
      },
      builder: (context, state) {
        final isConnected =
            state.connectionStatus == ConnectionStatus.connected;
        final disabled = !isConnected || state.isBusy;

        return Scaffold(
          backgroundColor:
              isDark ? const Color(0xFF0A0E17) : const Color(0xFFF5F7FA),
          body: CustomScrollView(
            slivers: [
              // App Bar avec statut de connexion
              SliverAppBar(
                expandedHeight: 140,
                floating: false,
                pinned: true,
                backgroundColor:
                    isDark ? const Color(0xFF1A2332) : Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [const Color(0xFF1A2332), const Color(0xFF0A0E17)]
                            : [Colors.white, const Color(0xFFF5F7FA)],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'RAMPEDA',
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1A2332),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildStatusChip(isConnected, state.isBusy, isDark),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Contenu principal
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Grille de fonctionnalités
                    _buildFeatureGrid(context, disabled, isDark),
                    const SizedBox(height: 24),

                    // Terminal
                    _buildTerminal(context, state, isDark),
                    const SizedBox(height: 20),
                    // _buildLogsSection(state.logs),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogsSection(String logs) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Logs:',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                child: SelectableText(
                  logs.isEmpty ? 'No logs yet.' : logs,
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.greenAccent[100],
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context, bool disabled, bool isDark) {
    final cubit = context.read<RampedaCubit>();

    final features = [
      {
        'label': 'Date/Heure',
        'icon': Icons.schedule_rounded,
        'gradient': [const Color(0xFF8B5CF6), const Color(0xFF6366F1)],
        'action': () => _onUpdateDate(context)
      },
      {
        'label': 'Effacer',
        'icon': Icons.delete_sweep_rounded,
        'gradient': [const Color(0xFF64748B), const Color(0xFF475569)],
        'action': cubit.clearScreen
      },
      {
        'label': 'Format SD',
        'icon': Icons.sd_card_rounded,
        'gradient': [const Color(0xFFEF4444), const Color(0xFFDC2626)],
        'action': () => _onFormatSd(context)
      },
      {
        'label': 'Exporter',
        'icon': Icons.ios_share_rounded,
        'gradient': [const Color(0xFF14B8A6), const Color(0xFF0D9488)],
        'action': () => _onExportEmail(context)
      },
      {
        'label': 'Lire SD',
        'icon': Icons.folder_open_rounded,
        'gradient': [const Color(0xFF06B6D4), const Color(0xFF0891B2)],
        'action': cubit.loadLogs
      },
      {
        'label': 'Redémarrer',
        'icon': Icons.power_settings_new_rounded,
        'gradient': [const Color(0xFFF97316), const Color(0xFFEA580C)],
        'action': () => _onFermer(context)
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: features.length,
      itemBuilder: (context, i) {
        final f = features[i];
        return FeatureCard(
          label: f['label'] as String,
          icon: f['icon'] as IconData,
          gradient: f['gradient'] as List<Color>,
          onTap: disabled ? null : f['action'] as VoidCallback,
          isDark: isDark,
        );
      },
    );
  }

  Widget _buildStatusChip(bool isConnected, bool isBusy, bool isDark) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isConnected && !isBusy ? _pulseAnimation.value : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isConnected
                  ? const Color(0xFF10B981).withOpacity(0.15)
                  : const Color(0xFFEF4444).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isConnected
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isConnected
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isConnected
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444))
                            .withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  isConnected ? 'Connecté' : 'Déconnecté',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isConnected
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
                if (isBusy) ...[
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        isConnected
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTerminal(BuildContext context, RampedaState state, bool isDark) {
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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

  // Actions
  Future<void> _onUpdateDate(BuildContext context) async {
    final cubit = context.read<RampedaCubit>();
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF8B5CF6),
            ),
          ),
          child: child!,
        );
      },
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF8B5CF6),
            ),
          ),
          child: child!,
        );
      },
    );
    if (time == null) return;

    final dt =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final ok = await _confirm(
      context,
      'Mettre à jour la date ?',
      'L\'appareil va redémarrer après la mise à jour.',
      confirmText: 'Mettre à jour',
    );
    if (ok) await cubit.adjustTimeAndWaitRestart(dt);
  }

  Future<void> _onFormatSd(BuildContext context) async {
    final ok = await _confirm(
      context,
      'Formater la carte SD ?',
      'Attention : Tous les logs seront définitivement effacés.',
      confirmText: 'Formater',
      isDangerous: true,
    );
    if (ok) await context.read<RampedaCubit>().formatSdAndWaitRestart();
  }

  Future<void> _onFermer(BuildContext context) async {
    final ok = await _confirm(
      context,
      'Redémarrer l\'appareil ?',
      'L\'application va se fermer et l\'appareil va redémarrer.',
      confirmText: 'Redémarrer',
    );
    if (ok) await context.read<RampedaCubit>().coupeWifiAndWaitRestart();
  }

  Future<void> _onExportEmail(BuildContext context) async {
    final logs = context.read<RampedaCubit>().state.logs;
    if (logs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Aucun log à exporter')),
            ],
          ),
          backgroundColor: const Color(0xFFF59E0B),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    await _exportLogsFile(logs);
  }

  Future<bool> _confirm(
    BuildContext context,
    String title,
    String content, {
    String confirmText = 'Confirmer',
    bool isDangerous = false,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1A2332)
                : Colors.white,
            title: Text(
              title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            content: Text(
              content,
              style: GoogleFonts.inter(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(_, false),
                child: Text(
                  'Annuler',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: isDangerous
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF8B5CF6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(_, true),
                child: Text(
                  confirmText,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _exportLogsFile(String content) async {
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/rampeda_logs_${DateTime.now().millisecondsSinceEpoch}.txt',
    );
    await file.writeAsString(content);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/plain', name: 'log.txt')],
      subject:
          'Logs RAMPEDA - ${DateTime.now().toIso8601String().substring(0, 10)}',
      text: 'Ci-joint les logs complets de l\'appareil RAMPEDA.',
    );
  }
}

// Widget carte de fonctionnalité moderne
class FeatureCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback? onTap;
  final bool isDark;

  const FeatureCard({
    super.key,
    required this.label,
    required this.icon,
    required this.gradient,
    this.onTap,
    required this.isDark,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: enabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: enabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: enabled ? 1.0 : 0.4,
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: enabled
                    ? widget.gradient
                    : [Colors.grey, Colors.grey.shade600],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: widget.gradient[0].withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
