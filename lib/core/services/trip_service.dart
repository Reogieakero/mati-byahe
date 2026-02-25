import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/local_database.dart';

class TripService {
  final LocalDatabase _localDb = LocalDatabase();
  final _supabase = Supabase.instance.client;

  Future<void> syncTrips() async {
    try {
      final db = await _localDb.database;
      final List<Map<String, dynamic>> unsynced = await db.query(
        'trips',
        where: 'is_synced = ?',
        whereArgs: [0],
      );

      if (unsynced.isEmpty) return;

      for (var data in unsynced) {
        try {
          await _supabase.from('trips').insert({
            'uuid': data['uuid'],
            'passenger_id': data['passenger_id'],
            'driver_id': data['driver_id'],
            'pickup': data['pickup'],
            'drop_off': data['drop_off'],
            'calculated_fare': data['fare'],
            'gas_tier': data['gas_tier'],
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
    } catch (e) {
      print("Sync Service Error: $e");
    }
  }
}
