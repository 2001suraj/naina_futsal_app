import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_app/const/app_color.dart';
import 'package:futsal_app/const/app_size.dart';
import 'package:futsal_app/local_storage/local_storage.dart';
import 'package:futsal_app/pages/login_page.dart';
import 'package:futsal_app/provider/user_provider.dart';
import 'package:futsal_app/service/firebase_auth.dart';
import 'package:futsal_app/widgets/texts.dart';

class ProfileScreen extends ConsumerWidget {
  static const String routeName = 'ProfileScreen';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
                future: LocalStorage().gettoken(value: 'email'),
                builder: (context, snap) {
                  return userData.when(
                      data: (value) {
                        return ListView.builder(
                            itemCount: value.docs.length,
                            itemBuilder: (context, index) {
                              if (value.docs[index]['email'].toString().toLowerCase() == snap.data.toString().toLowerCase()) {
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Spacer(),
                                      texts(text: "Profile", size: 24, weight: FontWeight.w700),
                                      AppSize.maxheight,
                                      AppSize.maxheight,
                                      const CircleAvatar(
                                        radius: 90,
                                        backgroundImage: AssetImage('assets/images/image5.png'),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(28.0),
                                        child: Divider(),
                                      ),
                                      texts(text: value.docs[index]['name'], size: 24, weight: FontWeight.w700),
                                      AppSize.minheight,
                                      texts(text: value.docs[index]['email'], size: 14, weight: FontWeight.w600),
                                      AppSize.maxheight,
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3),
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(color: AppColor.red),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    surfaceTintColor: AppColor.white,
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        texts(text: "Log out", color: AppColor.red, size: 22, weight: FontWeight.w700),
                                                        AppSize.normalheight,
                                                        texts(text: "Are you sure you want to Logout?", size: 14, weight: FontWeight.w500),
                                                        AppSize.maxheight,
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            MaterialButton(
                                                              height: 42,
                                                              minWidth: 120,
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                              color: AppColor.bgColor,
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: texts(text: "Cancel", color: AppColor.primaryColor),
                                                            ),
                                                            AppSize.normalwidth,
                                                            MaterialButton(
                                                              height: 42,
                                                              minWidth: 120,
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                              color: AppColor.primaryColor,
                                                              onPressed: () async {
                                                                await LocalStorage().clear(key: 'email');
                                                                await FireAuthRepo().logout();
                                                                await Navigator.pushReplacementNamed(context, LoginPage.routeName);
                                                              },
                                                              child: texts(text: "Logout", color: AppColor.white),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.logout_rounded,
                                                color: AppColor.red,
                                              ),
                                              texts(text: "Log out", color: AppColor.red),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      const Spacer(),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            });
                      },
                      error: (e, r) => Text(
                            e.toString(),
                          ),
                      loading: () => const Center(child: CircularProgressIndicator()));
                }),
          ),
        ),
      ),
    );
  }
}
