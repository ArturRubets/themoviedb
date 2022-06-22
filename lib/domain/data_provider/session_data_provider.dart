import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const sessionId = 'session_id';
  static const accountId = 'account_id';
}

class SessionDataProvider {
  static const _secureStorage = FlutterSecureStorage();

  Future<String?> get sessionId => _secureStorage.read(key: _Keys.sessionId);

  Future<int?> get accountId async {
    final accountId = await _secureStorage.read(key: _Keys.accountId);
    return accountId == null ? null : int.tryParse(accountId);
  }

  Future<void> setSessionId({required String sessionId}) async =>
      await _secureStorage.write(key: _Keys.sessionId, value: sessionId);

  Future<void> deleteSessionId() async =>
      await _secureStorage.delete(key: _Keys.sessionId);

  Future<void> setAccountId({required int accountId}) async =>
      await _secureStorage.write(
          key: _Keys.accountId, value: accountId.toString());

  Future<void> deleteAccountId() async =>
      await _secureStorage.delete(key: _Keys.accountId);
}
