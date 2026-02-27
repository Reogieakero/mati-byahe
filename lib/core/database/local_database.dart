library local_database;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

part 'local_database_trip.dart';
part 'local_database_report.dart';
part 'local_database_active_fare.dart';
part 'local_database_user.dart';

class LocalDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String dbPath = await getDatabasesPath();
    String pathName = join(dbPath, 'byahe.db');
    return await openDatabase(
      pathName,
      version: 21,
      onCreate: (db, version) async => await _createTables(db),
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 21) {
          await db.execute('DROP TABLE IF EXISTS users');
          await _createUsersTable(db);
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await _createUsersTable(db);

    await db.execute('''
      CREATE TABLE IF NOT EXISTS active_fare(
        email TEXT PRIMARY KEY,
        fare REAL,
        pickup TEXT,
        drop_off TEXT,
        gas_tier TEXT,
        start_time TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS trips(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT UNIQUE,
        passenger_id TEXT,
        driver_id TEXT,
        driver_name TEXT,
        email TEXT,
        pickup TEXT,
        drop_off TEXT,
        fare REAL,
        gas_tier TEXT,
        date TEXT,
        start_time TEXT,
        end_time TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    await _createReportsTable(db);
  }

  Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT UNIQUE NOT NULL,
        phone_number TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        role TEXT NOT NULL CHECK (role IN ('passenger', 'driver')),
        password_hash TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> _createReportsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS reports(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trip_uuid TEXT UNIQUE,
        passenger_id TEXT,
        driver_id TEXT,
        issue_type TEXT NOT NULL,
        description TEXT NOT NULL,
        evidence_url TEXT,
        status TEXT DEFAULT 'pending',
        reported_at TEXT NOT NULL,
        is_synced INTEGER DEFAULT 0,
        is_deleted INTEGER DEFAULT 0
      )
    ''');
  }
}
