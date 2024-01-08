import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_app/const/app_color.dart';
import 'package:futsal_app/local_storage/local_storage.dart';
import 'package:futsal_app/model/user_model.dart';
import 'package:futsal_app/pages/bottom_navigation_screen.dart';
import 'package:futsal_app/pages/login_page.dart';
import 'package:futsal_app/provider/basic_provider.dart';
import 'package:futsal_app/service/firebase_auth.dart';
import 'package:futsal_app/service/user_firebase.dart';
import 'package:futsal_app/widgets/snack_bar.dart';
import 'package:futsal_app/widgets/text_field.dart';
import 'package:futsal_app/widgets/texts.dart';

class SignInPage extends ConsumerWidget {
  static const String routeName = 'SignIn page';
  SignInPage({super.key});
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkBox = ref.watch(checkBoxValueProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, LoginPage.routeName);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
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
                texts(text: 'Sign Up Now', size: 45, weight: FontWeight.w700),
                texts(text: 'by creating a free account.', size: 21, weight: FontWeight.w300),
                SuffixNormalTextField(
                  controller: name,
                  text: 'Full Name',
                  iconData: Icons.person,
                ),
                SuffixNormalTextField(
                  controller: email,
                  text: 'Email',
                  iconData: Icons.email,
                ),
                SuffixNormalTextField(
                  controller: phone,
                  text: 'Phone',
                  iconData: Icons.phone_android,
                ),
                SuffixNormalTextField(
                  controller: password,
                  text: 'password',
                  iconData: Icons.lock_open_sharp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Checkbox(
                        activeColor: AppColor.primaryColor,
                        value: checkBox,
                        onChanged: (value) {
                          ref.read(checkBoxValueProvider.notifier).state = !checkBox;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 30,
                      child: RichText(
                        text: const TextSpan(
                          text: 'By checking the box you agree to our ',
                          style: TextStyle(color: AppColor.black),
                          children: [
                            TextSpan(
                              text: 'Terms ',
                              style: TextStyle(color: AppColor.primaryColor),
                            ),
                            TextSpan(
                              text: 'and',
                            ),
                            TextSpan(
                              text: 'Conditions.',
                              style: TextStyle(color: AppColor.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
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
                          var response = await FireAuthRepo().signin(email: email.text, password: password.text);
                          log(response.refreshToken.toString());
                          if (response.refreshToken != 'null') {
                            await LocalStorage().savetoken(key: 'email', token: email.text);

                            UserModel model = UserModel(email: email.text, phone: phone.text, name: name.text);
                            await UserFirebase().addUser(model);

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
                    child: texts(text: "Sign In", color: AppColor.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
