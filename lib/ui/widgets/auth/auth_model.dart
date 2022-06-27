import 'package:flutter/material.dart';

import '../../../domain/api_client/api_client.dart';
import '../../../domain/api_client/api_client_exception.dart';
import '../../../domain/services/auth_service.dart';
import '../../navigation/main_navigation.dart';

class AuthViewModel extends ChangeNotifier {
  final _authService = AuthService();

  final loginTextController =
      TextEditingController(text: MovieApiClient.username);

  final passwordTextController =
      TextEditingController(text: MovieApiClient.password);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;

  bool isValidLoginAndPassword(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  Future<String?> _login(String login, String password) async {
    try {
      await _authService.login(login, password);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.auth:
          return 'Неправильный логин или пароль';
        case ApiClientExceptionType.network:
          return 'Сервер недоступен проверьте подключение к интернету';
        case ApiClientExceptionType.sessionExpired:
          return 'Истек токен сессии';
        case ApiClientExceptionType.other:
          return 'Что-то пошло не так';
      }
    } catch (_) {
      return 'Неизвестная ошибка, повторите попытку позже';
    }
    return null;
  }

  void _updateState(
      {required String? errorMessage, required bool isAuthProgress}) {
    _errorMessage = errorMessage;
    _isAuthProgress = isAuthProgress;
    notifyListeners();
  }

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;

    final validLoginAndPassword = isValidLoginAndPassword(login, password);

    if (validLoginAndPassword) {
      _updateState(errorMessage: null, isAuthProgress: true);
    } else {
      _updateState(
        errorMessage: 'Заполните логин и пароль',
        isAuthProgress: false,
      );
      return;
    }

    final errorMessageResponse = await _login(login, password);

    if (errorMessageResponse == null) {
      // ignore: use_build_context_synchronously
      await MainNavigation.resetNavigation(context);
    } else {
      _updateState(errorMessage: errorMessageResponse, isAuthProgress: false);
    }
  }
}
