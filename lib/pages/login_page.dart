import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_app/const/app_color.dart';
import 'package:futsal_app/local_storage/local_storage.dart';
import 'package:futsal_app/pages/bottom_navigation_screen.dart';
import 'package:futsal_app/pages/signin_page.dart';
import 'package:futsal_app/provider/basic_provider.dart';
import 'package:futsal_app/service/firebase_auth.dart';
import 'package:futsal_app/widgets/snack_bar.dart';
import 'package:futsal_app/widgets/text_field.dart';
import 'package:futsal_app/widgets/texts.dart';

class LoginPage extends ConsumerWidget {
  static const String routeName = 'login page';
  LoginPage({super.key});
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkBox = ref.watch(checkBoxValueProvider);

    final isLoading = ref.watch(isLoadingProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey1,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                texts(text: 'Futsal', size: 45, weight: FontWeight.w700),
                texts(text: 'Booking App', size: 45, weight: FontWeight.w700),
                texts(text: 'sign in to access your account', size: 21, weight: FontWeight.w300),
                NormalTextField(
                  controller: email,
                  text: 'Email',
                  iconData: Icons.email,
                ),
                NormalTextField(
                  controller: password,
                  text: 'password',
                  iconData: Icons.lock_open_sharp,
                ),
                SizedBox(
                  width: 300,
                  height: 60,
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: AppColor.primaryColor,
                        value: checkBox,
                        onChanged: (value) {
                          ref.read(checkBoxValueProvider.notifier).state = !checkBox;
                        },
                      ),
                      texts(text: "Remember me")
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: MaterialButton(
                    minWidth: 300,
                    height: 50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: AppColor.primaryColor,
                    onPressed: () async {
                      if (formKey1.currentState!.validate()) {
                        try {
                          ref.read(isLoadingProvider.notifier).state = true;
                          var response = await FireAuthRepo().login(email: email.text, password: password.text);
                          log(response.refreshToken.toString());
                          if (response.refreshToken != 'null') {
                            await LocalStorage().savetoken(key: 'email', token: email.text);


                            ref.read(currentPageIndexProvider.notifier).state = 0;

                            Navigator.pushReplacementNamed(context, BottomNavigationScreen.routeName);
                          }
                          ref.read(isLoadingProvider.notifier).state = false;
                        } on FirebaseAuthException catch (e) {
                          log('FirebaseAuthException: ${e.message}');
                          ref.read(isLoadingProvider.notifier).state = false;

                          showsnackBar(context: context, text: 'Invalid credentails', color: Colors.red, textColor: Colors.white);
                        }
                      }
                    },
                    child: isLoading ? CircularProgressIndicator() : texts(text: "Login", color: AppColor.white),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    texts(text: "Don’t have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignInPage.routeName);
                      },
                      child: texts(
                        text: "Sign up",
                        color: AppColor.primaryColor,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
