part of 'local_database.dart';

extension TripDatabase on LocalDatabase {
  Future<void> saveTrip({
    required String email,
    required String pickup,
    required String dropOff,
    required double fare,
    required String gasTier,
    String? passengerId,
    String? driverId,
    String? driverName,
    String? startTime,
    String? endTime,
  }) async {
    final db = await database;
    await db.insert('trips', {
      'uuid': const Uuid().v4(),
      'passenger_id': passengerId,
      'driver_id': driverId,
      'driver_name': driverName,
      'email': email,
      'pickup': pickup,
      'drop_off': dropOff,
      'fare': fare,
      'gas_tier': gasTier,
      'date': DateTime.now().toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'is_synced': 0,
    });
  }

  Future<List<Map<String, dynamic>>> getTrips(String email) async {
    final db = await database;
    return await db.query(
      'trips',
      where: 'email = ?',
      whereArgs: [email],
      orderBy: 'date DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getTripsByPassengerId(
    String passengerId,
  ) async {
    final db = await database;
    return await db.query(
      'trips',
      where: 'passenger_id = ?',
      whereArgs: [passengerId],
      orderBy: 'date DESC',
    );
  }

  Future<int> deleteTrip(String uuid) async {
    final db = await database;
    return await db.delete('trips', where: 'uuid = ?', whereArgs: [uuid]);
  }
}
