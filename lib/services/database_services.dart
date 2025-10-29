import 'package:athenex/model/product.dart';
import 'package:athenex/model/category.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _inventoryTableName = "inventory";
  final String _categoryTableName = "categories";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _getDatabase();
    return _db!;
  }

  Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "master_db.db");

    return await openDatabase(
      path,
      version: 2, // 👈 bump version to trigger onUpgrade or re-run
      onCreate: (db, version) async {
        // Create products table
        await db.execute('''
          CREATE TABLE $_inventoryTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            price REAL NOT NULL,
            quantity INTEGER NOT NULL,
            category TEXT NOT NULL,
            description TEXT NOT NULL,
            image_paths TEXT
          )
        ''');

        // Create categories table
        await db.execute('''      
          CREATE TABLE $_categoryTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            icon TEXT,
            custom INTEGER DEFAULT 0
          )
        ''');


      },

      onUpgrade: (db, oldVersion, newVersion) async {
        // Optional: migrate data or recreate tables
        print('🔄 Upgrading database from v$oldVersion to v$newVersion');
      },
    );
  }

  /// PRODUCT CRUD

  Future<int> addProduct(Product product) async {
    final db = await database;
    return await db.insert(
      _inventoryTableName,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final data = await db.query(_inventoryTableName);
    return data.map((map) => Product.fromMap(map)).toList();
  }

  Future<Product> getProductById(int id) async {
    final db = await database;
    final data = await db.query(
      _inventoryTableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return Product.fromMap(data.first);

    // if (data.isNotEmpty) {
    // } else {
    //   return null;
    // }
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      _inventoryTableName,
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      _inventoryTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Product>> searchProducts(String query) async {
    final db = await database;
    final data = await db.query(
      _inventoryTableName,
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
    return data.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<Product>> filterByCategory(String category) async {
    final db = await database;
    final data = await db.query(
      _inventoryTableName,
      where: 'category = ?',
      whereArgs: [category],
    );
    return data.map((map) => Product.fromMap(map)).toList();
  }

  /// CATEGORY CRUD

  Future<int> addCategory(Category category) async {
    final db = await database;
    print('added ${category.name}');
    return await db.insert(
      _categoryTableName,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final data = await db.query(_categoryTableName);
    return data.map((map) => Category.fromMap(map)).toList();
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      _categoryTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> seedDefaultCategories(List<Category> defaultCategories) async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_categoryTableName'),
    );

    if (count == 0) {
      for (final category in defaultCategories) {
        await db.insert(
          _categoryTableName,
          category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      print('✅ Default categories inserted');
    } else {
      print('ℹ️ Categories already exist ($count found)');
    }
  }

}
