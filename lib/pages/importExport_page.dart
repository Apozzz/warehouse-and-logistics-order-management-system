import 'package:inventory_system/imports.dart';
import 'package:flutter/foundation.dart';

class ImportExportPage extends StatelessWidget {
  const ImportExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Import Export'),
            centerTitle: true,
            backgroundColor: Colors.black,
          ),
          drawer: const NavigationWidget(mainWidget: ''),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: const CustomTabBar(selectedIndex: 3),
          ),
          body: ImportExportPageWidget(),
        ),
      ),
    );
  }
}

class ImportExportPageWidget extends StatefulWidget {
  @override
  ImportExportPageWidgetState createState() => ImportExportPageWidgetState();
}

class ImportExportPageWidgetState extends State<ImportExportPageWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _dialogTitleController = TextEditingController();
  final _initialDirectoryController = TextEditingController();
  final _fileExtensionController = TextEditingController();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool operating = false;

  @override
  void initState() {
    super.initState();
    _fileExtensionController.addListener(() => _extension = 'csv');
  }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        dialogTitle: _dialogTitleController.text,
        initialDirectory: _initialDirectoryController.text,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }

  void _clearCachedFiles() async {
    _resetState();
    try {
      bool? result = await FilePicker.platform.clearTemporaryFiles();
      _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            (result!
                ? 'Temporary files removed with success.'
                : 'Failed to clean temporary files'),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> exportDatabase() async {
    await ImportExportProvider().exportDatabase(this);
  }

  Future<void> importDatabase() async {
    String filepath;

    if (_paths == null) {
      _logException('File must be selected');

      return;
    }

    filepath = _paths!.first.path.toString();
    await ImportExportProvider().importDatabase(filepath, this);
    _clearCachedFiles();
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void controlOperation(bool operating) {
    setState(() {
      this.operating = operating;
    });
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return operating
        ? Center(
            child: CircularProgressIndicatorWithText('Operation In Progress'),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: _scaffoldMessengerKey,
            themeMode: ThemeMode.dark,
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              snackBarTheme: const SnackBarThemeData(
                backgroundColor: Colors.deepPurple,
              ),
            ),
            home: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: const Text('File Picker example app'),
              ),
              body: Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 20.0,
                      ),
                      const Text(
                        'Actions',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: <Widget>[
                            SizedBox(
                              width: 120,
                              child: FloatingActionButton.extended(
                                  heroTag: 'pickFile',
                                  onPressed: () => _pickFiles(),
                                  label: const Text('Pick File'),
                                  icon: const Icon(Icons.description)),
                            ),
                            SizedBox(
                              width: 200,
                              child: FloatingActionButton.extended(
                                heroTag: 'clearCachedFiles',
                                onPressed: () => _clearCachedFiles(),
                                label: const Text('Clear Selected File'),
                                icon: const Icon(Icons.delete_forever),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const Text(
                        'File Picker Result',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Builder(
                        builder: (BuildContext context) => _isLoading
                            ? Row(
                                children: const [
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 40.0,
                                        ),
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : _userAborted
                                ? Row(
                                    children: const [
                                      Expanded(
                                        child: Center(
                                          child: SizedBox(
                                            width: 300,
                                            child: ListTile(
                                              leading: Icon(
                                                Icons.error_outline,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 40.0),
                                              title: Text(
                                                'User has aborted the dialog',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : _directoryPath != null
                                    ? ListTile(
                                        title: const Text('Directory path'),
                                        subtitle: Text(_directoryPath!),
                                      )
                                    : _paths != null
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 20.0,
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.25,
                                            child: Scrollbar(
                                                child: ListView.separated(
                                              itemCount: _paths != null &&
                                                      _paths!.isNotEmpty
                                                  ? _paths!.length
                                                  : 1,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final bool isMultiPath =
                                                    _paths != null &&
                                                        _paths!.isNotEmpty;
                                                final String name =
                                                    'File: ${isMultiPath ? _paths!.map((e) => e.name).toList()[index] : _fileName ?? '...'}';
                                                final path = kIsWeb
                                                    ? null
                                                    : _paths!
                                                        .map((e) => e.path)
                                                        .toList()[index]
                                                        .toString();

                                                return ListTile(
                                                  title: Text(
                                                    name,
                                                  ),
                                                  subtitle: Text(path ?? ''),
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const Divider(),
                                            )),
                                          )
                                        : _saveAsFileName != null
                                            ? ListTile(
                                                title: const Text('Save file'),
                                                subtitle:
                                                    Text(_saveAsFileName!),
                                              )
                                            : const SizedBox(),
                      ),
                      const Divider(),
                      Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: [
                          Wrap(
                            children: [
                              FloatingActionButton.extended(
                                heroTag: 'importCsv',
                                onPressed: () => importDatabase(),
                                label: const Text('Import To Database'),
                                icon: const Icon(Icons.save_alt),
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              FloatingActionButton.extended(
                                heroTag: 'exportCsv',
                                onPressed: () => exportDatabase(),
                                label: const Text('Export From Database'),
                                icon: const Icon(Icons.download_outlined),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
