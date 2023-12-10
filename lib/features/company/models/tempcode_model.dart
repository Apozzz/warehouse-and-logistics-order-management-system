import 'package:cloud_firestore/cloud_firestore.dart';
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
    final expiration = data['expiration'] is Timestamp
        ? (data['expiration'] as Timestamp).toDate()
        : DateTime.now();

    return TempCode(
      id: id,
      code: data['code'] ?? '',
      companyId: data['companyId'] ?? '',
      roleId: data['roleId'] ?? '',
      expiration: expiration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'companyId': companyId,
      'roleId': roleId,
      'expiration': expiration,
    };
  }
}
