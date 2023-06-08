import 'package:inventory_system/imports.dart';

class ImportExportProvider {
  Future<void> importDatabase(
      String filepath, ImportExportPageWidgetState page) async {
    page.controlOperation(true);

    var fields;
    File f = File(filepath);
    final input = f.openRead();
    fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();

    var dbService = DataBaseService();
    var connection = await dbService.getOnlyConnection();

    fields = fields[0].map<String>((e) => e.toString()).toList();

    print(fields);
    await deleteDatabase(connection.path);
    connection = await dbService.getOnlyConnection();
    await dbImportSql(connection, fields);

    page.controlOperation(false);
  }

  Future<void> exportDatabase(ImportExportPageWidgetState page) async {
    page.controlOperation(true);

    var dbService = DataBaseService();
    var connection = await dbService
        .getDatabaseConnection(ProductProvider().getProductInstance());
    var export = await dbExportSql(connection);
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];

    for (int i = 0; i < export.length; i++) {
      row.add(export[i]);
    }

    rows.add(row);

    var csv = const ListToCsvConverter().convert(rows);

    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    if (directory == null) {
      return;
    }

    final appDocPath = directory.path;
    final filePath =
        '$appDocPath/database_export_${DateTime.now().toString()}.csv';
    File file = File('');

    if (Platform.isAndroid) {
      var status = await Permission.storage.status;

      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }

      if (status.isGranted) {
        file = File(filePath);
      }
    } else {
      file = File(filePath);
    }

    if (File(filePath).existsSync()) {
      File(filePath).deleteSync();
    }

    if (file.path == '') {
      page.controlOperation(false);

      return;
    }

    print('Save as file ${filePath} ...');
    await file.writeAsString(csv);
    print('Open as file ${filePath} ...');
    await OpenFile.open(
      filePath,
      type: 'text/csv',
      uti: 'public.comma-separated-values-text',
    );

    var notifyProvider = NotifyProvider();
    await notifyProvider.init(notificationDatabaseImage);
    notifyProvider.requestIOSPermissions();
    await notifyProvider.scheduleNotifications(
      'Database Export',
      'Database has been exported!',
    );

    await NotificationProvider().saveNotification(
      'Database Export',
      'Database has been exported!',
      databaseImage,
    );

    page.controlOperation(false);
  }
}
