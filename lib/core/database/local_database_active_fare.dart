part of 'local_database.dart';

// Active fare related operations.
extension ActiveFareDatabase on LocalDatabase {
  Future<void> saveActiveFare({
    required String email,
    required double fare,
    required String pickup,
    required String dropOff,
    required String gasTier,
    required String startTime,
  }) async {
    final db = await database;
    await db.insert('active_fare', {
      'email': email,
      'fare': fare,
      'pickup': pickup,
      'drop_off': dropOff,
      'gas_tier': gasTier,
      'start_time': startTime,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getActiveFare(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'active_fare',
      where: 'email = ?',
      whereArgs: [email],
    );
    return maps.isNotEmpty ? maps.first : null;
  }

  Future<void> clearActiveFare(String email) async {
    final db = await database;
    await db.delete('active_fare', where: 'email = ?', whereArgs: [email]);
  }
}
