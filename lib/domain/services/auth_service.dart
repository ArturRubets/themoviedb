import '../data_provider/session_data_provider.dart';

class AuthService {
  final _sessionDataProvider = SessionDataProvider();

  Future<bool> isAuth() async {
    final sessionId = await _sessionDataProvider.sessionId;
    final isAuth = sessionId != null;
    return isAuth;
  }
}
