String databaseName = getDate() ;


const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
const String textType = 'TEXT NOT NULL';
const String boolType = 'BOOLEAN NOT NULL';
const String intType = 'INTEGER NOT NULL';

// get date of today
String getDate() {
  DateTime now = DateTime.now();
  return '${now.day}/${now.month}/${now.year}.db';
}
