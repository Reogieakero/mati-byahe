part of 'local_database.dart';

extension ReportDatabase on LocalDatabase {
  Future<void> saveReport({
    required String tripUuid,
    required String passengerId,
    required String driverId,
    required String issueType,
    required String description,
    String? evidencePath,
  }) async {
    final db = await database;
    await db.insert('reports', {
      'trip_uuid': tripUuid,
      'passenger_id': passengerId,
      'driver_id': driverId,
      'issue_type': issueType,
      'description': description,
      'evidence_url': evidencePath,
      'status': 'pending',
      'reported_at': DateTime.now().toIso8601String(),
      'is_synced': 0,
      'is_deleted': 0,
      'is_unreported': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getReportHistory(
    String passengerId,
  ) async {
    final db = await database;
    return await db.query(
      'reports',
      where: 'passenger_id = ? AND is_deleted = 0 AND is_unreported = 0',
      whereArgs: [passengerId],
      orderBy: 'id DESC',
    );
  }

  Future<int> deleteReportPermanently(int id) async {
    final db = await database;
    return await db.delete('reports', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markReportAsDeleted(int id) async {
    final db = await database;
    await db.update(
      'reports',
      {'is_deleted': 1, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markAsUnreported(int id) async {
    final db = await database;
    await db.update(
      'reports',
      {'is_unreported': 1, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllReports() async {
    final db = await database;
    await db.delete('reports');
  }

  Future<bool> isTripReported(String tripUuid) async {
    final db = await database;
    final result = await db.query(
      'reports',
      where: 'trip_uuid = ? AND is_unreported = 0 AND is_deleted = 0',
      whereArgs: [tripUuid],
    );
    return result.isNotEmpty;
  }
}
