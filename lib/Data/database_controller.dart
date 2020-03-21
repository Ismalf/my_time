import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';


class DSDatabaseHelper {
  static final DSDatabaseHelper _instance = new DSDatabaseHelper._();

  static DSDatabaseHelper get instance => _instance;

  Completer<Database> _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = Completer();
      initDb();
    }
    return _db.future;
  }

  DSDatabaseHelper._();

  /// Initialize db using semblast nosql db
  Future initDb() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, 'dailySets.db');
    final dbtmp = await databaseFactoryIo.openDatabase(dbPath);
    _db.complete(dbtmp);
  }  
}