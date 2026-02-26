import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/database/local_database.dart';
import '../core/database/sync_service.dart';
import '../core/services/report_service.dart';
import 'widgets/report_history_header.dart';
import 'widgets/report_history_tile.dart';
import 'widgets/report_history_empty_state.dart';
import '../components/confirmation_dialog.dart';

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  final LocalDatabase _localDb = LocalDatabase();
  final _supabase = Supabase.instance.client;
  final SyncService _syncService = SyncService();
  final ReportService _reportService = ReportService();

  @override
  void initState() {
    super.initState();
    _triggerSync();
  }

  Future<void> _triggerSync() async {
    await _syncService.syncOnStart();
    await _reportService.syncReports();
    if (mounted) setState(() {});
  }

  Future<List<Map<String, dynamic>>> _loadHistory() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];
    return await _localDb.getReportHistory(user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.redAccent.withOpacity(0.15),
              Colors.white,
              Colors.redAccent.withOpacity(0.05),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            ReportHistoryAppBar(onRefresh: () => _triggerSync()),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _loadHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.redAccent),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const ReportHistoryEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100, top: 8),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final report = snapshot.data![index];
                      return ReportHistoryTile(
                        report: report,
                        onViewDetails: () {},
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => ConfirmationDialog(
                              title: "Delete Report",
                              content:
                                  "Are you sure you want to delete this report record?",
                              confirmText: "Delete",
                              onConfirm: () async {
                                await _reportService.deleteReport(
                                  report['id'],
                                  report['trip_uuid'],
                                );
                                await _syncService.syncOnStart();
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
