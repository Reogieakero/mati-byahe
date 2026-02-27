part of 'local_database.dart';

extension LocalDatabaseUser on LocalDatabase {
  Future<int> insertUser(Map<String, dynamic> userData) async {
    final db = await database;
    return await db.insert('users', {
      'uuid': userData['uuid'],
      'phone_number': userData['phone_number'],
      'name': userData['name'],
      'email': userData['email'],
      'role': userData['role'],
      'password_hash': userData['password_hash'] ?? 'remote_auth',
      'created_at': userData['created_at'] ?? DateTime.now().toIso8601String(),
      'updated_at': userData['updated_at'] ?? DateTime.now().toIso8601String(),
      'is_synced': userData['is_synced'] ?? 1,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateUserProfile(
    String uuid,
    Map<String, dynamic> updates,
  ) async {
    final db = await database;
    return await db.update(
      'users',
      {
        ...updates,
        'updated_at': DateTime.now().toIso8601String(),
        'is_synced': 0,
      },
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
  }

  Future<void> deleteUser(String uuid) async {
    final db = await database;
    await db.delete('users', where: 'uuid = ?', whereArgs: [uuid]);
  }
}
