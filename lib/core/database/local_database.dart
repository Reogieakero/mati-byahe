import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

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
      version: 12,
      onCreate: (db, version) async => await _createTables(db),
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 12) {
          await db.execute('DROP TABLE IF EXISTS active_fare');
          await db.execute('DROP TABLE IF EXISTS trips');
          await _createTables(db);
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE,
        password TEXT,
        role TEXT,
        is_verified INTEGER DEFAULT 0,
        is_synced INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS active_fare(
        email TEXT PRIMARY KEY,
        fare REAL,
        pickup TEXT,
        drop_off TEXT,
        gas_tier TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS trips(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT UNIQUE,
        passenger_id TEXT,
        driver_id TEXT,
        email TEXT,
        pickup TEXT,
        drop_off TEXT,
        fare REAL,
        gas_tier TEXT,
        date TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> saveTrip({
    required String email,
    required String pickup,
    required String dropOff,
    required double fare,
    required String gasTier,
    String? passengerId,
    String? driverId,
  }) async {
    final db = await database;
    await db.insert('trips', {
      'uuid': const Uuid().v4(),
      'passenger_id': passengerId,
      'driver_id': driverId,
      'email': email,
      'pickup': pickup,
      'drop_off': dropOff,
      'fare': fare,
      'gas_tier': gasTier,
      'date': DateTime.now().toIso8601String(),
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

  Future<void> saveActiveFare({
    required String email,
    required double fare,
    required String pickup,
    required String dropOff,
    required String gasTier,
  }) async {
    final db = await database;
    await db.insert('active_fare', {
      'email': email,
      'fare': fare,
      'pickup': pickup,
      'drop_off': dropOff,
      'gas_tier': gasTier,
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
