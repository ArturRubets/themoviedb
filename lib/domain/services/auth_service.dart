import '../api_client/account_api_client.dart';
import '../api_client/api_client_exception.dart';
import '../api_client/auth_api_client.dart';
import '../data_provider/session_data_provider.dart';

class AuthService {
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();
  final _authApiClient = AuthApiClient();

  Future<bool> isAuth() async {
    final sessionId = await _sessionDataProvider.sessionId;
    final isAuth = sessionId != null;
    return isAuth;
  }

  Future<void> login(String login, String password) async {
    final sessionId = await _authApiClient.auth(
      username: login,
      password: password,
    );
    if (sessionId == null) {
      throw const ApiClientException(type: ApiClientExceptionType.other);
    }

    final accountId = await _accountApiClient.getAccountId(sessionId);
    if (accountId == null) {
      throw const ApiClientException(type: ApiClientExceptionType.other);
    }

    await addSession(sessionId, accountId);
  }

  Future<void> addSession(String sessionId, int accountId) async {
    await _sessionDataProvider.setSessionId(sessionId: sessionId);
    await _sessionDataProvider.setAccountId(accountId: accountId);
  }
}
