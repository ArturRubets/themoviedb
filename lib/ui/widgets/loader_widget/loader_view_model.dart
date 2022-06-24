import 'package:flutter/material.dart';

import '../../../domain/services/auth_service.dart';
import '../../navigation/main_navigation.dart';

class LoaderViewModel {
  LoaderViewModel(this.context) {
    _asyncInit();
  }

  final BuildContext context;
  final _authService = AuthService();

  Future<void> _asyncInit() async {
    await checkSession();
  }

  Future<void> checkSession() async {
    final navigator = Navigator.of(context);

    final isAuth = await _authService.isAuth();
    final nextScreen = isAuth
        ? MainNavigationRouteNames.mainScreen
        : MainNavigationRouteNames.auth;
    await navigator.pushReplacementNamed(nextScreen);
  }
}
