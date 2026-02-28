import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/local_database.dart';
import '../models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class AuthService {
  final LocalDatabase _localDb = LocalDatabase();
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserModel?> login(String email, String password) async {
    try {
      final AuthResponse res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        final String role = res.user!.userMetadata?['role'] ?? 'passenger';

        final profileData = await _supabase
            .from('profiles')
            .select('login_pin, full_name, phone_number')
            .eq('id', res.user!.id)
            .maybeSingle();

        final db = await _localDb.database;
        await db.insert('users', {
          'id': res.user!.id,
          'email': email,
          'password': password,
          'full_name': profileData?['full_name'],
          'phone_number': profileData?['phone_number'],
          'role': role,
          'login_pin': profileData?['login_pin'],
          'is_verified': 1,
          'is_synced': 1,
        }, conflictAlgorithm: ConflictAlgorithm.replace);

        return UserModel(email: email, role: role);
      }
    } on AuthException catch (e) {
      return await _attemptLocalLogin(email, password);
    } catch (e) {
      return await _attemptLocalLogin(email, password);
    }
    return null;
  }

  Future<UserModel?> _attemptLocalLogin(String email, String password) async {
    final db = await _localDb.database;
    final List<Map<String, dynamic>> localUsers = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (localUsers.isNotEmpty) {
      return UserModel.fromMap(localUsers.first);
    }
    return null;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<bool> verifyLocalPin(String userId, String inputPin) async {
    final db = await _localDb.database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['login_pin'],
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty && result.first['login_pin'] != null) {
      return result.first['login_pin'] == inputPin;
    }
    return false;
  }
}
