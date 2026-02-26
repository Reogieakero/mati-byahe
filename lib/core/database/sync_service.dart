import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/local_database.dart';

class SyncService {
  final LocalDatabase _localDb = LocalDatabase();
  final _supabase = Supabase.instance.client;

  Future<void> syncOnStart() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      if (result.isEmpty || result[0].rawAddress.isEmpty) return;

      final db = await _localDb.database;

      await _syncTrips(db);
      await _syncReports(db);
      await _syncDeletedReports(db);
    } catch (e) {
      print("Sync error: $e");
    }
  }

  Future<void> _syncTrips(db) async {
    final List<Map<String, dynamic>> unsynced = await db.query(
      'trips',
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    for (var data in unsynced) {
      try {
        await _supabase.from('trips').upsert({
          'uuid': data['uuid'],
          'passenger_id': data['passenger_id'],
          'driver_id': data['driver_id'],
          'driver_name': data['driver_name'],
          'pickup': data['pickup'],
          'drop_off': data['drop_off'],
          'calculated_fare': data['fare'],
          'gas_tier': data['gas_tier'],
          'start_datetime': data['start_time'],
          'end_datetime': data['end_time'],
          'created_at': data['date'],
          'status': 'completed',
        }, onConflict: 'uuid');

        await db.update(
          'trips',
          {'is_synced': 1},
          where: 'id = ?',
          whereArgs: [data['id']],
        );
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> _syncReports(db) async {
    final List<Map<String, dynamic>> unsyncedReports = await db.query(
      'reports',
      where: 'is_synced = ? AND is_deleted = 0',
      whereArgs: [0],
    );

    for (var data in unsyncedReports) {
      try {
        String? finalMediaUrl = data['evidence_url'];

        if (finalMediaUrl != null &&
            finalMediaUrl.isNotEmpty &&
            !finalMediaUrl.startsWith('http')) {
          final file = File(finalMediaUrl);
          if (await file.exists()) {
            final extension = finalMediaUrl.split('.').last;
            final fileName =
                'report_${DateTime.now().millisecondsSinceEpoch}.$extension';
            await _supabase.storage
                .from('report-evidence')
                .upload(fileName, file);
            finalMediaUrl = _supabase.storage
                .from('report-evidence')
                .getPublicUrl(fileName);
          }
        }

        final tripData = await _supabase
            .from('trips')
            .select('id')
            .eq('uuid', data['trip_uuid'])
            .single();

        await _supabase.from('reports').upsert({
          'trip_id': tripData['id'],
          'trip_uuid': data['trip_uuid'],
          'passenger_id': data['passenger_id'],
          'issue_type': data['issue_type'],
          'description': data['description'],
          'evidence_url': finalMediaUrl,
          'status': data['status'],
          'reported_at': data['reported_at'],
        }, onConflict: 'trip_uuid');

        await db.update(
          'reports',
          {'is_synced': 1},
          where: 'id = ?',
          whereArgs: [data['id']],
        );
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> _syncDeletedReports(db) async {
    final List<Map<String, dynamic>> deletedReports = await db.query(
      'reports',
      where: 'is_deleted = ?',
      whereArgs: [1],
    );

    for (var data in deletedReports) {
      try {
        await _supabase
            .from('reports')
            .delete()
            .eq('trip_uuid', data['trip_uuid']);
        await _localDb.deleteReportPermanently(data['id']);
      } catch (e) {
        continue;
      }
    }
  }
}
