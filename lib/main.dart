import 'package:flutter/material.dart';
import 'library/widgets/inherited/provider.dart';
import 'ui/widgets/app/my_app.dart';
import 'ui/widgets/app/my_app_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final model = MyAppModel();
  await model.checkSession();

  const myApp = MyApp();
  final provider = Provider(model: model, child: myApp);

  runApp(provider);
}
