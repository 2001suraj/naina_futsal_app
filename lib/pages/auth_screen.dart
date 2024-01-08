
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_app/pages/bottom_navigation_screen.dart';
import 'package:futsal_app/pages/login_page.dart';

class AuthScreen extends ConsumerWidget {
  static const routeName = 'AuthScreen';
  AuthScreen({super.key});
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (auth.currentUser != null) {
      return BottomNavigationScreen();
    }
    return LoginPage();
  }
}