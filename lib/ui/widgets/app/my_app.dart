import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../library/widgets/inherited/provider.dart';
import '../../navigation/main_navigation.dart';
import '../../theme/app_colors.dart';
import 'my_app_model.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final mainNavigation = MainNavigation();

  @override
  Widget build(BuildContext context) {
    final myAppModel = Provider.of<MyAppModel>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.mainDarkBlue,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDarkBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'GB'),
        Locale('ru', 'RU'),
      ],
      routes: mainNavigation.routes,
      initialRoute: mainNavigation.initialRoute(myAppModel?.isAuth == true),
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
