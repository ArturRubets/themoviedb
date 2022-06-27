import 'package:flutter/material.dart';

import '../../../domain/data_provider/session_data_provider.dart';
import '../../navigation/main_navigation.dart';

class MyAppModel extends ChangeNotifier {
  final _sessionDataProvider = SessionDataProvider();

  Future<bool> checkSession() async {
    final sessionId = await _sessionDataProvider.sessionId;
    return sessionId != null;
  }

  Future<void> resetSession(BuildContext context) async {
    final navigator = Navigator.of(context);
    
    await _sessionDataProvider.deleteSessionId();
    await _sessionDataProvider.deleteAccountId();

    await navigator.pushNamedAndRemoveUntil(
      MainNavigationRouteNames.auth,
      (_) => false
    );
  }
}
