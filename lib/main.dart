import 'package:flutter/material.dart';
import 'ui/widgets/app/my_app.dart';
import 'ui/widgets/app/my_app_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = MyAppModel();
  await model.checkSession();
  final myApp = MyApp(myAppModel: model);
  runApp(myApp);
}
