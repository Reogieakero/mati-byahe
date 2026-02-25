import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/local_database.dart';

class SyncService {
  final LocalDatabase _localDb = LocalDatabase();
  final _supabase = Supabase.instance.client;

  Future<void> syncOnStart() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) return;

      final db = await _localDb.database;
      final List<Map<String, dynamic>> unsynced = await db.query(
        'trips',
        where: 'is_synced = ?',
        whereArgs: [0],
      );

      for (var data in unsynced) {
        try {
          await _supabase.from('trips').insert({
            'uuid': data['uuid'],
            'passenger_id': data['passenger_id'],
            'driver_id': data['driver_id'],
            'driver_name':
                data['driver_name'], // Make sure to add this column to Supabase!
            'pickup': data['pickup'],
            'drop_off': data['drop_off'],
            'calculated_fare': data['fare'],
            'gas_tier': data['gas_tier'],
            'start_datetime': data['start_time'],
            'end_datetime': data['end_time'],
            'created_at': data['date'],
            'status': 'completed',
          });

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
    } catch (_) {}
  }
}
