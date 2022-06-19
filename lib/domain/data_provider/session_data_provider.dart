import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const sessionId = 'session_id';
}

class SessionDataProvider {
  static const _secureStorage = FlutterSecureStorage();

  Future<String?> get sessionId => _secureStorage.read(key: _Keys.sessionId);

  Future<void> set({required String sessionId}) async =>
      await _secureStorage.write(key: _Keys.sessionId, value: sessionId);

  Future<void> delete() async =>
      await _secureStorage.delete(key: _Keys.sessionId);
}
