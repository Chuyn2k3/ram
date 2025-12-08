// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
//
// import '../../core/enums/connection_status.dart';
// import '../cubit/rampeda_cubit.dart';
// import '../cubit/rampeda_state.dart';
// import '../widgets/feature_card.dart';
//
// class RampedaPage extends StatefulWidget {
//   const RampedaPage({super.key});
//
//   @override
//   State<RampedaPage> createState() => _RampedaPageState();
// }
//
// class _RampedaPageState extends State<RampedaPage>
//     with TickerProviderStateMixin {
//   late final AnimationController _pulseController;
//   late final Animation<double> _pulseAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat(reverse: true);
//
//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<RampedaCubit>().startPolling();
//     });
//   }
//
//   @override
//   void dispose() {
//     _pulseController.dispose();
//     context.read<RampedaCubit>().stopPolling();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     return BlocConsumer<RampedaCubit, RampedaState>(
//       listenWhen: (prev, curr) => curr.message?.isNotEmpty == true,
//       listener: (context, state) {
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(
//         //     content: Row(
//         //       children: [
//         //         Icon(Icons.info_outline, color: Colors.white),
//         //         const SizedBox(width: 12),
//         //         Expanded(child: Text(state.message!)),
//         //       ],
//         //     ),
//         //     behavior: SnackBarBehavior.floating,
//         //     backgroundColor: theme.colorScheme.primary,
//         //     shape:
//         //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         //     margin: const EdgeInsets.all(16),
//         //     duration: const Duration(seconds: 3),
//         //   ),
//         // );
//       },
//       builder: (context, state) {
//         final isConnected =
//             state.connectionStatus == ConnectionStatus.connected;
//         final disabled = !isConnected || state.isBusy;
//
//         return Scaffold(
//           backgroundColor:
//               isDark ? const Color(0xFF0A0E17) : const Color(0xFFF5F7FA),
//           body: CustomScrollView(
//             slivers: [
//               // App Bar avec statut de connexion
//               SliverAppBar(
//                 expandedHeight: 80,
//                 floating: false,
//                 pinned: true,
//                 backgroundColor:
//                     isDark ? const Color(0xFF1A2332) : Colors.white,
//                 elevation: 0,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: isDark
//                             ? [const Color(0xFF1A2332), const Color(0xFF0A0E17)]
//                             : [Colors.white, const Color(0xFFF5F7FA)],
//                       ),
//                     ),
//                     child: SafeArea(
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           //mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text(
//                               'RAMPEDA',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 32,
//                                 fontWeight: FontWeight.w800,
//                                 color: isDark
//                                     ? Colors.white
//                                     : const Color(0xFF1A2332),
//                                 letterSpacing: -0.5,
//                               ),
//                             ),
//                             //const SizedBox(height: 8),
//                             const Spacer(),
//                             _buildStatusChip(isConnected, state.isBusy, isDark),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Contenu principal
//               SliverPadding(
//                 padding: const EdgeInsets.all(20),
//                 sliver: SliverList(
//                   delegate: SliverChildListDelegate([
//                     // Grille de fonctionnalités
//                     _buildFeatureGrid(context, disabled, isDark),
//                     const SizedBox(height: 24),
//
//                     // Terminal
//                     _buildTerminal(context, state, isDark),
//                     const SizedBox(height: 20),
//                     // _buildLogsSection(state.logs),
//                   ]),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildLogsSection(String logs) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Logs:',
//                 style: GoogleFonts.inter(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               SingleChildScrollView(
//                 child: SelectableText(
//                   logs.isEmpty ? 'No logs yet.' : logs,
//                   style: GoogleFonts.jetBrainsMono(
//                     color: Colors.greenAccent[100],
//                     fontSize: 13,
//                     height: 1.6,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFeatureGrid(BuildContext context, bool disabled, bool isDark) {
//     final cubit = context.read<RampedaCubit>();
//
//     final features = [
//       {
//         'label': 'Date/Heure',
//         'icon': Icons.schedule_rounded,
//         'gradient': [const Color(0xFF8B5CF6), const Color(0xFF6366F1)],
//         'action': () => _onUpdateDate(context)
//       },
//       {
//         'label': 'Effacer',
//         'icon': Icons.delete_sweep_rounded,
//         'gradient': [const Color(0xFF64748B), const Color(0xFF475569)],
//         'action': cubit.clearScreen
//       },
//       {
//         'label': 'Format SD',
//         'icon': Icons.sd_card_rounded,
//         'gradient': [const Color(0xFFEF4444), const Color(0xFFDC2626)],
//         'action': () => _onFormatSd(context)
//       },
//       {
//         'label': 'Exporter',
//         'icon': Icons.ios_share_rounded,
//         'gradient': [const Color(0xFF14B8A6), const Color(0xFF0D9488)],
//         'action': () => _onExportEmail(context)
//       },
//       {
//         'label': 'Lire SD',
//         'icon': Icons.folder_open_rounded,
//         'gradient': [const Color(0xFF06B6D4), const Color(0xFF0891B2)],
//         'action': cubit.loadLogs
//       },
//       {
//         'label': 'Redémarrer',
//         'icon': Icons.power_settings_new_rounded,
//         'gradient': [const Color(0xFFF97316), const Color(0xFFEA580C)],
//         'action': () => _onFermer(context)
//       },
//       {
//         'label': 'Config',
//         'icon': Icons.tune_rounded,
//         'gradient': [const Color(0xFF22C55E), const Color(0xFF16A34A)],
//         'action': () => _openConfigSheet(context, isDark),
//       },
//     ];
//
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.zero,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//         childAspectRatio: 1.0,
//         mainAxisSpacing: 14,
//         crossAxisSpacing: 14,
//       ),
//       itemCount: features.length,
//       itemBuilder: (context, i) {
//         final f = features[i];
//         return FeatureCard(
//           label: f['label'] as String,
//           icon: f['icon'] as IconData,
//           gradient: f['gradient'] as List<Color>,
//           onTap: f['action'] as VoidCallback,
//           //disabled ? null : f['action'] as VoidCallback,
//           isDark: isDark,
//         );
//       },
//     );
//   }
//
//   Widget _buildStatusChip(bool isConnected, bool isBusy, bool isDark) {
//     return AnimatedBuilder(
//       animation: _pulseAnimation,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: isConnected && !isBusy ? _pulseAnimation.value : 1.0,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               color: isConnected
//                   ? const Color(0xFF10B981).withOpacity(0.15)
//                   : const Color(0xFFEF4444).withOpacity(0.15),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: isConnected
//                     ? const Color(0xFF10B981)
//                     : const Color(0xFFEF4444),
//                 width: 1.5,
//               ),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 8,
//                   height: 8,
//                   decoration: BoxDecoration(
//                     color: isConnected
//                         ? const Color(0xFF10B981)
//                         : const Color(0xFFEF4444),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: (isConnected
//                                 ? const Color(0xFF10B981)
//                                 : const Color(0xFFEF4444))
//                             .withOpacity(0.5),
//                         blurRadius: 8,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Text(
//                   isConnected ? 'Connecté' : 'Déconnecté',
//                   style: GoogleFonts.inter(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: isConnected
//                         ? const Color(0xFF10B981)
//                         : const Color(0xFFEF4444),
//                   ),
//                 ),
//                 if (isBusy) ...[
//                   const SizedBox(width: 10),
//                   SizedBox(
//                     width: 16,
//                     height: 16,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation(
//                         isConnected
//                             ? const Color(0xFF10B981)
//                             : const Color(0xFFEF4444),
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTerminal(BuildContext context, RampedaState state, bool isDark) {
//     final hasLogs =
//
//         //false;
//         state.logs.isNotEmpty;
//
//     return Container(
//       constraints: const BoxConstraints(minHeight: 400, maxHeight: 600),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: isDark ? const Color(0xFF0D1117) : Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // En-tête du terminal
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//             decoration: BoxDecoration(
//               color: isDark ? const Color(0xFF161B22) : const Color(0xFFF6F8FA),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//               border: Border(
//                 bottom: BorderSide(
//                   color: isDark
//                       ? const Color(0xFF30363D)
//                       : const Color(0xFFE5E7EB),
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 _buildDot(const Color(0xFFEF4444)),
//                 _buildDot(const Color(0xFFF59E0B)),
//                 _buildDot(const Color(0xFF10B981)),
//                 const SizedBox(width: 16),
//                 Icon(
//                   Icons.terminal_rounded,
//                   size: 18,
//                   color: isDark ? Colors.white70 : Colors.black54,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Terminal',
//                   style: GoogleFonts.inter(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: isDark ? Colors.white70 : Colors.black87,
//                   ),
//                 ),
//                 const Spacer(),
//                 if (hasLogs)
//                   IconButton(
//                     icon: Icon(
//                       Icons.content_copy_rounded,
//                       size: 18,
//                       color: isDark ? Colors.white70 : Colors.black54,
//                     ),
//                     onPressed: () {
//                       Clipboard.setData(ClipboardData(text: state.logs));
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: const Row(
//                             children: [
//                               Icon(Icons.check_circle, color: Colors.white),
//                               SizedBox(width: 12),
//                               Text('Copié dans le presse-papiers'),
//                             ],
//                           ),
//                           behavior: SnackBarBehavior.floating,
//                           backgroundColor: const Color(0xFF10B981),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       );
//                     },
//                     tooltip: 'Copier',
//                   ),
//               ],
//             ),
//           ),
//
//           // Corps du terminal
//           Expanded(
//             child: hasLogs
//                 ? Container(
//                     padding: const EdgeInsets.all(20),
//                     child: SingleChildScrollView(
//                       child: SelectableText(
//                         state.logs,
//                         style: GoogleFonts.jetBrainsMono(
//                           color: isDark
//                               ? const Color(0xFF58A6FF)
//                               : const Color(0xFF0969DA),
//                           fontSize: 13,
//                           height: 1.6,
//                         ),
//                       ),
//                     ),
//                   )
//                 : Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.description_outlined,
//                           size: 64,
//                           color: isDark ? Colors.white24 : Colors.black26,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Aucun log chargé',
//                           style: GoogleFonts.inter(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: isDark ? Colors.white54 : Colors.black54,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Appuyez sur "Lire SD" pour charger',
//                           style: GoogleFonts.inter(
//                             fontSize: 13,
//                             color: isDark ? Colors.white38 : Colors.black38,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDot(Color color) {
//     return Container(
//       width: 12,
//       height: 12,
//       margin: const EdgeInsets.only(right: 8),
//       decoration: BoxDecoration(
//         color: color,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
//
//   // Actions
//   Future<void> _onUpdateDate(BuildContext context) async {
//     final cubit = context.read<RampedaCubit>();
//     final now = DateTime.now();
//
//     final date = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF8B5CF6),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (date == null) return;
//
//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(now),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF8B5CF6),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (time == null) return;
//
//     final dt =
//         DateTime(date.year, date.month, date.day, time.hour, time.minute);
//     final ok = await _confirm(
//       context,
//       'Mettre à jour la date ?',
//       'L\'appareil va redémarrer après la mise à jour.',
//       confirmText: 'Mettre à jour',
//     );
//     if (ok) await cubit.adjustTimeAndWaitRestart(dt);
//   }
//
//   Future<void> _onFormatSd(BuildContext context) async {
//     final ok = await _confirm(
//       context,
//       'Formater la carte SD ?',
//       'Attention : Tous les logs seront définitivement effacés.',
//       confirmText: 'Formater',
//       isDangerous: true,
//     );
//     if (ok) await context.read<RampedaCubit>().formatSdAndWaitRestart();
//   }
//
//   Future<void> _onFermer(BuildContext context) async {
//     final ok = await _confirm(
//       context,
//       'Redémarrer l\'appareil ?',
//       'L\'application va se fermer et l\'appareil va redémarrer.',
//       confirmText: 'Redémarrer',
//     );
//     if (ok) await context.read<RampedaCubit>().coupeWifiAndWaitRestart();
//   }
//
//   Future<void> _onExportEmail(BuildContext context) async {
//     final logs = context.read<RampedaCubit>().state.logs;
//     if (logs.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(
//             children: [
//               Icon(Icons.warning_amber_rounded, color: Colors.white),
//               SizedBox(width: 12),
//               Expanded(child: Text('Aucun log à exporter')),
//             ],
//           ),
//           backgroundColor: const Color(0xFFF59E0B),
//           behavior: SnackBarBehavior.floating,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       return;
//     }
//     await _exportLogsFile(logs);
//   }
//
//   Future<bool> _confirm(
//     BuildContext context,
//     String title,
//     String content, {
//     String confirmText = 'Confirmer',
//     bool isDangerous = false,
//   }) async {
//     return await showDialog<bool>(
//           context: context,
//           builder: (_) => AlertDialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             backgroundColor: Theme.of(context).brightness == Brightness.dark
//                 ? const Color(0xFF1A2332)
//                 : Colors.white,
//             title: Text(
//               title,
//               style: GoogleFonts.inter(
//                 fontWeight: FontWeight.w700,
//                 fontSize: 18,
//               ),
//             ),
//             content: Text(
//               content,
//               style: GoogleFonts.inter(fontSize: 14),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(_, false),
//                 child: Text(
//                   'Annuler',
//                   style: GoogleFonts.inter(fontWeight: FontWeight.w600),
//                 ),
//               ),
//               FilledButton(
//                 style: FilledButton.styleFrom(
//                   backgroundColor: isDangerous
//                       ? const Color(0xFFEF4444)
//                       : const Color(0xFF8B5CF6),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () => Navigator.pop(_, true),
//                 child: Text(
//                   confirmText,
//                   style: GoogleFonts.inter(fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }
//
//   Future<void> _exportLogsFile(String content) async {
//     final dir = await getTemporaryDirectory();
//     final file = File(
//       '${dir.path}/rampeda_logs_${DateTime.now().millisecondsSinceEpoch}.txt',
//     );
//     await file.writeAsString(content);
//
//     await Share.shareXFiles(
//       [XFile(file.path, mimeType: 'text/plain', name: 'log.txt')],
//       subject:
//           'Logs RAMPEDA - ${DateTime.now().toIso8601String().substring(0, 10)}',
//       text: 'Ci-joint les logs complets de l\'appareil RAMPEDA.',
//     );
//   }
//
//   Future<void> _openConfigSheet(BuildContext context, bool isDark) async {
//     final cubit = context.read<RampedaCubit>();
//
//     int distance = 200; // mm
//     int redMs = 5000; // ms
//     int greenMs = 5000; // ms
//
//     // Màu cho từng nhóm
//     const distanceColor = Color(0xFF3B82F6); // xanh dương
//     const redColor = Color(0xFFEF4444); // đỏ
//     const greenColor = Color(0xFF22C55E); // xanh lá
//
//     final result = await showModalBottomSheet<bool>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: isDark ? const Color(0xFF0D1117) : Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (ctx) {
//         final distanceCtrl = TextEditingController(text: distance.toString());
//         final redCtrl = TextEditingController(text: redMs.toString());
//         final greenCtrl = TextEditingController(text: greenMs.toString());
//
//         void updateDistanceFromText(
//             String v, void Function(void Function()) setState) {
//           final val = int.tryParse(v);
//           if (val == null) return;
//           final clamped = val.clamp(100, 600);
//           setState(() => distance = clamped);
//           if (clamped.toString() != v) {
//             distanceCtrl.text = clamped.toString();
//             distanceCtrl.selection = TextSelection.fromPosition(
//               TextPosition(offset: distanceCtrl.text.length),
//             );
//           }
//         }
//
//         void updateRedFromText(
//             String v, void Function(void Function()) setState) {
//           final val = int.tryParse(v);
//           if (val == null) return;
//           final clamped = val.clamp(1000, 60000);
//           setState(() => redMs = clamped);
//           if (clamped.toString() != v) {
//             redCtrl.text = clamped.toString();
//             redCtrl.selection = TextSelection.fromPosition(
//               TextPosition(offset: redCtrl.text.length),
//             );
//           }
//         }
//
//         void updateGreenFromText(
//             String v, void Function(void Function()) setState) {
//           final val = int.tryParse(v);
//           if (val == null) return;
//           final clamped = val.clamp(1000, 60000);
//           setState(() => greenMs = clamped);
//           if (clamped.toString() != v) {
//             greenCtrl.text = clamped.toString();
//             greenCtrl.selection = TextSelection.fromPosition(
//               TextPosition(offset: greenCtrl.text.length),
//             );
//           }
//         }
//
//         OutlineInputBorder border(Color color, {bool focused = false}) {
//           return OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(
//               color: focused ? color : color.withOpacity(0.6),
//               width: focused ? 1.8 : 1.2,
//             ),
//           );
//         }
//
//         return Padding(
//           padding: EdgeInsets.only(
//             left: 20,
//             right: 20,
//             top: 16,
//             bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
//           ),
//           child: StatefulBuilder(
//             builder: (ctx, setState) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Container(
//                       width: 40,
//                       height: 4,
//                       margin: const EdgeInsets.only(bottom: 16),
//                       decoration: BoxDecoration(
//                         color: isDark
//                             ? Colors.white24
//                             : Colors.black.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(999),
//                       ),
//                     ),
//                   ),
//                   Text(
//                     'Configuration',
//                     style: GoogleFonts.inter(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       color: isDark ? Colors.white : const Color(0xFF111827),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // DISTANCE
//                   Text(
//                     'Distance de détection (mm)',
//                     style: GoogleFonts.inter(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: isDark ? Colors.white70 : const Color(0xFF111827),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Theme(
//                           data: Theme.of(context).copyWith(
//                             textSelectionTheme: TextSelectionThemeData(
//                               cursorColor: distanceColor,
//                               selectionColor: distanceColor.withOpacity(0.3),
//                               selectionHandleColor: distanceColor,
//                             ),
//                           ),
//                           child: TextField(
//                             controller: distanceCtrl,
//                             keyboardType: TextInputType.number,
//                             cursorColor: distanceColor,
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly,
//                             ],
//                             decoration: InputDecoration(
//                               isDense: true,
//                               border: border(distanceColor),
//                               enabledBorder: border(distanceColor),
//                               focusedBorder:
//                                   border(distanceColor, focused: true),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 8,
//                               ),
//                               hintText: '100–600',
//                             ),
//                             onChanged: (v) =>
//                                 updateDistanceFromText(v, setState),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'mm',
//                         style: GoogleFonts.inter(
//                           fontSize: 13,
//                           color: isDark ? Colors.white54 : Colors.grey[700],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SliderTheme(
//                     data: SliderTheme.of(ctx).copyWith(
//                       activeTrackColor: distanceColor,
//                       thumbColor: distanceColor,
//                       valueIndicatorColor: distanceColor,
//                     ),
//                     child: Slider(
//                       value: distance.toDouble(),
//                       min: 100,
//                       max: 600,
//                       divisions: 500,
//                       label: '$distance mm',
//                       onChanged: (v) {
//                         setState(() => distance = v.round());
//                         distanceCtrl.text = distance.toString();
//                         distanceCtrl.selection = TextSelection.fromPosition(
//                           TextPosition(offset: distanceCtrl.text.length),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//
//                   // RED LASER
//                   Text(
//                     'Durée laser rouge (ms)',
//                     style: GoogleFonts.inter(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: isDark ? Colors.white70 : const Color(0xFF111827),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Theme(
//                           data: Theme.of(context).copyWith(
//                             textSelectionTheme: TextSelectionThemeData(
//                               cursorColor: redColor,
//                               selectionColor: redColor.withOpacity(0.3),
//                               selectionHandleColor: redColor,
//                             ),
//                           ),
//                           child: TextField(
//                             controller: redCtrl,
//                             keyboardType: TextInputType.number,
//                             cursorColor: redColor,
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly,
//                             ],
//                             decoration: InputDecoration(
//                               isDense: true,
//                               border: border(redColor),
//                               enabledBorder: border(redColor),
//                               focusedBorder: border(redColor, focused: true),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 8,
//                               ),
//                               hintText: '1000–60000',
//                             ),
//                             onChanged: (v) => updateRedFromText(v, setState),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'ms',
//                         style: GoogleFonts.inter(
//                           fontSize: 13,
//                           color: isDark ? Colors.white54 : Colors.grey[700],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SliderTheme(
//                     data: SliderTheme.of(ctx).copyWith(
//                       activeTrackColor: redColor,
//                       thumbColor: redColor,
//                       valueIndicatorColor: redColor,
//                     ),
//                     child: Slider(
//                       value: redMs.toDouble(),
//                       min: 1000,
//                       max: 60000,
//                       divisions: 59,
//                       label: '$redMs ms',
//                       onChanged: (v) {
//                         final rounded = (v ~/ 1000) * 1000;
//                         setState(() => redMs = rounded);
//                         redCtrl.text = redMs.toString();
//                         redCtrl.selection = TextSelection.fromPosition(
//                           TextPosition(offset: redCtrl.text.length),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//
//                   // GREEN LASER
//                   Text(
//                     'Durée laser verte (ms)',
//                     style: GoogleFonts.inter(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: isDark ? Colors.white70 : const Color(0xFF111827),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Theme(
//                           data: Theme.of(context).copyWith(
//                             textSelectionTheme: TextSelectionThemeData(
//                               cursorColor: greenColor,
//                               selectionColor: greenColor.withOpacity(0.3),
//                               selectionHandleColor: greenColor,
//                             ),
//                           ),
//                           child: TextField(
//                             controller: greenCtrl,
//                             keyboardType: TextInputType.number,
//                             cursorColor: greenColor,
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly,
//                             ],
//                             decoration: InputDecoration(
//                               isDense: true,
//                               border: border(greenColor),
//                               enabledBorder: border(greenColor),
//                               focusedBorder: border(greenColor, focused: true),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 8,
//                               ),
//                               hintText: '1000–60000',
//                             ),
//                             onChanged: (v) => updateGreenFromText(v, setState),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'ms',
//                         style: GoogleFonts.inter(
//                           fontSize: 13,
//                           color: isDark ? Colors.white54 : Colors.grey[700],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SliderTheme(
//                     data: SliderTheme.of(ctx).copyWith(
//                       activeTrackColor: greenColor,
//                       thumbColor: greenColor,
//                       valueIndicatorColor: greenColor,
//                     ),
//                     child: Slider(
//                       value: greenMs.toDouble(),
//                       min: 1000,
//                       max: 60000,
//                       divisions: 59,
//                       label: '$greenMs ms',
//                       onChanged: (v) {
//                         final rounded = (v ~/ 1000) * 1000;
//                         setState(() => greenMs = rounded);
//                         greenCtrl.text = greenMs.toString();
//                         greenCtrl.selection = TextSelection.fromPosition(
//                           TextPosition(offset: greenCtrl.text.length),
//                         );
//                       },
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextButton(
//                           onPressed: () => Navigator.pop(ctx, false),
//                           child: Text(
//                             'Annuler',
//                             style: GoogleFonts.inter(
//                               fontWeight: FontWeight.w600,
//                               color: isDark
//                                   ? Colors.white70
//                                   : const Color(0xFF6B7280),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: FilledButton(
//                           style: FilledButton.styleFrom(
//                             backgroundColor: const Color(0xFF22C55E),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                           ),
//                           onPressed: () => Navigator.pop(ctx, true),
//                           child: Text(
//                             'Enregistrer',
//                             style: GoogleFonts.inter(
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//
//     if (result == true) {
//       await cubit.updateConfig(
//         distance: distance,
//         redMs: redMs,
//         greenMs: greenMs,
//       );
//     }
//   }
// }

// ////////////////////////////////////////////////////////
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
//
// import '../../core/enums/connection_status.dart';
// import '../cubit/rampeda_cubit.dart';
// import '../cubit/rampeda_state.dart';
// import '../enum/rampeda_config_field.dart';
// import '../enum/rampeda_feature.dart';
// import '../widgets/feature_card.dart';
//
// class RampedaPage extends StatefulWidget {
//   const RampedaPage({super.key});
//
//   @override
//   State<RampedaPage> createState() => _RampedaPageState();
// }
//
// class _RampedaPageState extends State<RampedaPage>
//     with TickerProviderStateMixin {
//   late final AnimationController _pulseController;
//   late final Animation<double> _pulseAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat(reverse: true);
//
//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<RampedaCubit>().startPolling();
//     });
//   }
//
//   @override
//   void dispose() {
//     _pulseController.dispose();
//     context.read<RampedaCubit>().stopPolling();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     return BlocConsumer<RampedaCubit, RampedaState>(
//       listenWhen: (prev, curr) => curr.message?.isNotEmpty == true,
//       listener: (context, state) {
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(
//         //     content: Row(
//         //       children: [
//         //         Icon(Icons.info_outline, color: Colors.white),
//         //         const SizedBox(width: 12),
//         //         Expanded(child: Text(state.message!)),
//         //       ],
//         //     ),
//         //     behavior: SnackBarBehavior.floating,
//         //     backgroundColor: theme.colorScheme.primary,
//         //     shape:
//         //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         //     margin: const EdgeInsets.all(16),
//         //     duration: const Duration(seconds: 3),
//         //   ),
//         // );
//       },
//       builder: (context, state) {
//         final isConnected =
//             state.connectionStatus == ConnectionStatus.connected;
//         final disabled = !isConnected || state.isBusy;
//
//         return Scaffold(
//           backgroundColor:
//               isDark ? const Color(0xFF0A0E17) : const Color(0xFFF5F7FA),
//           body: CustomScrollView(
//             slivers: [
//               // App Bar avec statut de connexion
//               SliverAppBar(
//                 expandedHeight: 80,
//                 floating: false,
//                 pinned: true,
//                 backgroundColor:
//                     isDark ? const Color(0xFF1A2332) : Colors.white,
//                 elevation: 0,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: isDark
//                             ? [const Color(0xFF1A2332), const Color(0xFF0A0E17)]
//                             : [Colors.white, const Color(0xFFF5F7FA)],
//                       ),
//                     ),
//                     child: SafeArea(
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           //mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text(
//                               'RAMPEDA',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 32,
//                                 fontWeight: FontWeight.w800,
//                                 color: isDark
//                                     ? Colors.white
//                                     : const Color(0xFF1A2332),
//                                 letterSpacing: -0.5,
//                               ),
//                             ),
//                             //const SizedBox(height: 8),
//                             const Spacer(),
//                             _buildStatusChip(isConnected, state.isBusy, isDark),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Contenu principal
//               SliverPadding(
//                 padding: const EdgeInsets.all(20),
//                 sliver: SliverList(
//                   delegate: SliverChildListDelegate([
//                     // Grille de fonctionnalités
//                     _buildFeatureGrid(context, disabled, isDark),
//                     const SizedBox(height: 24),
//
//                     // Terminal
//                     _buildTerminal(context, state, isDark),
//                     const SizedBox(height: 20),
//                     // _buildLogsSection(state.logs),
//                   ]),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildLogsSection(String logs) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Logs:',
//                 style: GoogleFonts.inter(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               SingleChildScrollView(
//                 child: SelectableText(
//                   logs.isEmpty ? 'No logs yet.' : logs,
//                   style: GoogleFonts.jetBrainsMono(
//                     color: Colors.greenAccent[100],
//                     fontSize: 13,
//                     height: 1.6,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFeatureGrid(BuildContext context, bool disabled, bool isDark) {
//     final cubit = context.read<RampedaCubit>();
//     final features = RampedaFeature.values;
//
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.zero,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//         childAspectRatio: 1.0,
//         mainAxisSpacing: 14,
//         crossAxisSpacing: 14,
//       ),
//       itemCount: features.length,
//       itemBuilder: (context, i) {
//         final feature = features[i];
//
//         VoidCallback? onTap;
//         //!disabled
//         if (disabled) {
//           switch (feature) {
//             case RampedaFeature.dateTime:
//               onTap = () => _onUpdateDate(context);
//               break;
//             case RampedaFeature.clear:
//               onTap = cubit.clearScreen;
//               break;
//             case RampedaFeature.formatSd:
//               onTap = () => _onFormatSd(context);
//               break;
//             case RampedaFeature.export:
//               onTap = () => _onExportEmail(context);
//               break;
//             case RampedaFeature.readSd:
//               onTap = cubit.loadLogs;
//               break;
//             case RampedaFeature.restart:
//               onTap = () => _onFermer(context);
//               break;
//             case RampedaFeature.config:
//               onTap = () => _openConfigSheet(context, isDark);
//               break;
//           }
//         }
//
//         return FeatureCard(
//           label: feature.label,
//           icon: feature.icon,
//           gradient: feature.gradient,
//           onTap: onTap,
//           isDark: isDark,
//         );
//       },
//     );
//   }
//
//   Widget _buildStatusChip(bool isConnected, bool isBusy, bool isDark) {
//     return AnimatedBuilder(
//       animation: _pulseAnimation,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: isConnected && !isBusy ? _pulseAnimation.value : 1.0,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               color: isConnected
//                   ? const Color(0xFF10B981).withOpacity(0.15)
//                   : const Color(0xFFEF4444).withOpacity(0.15),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: isConnected
//                     ? const Color(0xFF10B981)
//                     : const Color(0xFFEF4444),
//                 width: 1.5,
//               ),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 8,
//                   height: 8,
//                   decoration: BoxDecoration(
//                     color: isConnected
//                         ? const Color(0xFF10B981)
//                         : const Color(0xFFEF4444),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: (isConnected
//                                 ? const Color(0xFF10B981)
//                                 : const Color(0xFFEF4444))
//                             .withOpacity(0.5),
//                         blurRadius: 8,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Text(
//                   isConnected ? 'Connecté' : 'Déconnecté',
//                   style: GoogleFonts.inter(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: isConnected
//                         ? const Color(0xFF10B981)
//                         : const Color(0xFFEF4444),
//                   ),
//                 ),
//                 if (isBusy) ...[
//                   const SizedBox(width: 10),
//                   SizedBox(
//                     width: 16,
//                     height: 16,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation(
//                         isConnected
//                             ? const Color(0xFF10B981)
//                             : const Color(0xFFEF4444),
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTerminal(BuildContext context, RampedaState state, bool isDark) {
//     final hasLogs =
//         //false;
//         state.logs.isNotEmpty;
//
//     return Container(
//       constraints: const BoxConstraints(minHeight: 400, maxHeight: 600),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: isDark ? const Color(0xFF0D1117) : Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // En-tête du terminal
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//             decoration: BoxDecoration(
//               color: isDark ? const Color(0xFF161B22) : const Color(0xFFF6F8FA),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//               border: Border(
//                 bottom: BorderSide(
//                   color: isDark
//                       ? const Color(0xFF30363D)
//                       : const Color(0xFFE5E7EB),
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 _buildDot(const Color(0xFFEF4444)),
//                 _buildDot(const Color(0xFFF59E0B)),
//                 _buildDot(const Color(0xFF10B981)),
//                 const SizedBox(width: 16),
//                 Icon(
//                   Icons.terminal_rounded,
//                   size: 18,
//                   color: isDark ? Colors.white70 : Colors.black54,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Terminal',
//                   style: GoogleFonts.inter(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: isDark ? Colors.white70 : Colors.black87,
//                   ),
//                 ),
//                 const Spacer(),
//                 if (hasLogs)
//                   IconButton(
//                     icon: Icon(
//                       Icons.content_copy_rounded,
//                       size: 18,
//                       color: isDark ? Colors.white70 : Colors.black54,
//                     ),
//                     onPressed: () {
//                       Clipboard.setData(ClipboardData(text: state.logs));
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: const Row(
//                             children: [
//                               Icon(Icons.check_circle, color: Colors.white),
//                               SizedBox(width: 12),
//                               Text('Copié dans le presse-papiers'),
//                             ],
//                           ),
//                           behavior: SnackBarBehavior.floating,
//                           backgroundColor: const Color(0xFF10B981),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       );
//                     },
//                     tooltip: 'Copier',
//                   ),
//               ],
//             ),
//           ),
//
//           // Corps du terminal
//           Expanded(
//             child: hasLogs
//                 ? Container(
//                     padding: const EdgeInsets.all(20),
//                     child: SingleChildScrollView(
//                       child: SelectableText(
//                         state.logs,
//                         style: GoogleFonts.jetBrainsMono(
//                           color: isDark
//                               ? const Color(0xFF58A6FF)
//                               : const Color(0xFF0969DA),
//                           fontSize: 13,
//                           height: 1.6,
//                         ),
//                       ),
//                     ),
//                   )
//                 : Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.description_outlined,
//                           size: 64,
//                           color: isDark ? Colors.white24 : Colors.black26,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Aucun log chargé',
//                           style: GoogleFonts.inter(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: isDark ? Colors.white54 : Colors.black54,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Appuyez sur "Lire SD" pour charger',
//                           style: GoogleFonts.inter(
//                             fontSize: 13,
//                             color: isDark ? Colors.white38 : Colors.black38,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDot(Color color) {
//     return Container(
//       width: 12,
//       height: 12,
//       margin: const EdgeInsets.only(right: 8),
//       decoration: BoxDecoration(
//         color: color,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
//
//   // Actions
//   Future<void> _onUpdateDate(BuildContext context) async {
//     final cubit = context.read<RampedaCubit>();
//     final now = DateTime.now();
//
//     final date = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF8B5CF6),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (date == null) return;
//
//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(now),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF8B5CF6),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (time == null) return;
//
//     final dt =
//         DateTime(date.year, date.month, date.day, time.hour, time.minute);
//     final ok = await _confirm(
//       context,
//       'Mettre à jour la date ?',
//       'L\'appareil va redémarrer après la mise à jour.',
//       confirmText: 'Mettre à jour',
//     );
//     if (ok) await cubit.adjustTimeAndWaitRestart(dt);
//   }
//
//   Future<void> _onFormatSd(BuildContext context) async {
//     final ok = await _confirm(
//       context,
//       'Formater la carte SD ?',
//       'Attention : Tous les logs seront définitivement effacés.',
//       confirmText: 'Formater',
//       isDangerous: true,
//     );
//     if (ok) await context.read<RampedaCubit>().formatSdAndWaitRestart();
//   }
//
//   Future<void> _onFermer(BuildContext context) async {
//     final ok = await _confirm(
//       context,
//       'Redémarrer l\'appareil ?',
//       'L\'application va se fermer et l\'appareil va redémarrer.',
//       confirmText: 'Redémarrer',
//     );
//     if (ok) await context.read<RampedaCubit>().coupeWifiAndWaitRestart();
//   }
//
//   Future<void> _onExportEmail(BuildContext context) async {
//     final logs = context.read<RampedaCubit>().state.logs;
//     if (logs.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(
//             children: [
//               Icon(Icons.warning_amber_rounded, color: Colors.white),
//               SizedBox(width: 12),
//               Expanded(child: Text('Aucun log à exporter')),
//             ],
//           ),
//           backgroundColor: const Color(0xFFF59E0B),
//           behavior: SnackBarBehavior.floating,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       return;
//     }
//     await _exportLogsFile(logs);
//   }
//
//   Future<bool> _confirm(
//     BuildContext context,
//     String title,
//     String content, {
//     String confirmText = 'Confirmer',
//     bool isDangerous = false,
//   }) async {
//     return await showDialog<bool>(
//           context: context,
//           builder: (_) => AlertDialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             backgroundColor: Theme.of(context).brightness == Brightness.dark
//                 ? const Color(0xFF1A2332)
//                 : Colors.white,
//             title: Text(
//               title,
//               style: GoogleFonts.inter(
//                 fontWeight: FontWeight.w700,
//                 fontSize: 18,
//               ),
//             ),
//             content: Text(
//               content,
//               style: GoogleFonts.inter(fontSize: 14),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(_, false),
//                 child: Text(
//                   'Annuler',
//                   style: GoogleFonts.inter(fontWeight: FontWeight.w600),
//                 ),
//               ),
//               FilledButton(
//                 style: FilledButton.styleFrom(
//                   backgroundColor: isDangerous
//                       ? const Color(0xFFEF4444)
//                       : const Color(0xFF8B5CF6),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () => Navigator.pop(_, true),
//                 child: Text(
//                   confirmText,
//                   style: GoogleFonts.inter(fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }
//
//   Future<void> _exportLogsFile(String content) async {
//     final dir = await getTemporaryDirectory();
//     final file = File(
//       '${dir.path}/rampeda_logs_${DateTime.now().millisecondsSinceEpoch}.txt',
//     );
//     await file.writeAsString(content);
//
//     await Share.shareXFiles(
//       [XFile(file.path, mimeType: 'text/plain', name: 'log.txt')],
//       subject:
//           'Logs RAMPEDA - ${DateTime.now().toIso8601String().substring(0, 10)}',
//       text: 'Ci-joint les logs complets de l\'appareil RAMPEDA.',
//     );
//   }
//
//   Future<void> _openConfigSheet(BuildContext context, bool isDark) async {
//     final cubit = context.read<RampedaCubit>();
//
//     int distance = 200; // mm
//     int redMs = 5000; // ms
//     int greenMs = 5000; // ms
//
//     // Màu cho từng nhóm
//     final values = <RampedaConfigField, int>{
//       RampedaConfigField.distance: distance,
//       RampedaConfigField.redMs: redMs,
//       RampedaConfigField.greenMs: greenMs,
//     };
//
//     final controllers = <RampedaConfigField, TextEditingController>{
//       RampedaConfigField.distance:
//           TextEditingController(text: distance.toString()),
//       RampedaConfigField.redMs: TextEditingController(text: redMs.toString()),
//       RampedaConfigField.greenMs:
//           TextEditingController(text: greenMs.toString()),
//     };
//
//     final result = await showModalBottomSheet<bool>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: isDark ? const Color(0xFF0D1117) : Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (ctx) {
//         OutlineInputBorder border(Color color, {bool focused = false}) {
//           return OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(
//               color: focused ? color : color.withOpacity(0.6),
//               width: focused ? 1.8 : 1.2,
//             ),
//           );
//         }
//
//         void updateFromText(
//           RampedaConfigField field,
//           String v,
//           void Function(void Function()) setState,
//         ) {
//           final val = int.tryParse(v);
//           if (val == null) return;
//           final clamped = val.clamp(field.min, field.max);
//           setState(() => values[field] = clamped);
//           final ctrl = controllers[field]!;
//           if (clamped.toString() != v) {
//             ctrl.text = clamped.toString();
//             ctrl.selection = TextSelection.fromPosition(
//               TextPosition(offset: ctrl.text.length),
//             );
//           }
//         }
//
//         return Padding(
//           padding: EdgeInsets.only(
//             left: 20,
//             right: 20,
//             top: 16,
//             bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
//           ),
//           child: StatefulBuilder(
//             builder: (ctx, setState) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Container(
//                       width: 40,
//                       height: 4,
//                       margin: const EdgeInsets.only(bottom: 16),
//                       decoration: BoxDecoration(
//                         color: isDark
//                             ? Colors.white24
//                             : Colors.black.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(999),
//                       ),
//                     ),
//                   ),
//                   Text(
//                     'Configuration',
//                     style: GoogleFonts.inter(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       color: isDark ? Colors.white : const Color(0xFF111827),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   for (final field in RampedaConfigField.values) ...[
//                     Text(
//                       field.label,
//                       style: GoogleFonts.inter(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color:
//                             isDark ? Colors.white70 : const Color(0xFF111827),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Theme(
//                             data: Theme.of(context).copyWith(
//                               textSelectionTheme: TextSelectionThemeData(
//                                 cursorColor: field.color,
//                                 selectionColor: field.color.withOpacity(0.3),
//                                 selectionHandleColor: field.color,
//                               ),
//                             ),
//                             child: TextField(
//                               controller: controllers[field],
//                               keyboardType: TextInputType.number,
//                               cursorColor: field.color,
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.digitsOnly,
//                               ],
//                               decoration: InputDecoration(
//                                 isDense: true,
//                                 border: border(field.color),
//                                 enabledBorder: border(field.color),
//                                 focusedBorder:
//                                     border(field.color, focused: true),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 8,
//                                 ),
//                                 hintText: field.hint,
//                               ),
//                               onChanged: (v) =>
//                                   updateFromText(field, v, setState),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           field.unit,
//                           style: GoogleFonts.inter(
//                             fontSize: 13,
//                             color: isDark ? Colors.white54 : Colors.grey[700],
//                           ),
//                         ),
//                       ],
//                     ),
//                     SliderTheme(
//                       data: SliderTheme.of(ctx).copyWith(
//                         activeTrackColor: field.color,
//                         thumbColor: field.color,
//                         valueIndicatorColor: field.color,
//                       ),
//                       child: Slider(
//                         value: (values[field] ?? field.min).toDouble(),
//                         min: field.min.toDouble(),
//                         max: field.max.toDouble(),
//                         divisions: field.divisions,
//                         label: '${values[field]} ${field.unit}',
//                         onChanged: (v) {
//                           final step = field.step;
//                           final rounded =
//                               step > 1 ? ((v ~/ step) * step) : v.round();
//                           setState(() => values[field] = rounded.toInt());
//                           final ctrl = controllers[field]!;
//                           ctrl.text = values[field].toString();
//                           ctrl.selection = TextSelection.fromPosition(
//                             TextPosition(offset: ctrl.text.length),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                   ],
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextButton(
//                           onPressed: () => Navigator.pop(ctx, false),
//                           child: Text(
//                             'Annuler',
//                             style: GoogleFonts.inter(
//                               fontWeight: FontWeight.w600,
//                               color: isDark
//                                   ? Colors.white70
//                                   : const Color(0xFF6B7280),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: FilledButton(
//                           style: FilledButton.styleFrom(
//                             backgroundColor: const Color(0xFF22C55E),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                           ),
//                           onPressed: () => Navigator.pop(ctx, true),
//                           child: Text(
//                             'Enregistrer',
//                             style: GoogleFonts.inter(
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//
//     if (result == true) {
//       distance = values[RampedaConfigField.distance]!;
//       redMs = values[RampedaConfigField.redMs]!;
//       greenMs = values[RampedaConfigField.greenMs]!;
//
//       await cubit.updateConfig(
//         distance: distance,
//         redMs: redMs,
//         greenMs: greenMs,
//       );
//     }
//
//     for (final c in controllers.values) {
//       c.dispose();
//     }
//   }
// }

////////////////////////////////////////////////////////
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/enums/connection_status.dart';
import '../../domain/entities/rampeda_config.dart';
import '../cubit/rampeda_cubit.dart';
import '../cubit/rampeda_state.dart';
import '../enum/rampeda_config_field.dart';
import '../enum/rampeda_feature.dart';
import '../widgets/feature_card.dart';
import '../widgets/rampeda_status_chip.dart';
import '../widgets/rampeda_terminal.dart';

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
                expandedHeight: 80,
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.end,
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
                            //const SizedBox(height: 8),
                            const Spacer(),
                            RampedaStatusChip(
                              isConnected: isConnected,
                              isBusy: state.isBusy,
                              isDark: isDark,
                              pulseAnimation: _pulseAnimation,
                            ),
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
                    RampedaTerminal(
                      state: state,
                      isDark: isDark,
                    ),
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
    final features = RampedaFeature.values;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
      ),
      itemCount: features.length,
      itemBuilder: (context, i) {
        final feature = features[i];

        VoidCallback? onTap;
        //!disabled
        if (disabled) {
          switch (feature) {
            case RampedaFeature.dateTime:
              onTap = () => _onUpdateDate(context);
              break;
            case RampedaFeature.clear:
              onTap = cubit.clearScreen;
              break;
            case RampedaFeature.formatSd:
              onTap = () => _onFormatSd(context);
              break;
            case RampedaFeature.export:
              onTap = () => _onExportEmail(context);
              break;
            case RampedaFeature.readSd:
              onTap = cubit.loadLogs;
              break;
            case RampedaFeature.restart:
              onTap = () => _onFermer(context);
              break;
            case RampedaFeature.config:
              onTap = () => _openConfigSheet(context, isDark);
              break;
          }
        }

        return FeatureCard(
          label: feature.label,
          icon: feature.icon,
          gradient: feature.gradient,
          onTap: onTap,
          //disabled ? null : f['action'] as VoidCallback,
          isDark: isDark,
        );
      },
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
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B5CF6),
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
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B5CF6),
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

  Future<void> _openConfigSheet(BuildContext context, bool isDark) async {
    final cubit = context.read<RampedaCubit>();

    // 0) Hiển thị loading ngay khi bấm CONFIG
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      builder: (_) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
              isDark ? Colors.white : const Color(0xFF22C55E),
            ),
          ),
        );
      },
    );

    // 1) Gọi API lấy config
    late final RampedaConfig config;
    try {
      config = await cubit.loadConfig();
    } finally {
      if (mounted) {
        // đóng dialog loading
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    if (!mounted) return;

    // Nếu trả về 0 hết → coi như lỗi, dùng min để Slider không bị crash
    int distance = config.distance == 0
        ? RampedaConfigField.distance.min
        : config.distance;
    int redMs = config.redMs == 0 ? RampedaConfigField.redMs.min : config.redMs;
    int greenMs =
        config.greenMs == 0 ? RampedaConfigField.greenMs.min : config.greenMs;

    // Text hiển thị ở sheet
    final bool isError =
        config.distance == 0 && config.redMs == 0 && config.greenMs == 0;

    final String infoText = isError
        ? 'Erreur de lecture des paramètres. Valeurs minimales affichées.'
        : 'Paramètres courants lus depuis l’appareil.';

    final Color infoColor =
        isError ? const Color(0xFFEF4444) : const Color(0xFF22C55E);

    final values = <RampedaConfigField, int>{
      RampedaConfigField.distance: distance,
      RampedaConfigField.redMs: redMs,
      RampedaConfigField.greenMs: greenMs,
    };

    final controllers = <RampedaConfigField, TextEditingController>{
      RampedaConfigField.distance:
          TextEditingController(text: distance.toString()),
      RampedaConfigField.redMs: TextEditingController(text: redMs.toString()),
      RampedaConfigField.greenMs:
          TextEditingController(text: greenMs.toString()),
    };

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF0D1117) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        OutlineInputBorder border(Color color, {bool focused = false}) {
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: focused ? color : color.withOpacity(0.6),
              width: focused ? 1.8 : 1.2,
            ),
          );
        }

        void updateFromText(
          RampedaConfigField field,
          String v,
          void Function(void Function()) setState,
        ) {
          final val = int.tryParse(v);
          if (val == null) return;
          final clamped = val.clamp(field.min, field.max);
          setState(() => values[field] = clamped);
          final ctrl = controllers[field]!;
          if (clamped.toString() != v) {
            ctrl.text = clamped.toString();
            ctrl.selection = TextSelection.fromPosition(
              TextPosition(offset: ctrl.text.length),
            );
          }
        }

        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white24
                            : Colors.black.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  Text(
                    'Configuration',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Banner trạng thái đọc config
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: infoColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: infoColor.withOpacity(0.4)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isError
                              ? Icons.error_outline
                              : Icons.check_circle_outline,
                          size: 18,
                          color: infoColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            infoText,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF111827),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Các field config (text disabled, slider chỉnh)
                  for (final field in RampedaConfigField.values) ...[
                    Text(
                      field.label,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            isDark ? Colors.white70 : const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: TextSelectionThemeData(
                                cursorColor: field.color,
                                selectionColor: field.color.withOpacity(0.3),
                                selectionHandleColor: field.color,
                              ),
                            ),
                            child: TextField(
                              controller: controllers[field],
                              keyboardType: TextInputType.number,
                              cursorColor: field.color,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              enabled: false, // chỉ show text
                              decoration: InputDecoration(
                                isDense: true,
                                border: border(field.color),
                                enabledBorder: border(field.color),
                                focusedBorder:
                                    border(field.color, focused: true),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: field.hint,
                              ),
                              onChanged: (v) =>
                                  updateFromText(field, v, setState),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          field.unit,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: isDark ? Colors.white54 : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(ctx).copyWith(
                        activeTrackColor: field.color,
                        thumbColor: field.color,
                        valueIndicatorColor: field.color,
                      ),
                      child: Slider(
                        value: (values[field] ?? field.min).toDouble(),
                        min: field.min.toDouble(),
                        max: field.max.toDouble(),
                        divisions: field.divisions,
                        label: '${values[field]} ${field.unit}',
                        onChanged: (v) {
                          final step = field.step;
                          final rounded =
                              step > 1 ? ((v ~/ step) * step) : v.round();
                          setState(() => values[field] = rounded.toInt());
                          final ctrl = controllers[field]!;
                          ctrl.text = values[field].toString();
                          ctrl.selection = TextSelection.fromPosition(
                            TextPosition(offset: ctrl.text.length),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(
                            'Annuler',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF22C55E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(
                            'Enregistrer',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        );
      },
    );

    if (result == true) {
      distance = values[RampedaConfigField.distance]!;
      redMs = values[RampedaConfigField.redMs]!;
      greenMs = values[RampedaConfigField.greenMs]!;

      await cubit.updateConfig(
        distance: distance,
        redMs: redMs,
        greenMs: greenMs,
      );
    }

    for (final c in controllers.values) {
      c.dispose();
    }
  }
}
