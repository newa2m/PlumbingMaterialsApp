import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._();
  AppDatabase._();
  Database? _db;
  Future<Database> get database async => _db ??= await openDatabase(join(await getDatabasesPath(), 'plumbing_takeoff.db'), version: 1, onCreate: (db, _) async {
    await db.execute('CREATE TABLE projects (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, client TEXT NOT NULL DEFAULT "", address TEXT NOT NULL DEFAULT "", phone TEXT NOT NULL DEFAULT "", revision INTEGER NOT NULL DEFAULT 0, approved_revision INTEGER NOT NULL DEFAULT -1, approved_at TEXT)');
    await db.execute('CREATE TABLE places (id INTEGER PRIMARY KEY AUTOINCREMENT, project_id INTEGER NOT NULL, name TEXT NOT NULL, UNIQUE(project_id, name))');
    await db.execute('CREATE TABLE materials (id INTEGER PRIMARY KEY AUTOINCREMENT, project_id INTEGER NOT NULL, place_id INTEGER NOT NULL, name TEXT NOT NULL, spec TEXT NOT NULL, unit TEXT NOT NULL, quantity REAL NOT NULL, notes TEXT NOT NULL DEFAULT "")');
    await db.execute('CREATE TABLE catalog (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, spec TEXT NOT NULL, unit TEXT NOT NULL, UNIQUE(name, spec, unit))');
    for (final row in [['ماسورة PPR','25 مم','متر'],['كوع PPR 90°','25 مم','قطعة'],['محبس زاوية','½ بوصة','قطعة']]) { await db.insert('catalog', {'name': row[0], 'spec': row[1], 'unit': row[2]}); }
  });

  Future<int> createProject(Project p) async => (await database).insert('projects', {'name': p.name, 'client': p.client, 'address': p.address, 'phone': p.phone});
  Future<List<Project>> projects() async => (await database).query('projects', orderBy: 'id DESC').then((rows) => rows.map((r) => Project(id: r['id'] as int, name: r['name'] as String, client: r['client'] as String, address: r['address'] as String, phone: r['phone'] as String)).toList());
  Future<int> addPlace(Place p) async => (await database).insert('places', {'project_id': p.projectId, 'name': p.name});
  Future<List<Place>> places(int projectId) async => (await database).query('places', where: 'project_id=?', whereArgs: [projectId]).then((rows) => rows.map((r) => Place(id: r['id'] as int, projectId: projectId, name: r['name'] as String)).toList());
  Future<int> addMaterial(MaterialItem m) async => (await database).insert('materials', {'project_id': m.projectId, 'place_id': m.placeId, 'name': m.name, 'spec': m.spec, 'unit': m.unit, 'quantity': m.quantity, 'notes': m.notes});
  Future<List<MaterialItem>> materials(int projectId) async => (await database).query('materials', where: 'project_id=?', whereArgs: [projectId]).then((rows) => rows.map((r) => MaterialItem(id: r['id'] as int, projectId: projectId, placeId: r['place_id'] as int, name: r['name'] as String, spec: r['spec'] as String, unit: r['unit'] as String, quantity: (r['quantity'] as num).toDouble(), notes: r['notes'] as String)).toList());
  Future<void> touchProject(int id) async => (await database).rawUpdate('UPDATE projects SET revision=revision+1, approved_revision=-1, approved_at=NULL WHERE id=?', [id]);
  Future<void> approveProject(int id) async => (await database).rawUpdate('UPDATE projects SET approved_revision=revision, approved_at=? WHERE id=?', [DateTime.now().toIso8601String(), id]);
}
