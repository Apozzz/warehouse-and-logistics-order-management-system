import 'package:inventory_system/imports.dart';

class DataBaseService {
  Future<Database> getOnlyConnection() async {
    WidgetsFlutterBinding.ensureInitialized();
    print(await getDatabasesPath());
    final databaseConnection = await openDatabase(
      join(await getDatabasesPath(), 'test.db'),
      version: 1,
    );

    return databaseConnection;
  }

  Future<Database> getDatabaseConnection(var classObject) async {
    WidgetsFlutterBinding.ensureInitialized();
    final databaseConnection = await openDatabase(
      join(await getDatabasesPath(), 'test.db'),
      version: 1,
    );

    try {
      Sqflite.firstIntValue(await databaseConnection
              .rawQuery(classObject.getTableCheckQuery())) ??
          0;
    } catch (e) {
      await databaseConnection.rawQuery(classObject.getTableCreationString());
      print(e);
    }

    return databaseConnection;
  }

  Future<void> recreateTable(
      Database databaseConnection, var classObject) async {
    await databaseConnection.rawQuery(classObject.recreateTableQuery());
  }

  Future<void> insertRecord(
      Database databaseConnection, var classObject) async {
    await databaseConnection.insert(
      classObject.getTableName(),
      classObject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Object>> getRecords(
      Database databaseConnection, var classObject) async {
    final List<Map<String, dynamic>> maps =
        await databaseConnection.query(classObject.getTableName());

    return List.generate(maps.length, (i) {
      return classObject.createModel(maps[i]);
    });
  }

  Future<List<Map<String, Object?>>> getRecordsByIds(
    Database databaseConnection,
    var classObject,
    String? ids,
  ) async {
    if (ids == null) {
      return [{}];
    }

    var result = await databaseConnection.query(classObject.getTableName(),
        where: 'id IN($ids)');

    return result;
  }

  Future<Map<String, dynamic>> getRecord(
      Database databaseConnection, var classObject, int? id) async {
    if (id == null) {
      return {};
    }

    var result = await databaseConnection.query(classObject.getTableName(),
        columns: ['*'], where: 'id = $id');

    if (result.isEmpty) {
      return {};
    }

    return result[0];
  }

  Future<void> updateRecord(
      Database databaseConnection, var classObject) async {
    var data = classObject.toMap();

    await databaseConnection.update(
      classObject.getTableName(),
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  Future<void> deleteRecord(
      Database databaseConnection, var classObject) async {
    var id = classObject.toMap()['id'];
    await databaseConnection.delete(
      classObject.getTableName(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteSelected(
      Database databaseConnection, var classObject, List<int> ids) async {
    await databaseConnection.delete(
      classObject.getTableName(),
      where: 'id IN (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
  }

  Future<int> getHighestId(Database databaseConnection, var classObject) async {
    var result =
        await databaseConnection.rawQuery(classObject.getHighestIdQuery());

    if (result.isEmpty) {
      return 0;
    }

    return result.first.values.first as int;
  }

  

  Future<List<Map<String, dynamic>>> getRawQueryResults(
      Database databaseConnection, String rawQuery) async {
    try {
      var result = await databaseConnection.rawQuery(rawQuery);

      return result;
    } catch (e) {
      print(e);
    }

    return [];
  }
}
