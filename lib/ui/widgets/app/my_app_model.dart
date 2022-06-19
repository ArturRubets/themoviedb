import 'package:themoviedb/domain/data_provider/session_data_provider.dart';

class MyAppModel {
  final _sessionDataProvider = SessionDataProvider();
  bool isAuth = false;


  Future<void> checkSession() async {
    final sessionId = await _sessionDataProvider.sessionId;
    isAuth = sessionId != null;
  }
}
