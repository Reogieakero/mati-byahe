import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite/sqflite.dart';
import '../database/local_database.dart';

class ReportService {
  final LocalDatabase _localDb = LocalDatabase();
  final _supabase = Supabase.instance.client;

  Future<void> syncReports() async {
    try {
      final db = await _localDb.database;
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      final cloudReports = await _supabase
          .from('reports')
          .select()
          .eq('passenger_id', currentUser.id);

      for (var cloudData in cloudReports) {
        await db.insert('reports', {
          'trip_uuid': cloudData['trip_uuid'],
          'passenger_id': cloudData['passenger_id'],
          'issue_type': cloudData['issue_type'],
          'description': cloudData['description'],
          'evidence_url': cloudData['evidence_url'],
          'status': cloudData['status'],
          'reported_at': cloudData['reported_at'],
          'is_synced': 1,
          'is_deleted': 0,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    } catch (e) {
      print("Report Sync Error: $e");
    }
  }

  Future<void> deleteReport(int localId, String tripUuid) async {
    try {
      await _supabase.from('reports').delete().eq('trip_uuid', tripUuid);
      await _localDb.deleteReportPermanently(localId);
    } catch (e) {
      await _localDb.markReportAsDeleted(localId);
    }
  }
}
