import 'package:inventory_system/utils/date_utils.dart';

class TempCode {
  final String id;
  final String code;
  final String companyId;
  final String roleId;
  final DateTime expiration;

  TempCode({
    required this.id,
    required this.code,
    required this.companyId,
    required this.roleId,
    required this.expiration,
  });

  factory TempCode.fromMap(Map<String, dynamic> data, String id) {
    return TempCode(
      id: id,
      code: data['code'],
      companyId: data['companyId'],
      roleId: data['roleId'],
      expiration: CustomDateUtils.parseDate(data['expiration']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'companyId': companyId,
      'role': roleId,
      'createdAt': CustomDateUtils.formatDate(expiration),
    };
  }
}
