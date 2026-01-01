// Placeholder DB helper - will implement SQLite/Hive later
class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  Future<void> init() async {
    // initialize DB (sqflite or hive) here
  }
}
