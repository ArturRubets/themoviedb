import 'package:flutter/material.dart';
import 'package:themoviedb/ui/widgets/app/my_app_model.dart';

import '../../navigation/main_navigation.dart';
import '../../theme/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.myAppModel}) : super(key: key);

  static final mainNavigation = MainNavigation();
  final MyAppModel myAppModel;

  @override
  Widget build(BuildContext context) {
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
      routes: mainNavigation.routes,
      initialRoute: mainNavigation.initialRoute(myAppModel.isAuth),
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
