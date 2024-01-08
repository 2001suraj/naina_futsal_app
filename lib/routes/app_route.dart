import 'package:flutter/material.dart';
import 'package:futsal_app/model/futsal_model.dart';
import 'package:futsal_app/pages/add_futsal_page.dart';
import 'package:futsal_app/pages/auth_screen.dart';
import 'package:futsal_app/pages/book_now_page.dart';
import 'package:futsal_app/pages/bottom_navigation_screen.dart';
import 'package:futsal_app/pages/individual_page.dart';
import 'package:futsal_app/pages/login_page.dart';
import 'package:futsal_app/pages/signin_page.dart';

class AppRoute {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case LoginPage.routeName:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case AuthScreen.routeName:
        return MaterialPageRoute(builder: (context) => AuthScreen());
      case SignInPage.routeName:
        return MaterialPageRoute(builder: (context) => SignInPage());
      case BottomNavigationScreen.routeName:
        return MaterialPageRoute(builder: (context) => BottomNavigationScreen());
      case AddFutsalPage.routeName:
        return MaterialPageRoute(builder: (context) => AddFutsalPage());
      case IndividualPage.routeName:
        return MaterialPageRoute(builder: (context) {
          final FutsalModel model = routeSettings.arguments as FutsalModel;
          return IndividualPage(
            model: model,
          );
        });
      case BookNowPage.routeName:
        return MaterialPageRoute(builder: (context) {
          final FutsalModel model = routeSettings.arguments as FutsalModel;
          return BookNowPage(
            model: model,
          );
        });

      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(
                    child: Text("No Route Found"),
                  ),
                ));
    }
  }
}
