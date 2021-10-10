import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/item_model.dart';
import 'repository.dart';
import 'package:http/http.dart';
import 'dart:convert';

class NewsDbProvider implements NewsSource, NewsCache {
  Database? db;

  NewsDbProvider() {
    init();
  }

  void init() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items.db");

    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute('''
        CREATE TABLE Items
        (
          id INTEGER PRIMARY KEY,
          type TEXT,
          by TEXT,
          time INTEGER,
          text TEXT,
          parent INTEGER,
          kids BLOB,
          url TEXT,
          score INTEGER,
          dead INTEGER,
          deleted INTEGER,
          title TEXT,
          descendants INTEGER
        );
        ''');
    });
  }

  @override
  Future<ItemModel?> fetchItem(int id) async {
    final item = await db?.query(
      'Items',
      columns: null,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (item!.isNotEmpty) {
      return ItemModel.fromDb(item.first);
    }
    return null;
  }

  @override
  Future<List<int>> fetchTopIds() =>
      jsonDecode(Response([1, 2, 3, 4].toString(), 200).body);

  @override
  Future<int> addItem(ItemModel item) {
    return db!.insert('Items', item.toDbMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> clear() {
    return db!.delete("Items");
  }
}

final newsDbProvider = NewsDbProvider();
