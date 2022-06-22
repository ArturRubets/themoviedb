import 'package:flutter/material.dart';

import '../../../domain/api_client/api_client.dart';
import '../../../library/widgets/inherited/provider.dart';
import '../../navigation/main_navigation.dart';
import '../app/my_app_model.dart';

class AuthModel extends ChangeNotifier {
  final _apiClient = ApiClient();

  final loginTextController = TextEditingController(text: ApiClient.username);

  final passwordTextController =
      TextEditingController(text: ApiClient.password);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;

  Future<void> auth(BuildContext context) async {
    var navigator = Navigator.of(context);

    final login = loginTextController.text;
    final password = passwordTextController.text;
    if (login.isEmpty || password.isEmpty) {
      _errorMessage = 'Заполните логин и пароль';
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isAuthProgress = true;
    notifyListeners();

    try {
      final sessionId = await _apiClient.auth(
        username: login,
        password: password,
      );

      final accountId = await _apiClient.getAccountId(sessionId);

      if (accountId == null) {
        throw const ApiClientException(type: ApiClientExceptionType.other);
      }

      // ignore: use_build_context_synchronously
      await Provider.of<MyAppModel>(context)?.addSession(sessionId, accountId);

      await navigator.pushReplacementNamed(MainNavigationRouteNames.mainScreen);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.auth:
          _errorMessage = 'Неправильный логин или пароль';
          break;
        case ApiClientExceptionType.network:
          _errorMessage = 'Сервер недоступен проверьте подключение к интернету';
          break;
        case ApiClientExceptionType.sessionExpired:
          _errorMessage = 'Истек токен сессии';
          break;
        case ApiClientExceptionType.other:
          _errorMessage = 'Что-то пошло не так';
          break;
      }
    }
    _isAuthProgress = false;
    notifyListeners();
  }
}
