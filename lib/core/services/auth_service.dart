import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/local_database.dart';
import '../database/local_database_user.dart'; // Import for extension methods
import '../models/user_model.dart';

class AuthService {
  final LocalDatabase _localDb = LocalDatabase();
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> saveUserLocally(Map<String, dynamic> userData) async {
    final db = await _localDb.database;
    await db.insert('users', {
      'uuid': userData['id'],
      'phone_number':
          userData['phone_number'] ??
          userData['user_metadata']?['phone_number'] ??
          '',
      'name': userData['name'] ?? userData['user_metadata']?['full_name'] ?? '',
      'email': userData['email'],
      'role':
          userData['role'] ?? userData['user_metadata']?['role'] ?? 'passenger',
      'password_hash': 'stored_remotely',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'is_synced': 1,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      final AuthResponse res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        final userData = {
          'id': res.user!.id,
          'email': res.user!.email,
          'phone_number': res.user!.userMetadata?['phone_number'],
          'name': res.user!.userMetadata?['full_name'],
          'role': res.user!.userMetadata?['role'] ?? 'passenger',
        };

        await saveUserLocally(userData);
        return UserModel(email: email, role: userData['role'] as String);
      }
    } catch (e) {
      return await _attemptLocalLogin(email, password);
    }
    return null;
  }

  Future<UserModel?> _attemptLocalLogin(String email, String password) async {
    final db = await _localDb.database;
    final List<Map<String, dynamic>> localUsers = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (localUsers.isNotEmpty) {
      return UserModel.fromMap(localUsers.first);
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      // Optional: If you want to clear local user data on logout, uncomment below:
      // final db = await _localDb.database;
      // await db.delete('users');
    } catch (e) {
      print("Error during sign out: $e");
    }
  }
}
