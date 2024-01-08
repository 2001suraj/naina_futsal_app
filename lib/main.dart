import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_app/pages/auth_screen.dart';
import 'package:futsal_app/pages/login_page.dart';
import 'package:futsal_app/firebase_options.dart';
import 'package:futsal_app/routes/app_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(
      child: MyApp(
    route: AppRoute(),
  )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.route});
  final AppRoute route;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Futsal App ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: route.onGenerateRoute,
      initialRoute: AuthScreen.routeName,
    );
  }
}
