import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OfflineStorageService {
  static final OfflineStorageService _instance =
      OfflineStorageService._internal(); // Singleton
  OfflineStorageService._internal();
  factory OfflineStorageService() => _instance;

  Database? _db; // Instance de la base de données SQLite

  // Getter pour accéder à la base de données
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db =
        await _initDatabase(); // Initialise la base de données si elle n'existe pas
    return _db!;
  }

  // Initialise la base de données SQLite
  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath(); // Chemin de la base de données
    String path = join(
      dbPath,
      'offline_reports.db',
    ); // Nom du fichier de la base
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    ); // Crée ou ouvre la base
  }

  // Crée la table pour stocker les rapports hors ligne
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pending_reports(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        totalPompes INTEGER,
        pompesParSeconde REAL,
        objectifAtteint INTEGER, 
        pourcentageReussi REAL,
        date TEXT
      )
    ''');
  }

  // Insère un rapport dans la base de données
  Future<int> insertReport(Map<String, dynamic> report) async {
    final db = await database;
    return await db.insert('pending_reports', report);
  }

  // Récupère tous les rapports en attente
  Future<List<Map<String, dynamic>>> getReports() async {
    final db = await database;
    return await db.query('pending_reports');
  }

  // Supprime un rapport de la base de données
  Future<int> deleteReport(int id) async {
    final db = await database;
    return await db.delete('pending_reports', where: 'id = ?', whereArgs: [id]);
  }
}
