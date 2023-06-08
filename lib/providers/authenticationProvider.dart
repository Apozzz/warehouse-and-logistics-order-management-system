import 'package:inventory_system/imports.dart';

class AuthenticationProvider {
  DataBaseService dbService = DataBaseService();
  Authentication authentication = Authentication(
    '',
    id: 0,
    status: 0,
    code: '',
  );

  AuthenticationProvider();

  Authentication getInstance() {
    return authentication;
  }

  Future<bool> isAuthenticationSet() async {
    var connection = await dbService.getDatabaseConnection(authentication);
    var authenticationRecords =
        await dbService.getRecords(connection, authentication);

    if (authenticationRecords.isEmpty) {
      return false;
    }

    return authenticationRecords.cast<Authentication>().first.status == 1
        ? true
        : false;
  }

  Future<String> getAuthenticationPin() async {
    var connection = await dbService.getDatabaseConnection(authentication);
    var authenticationRecords =
        await dbService.getRecords(connection, authentication);

    if (authenticationRecords.isEmpty) {
      return '';
    }

    return authenticationRecords.cast<Authentication>().first.code;
  }
}
