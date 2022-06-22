import 'package:flutter/material.dart';
import 'package:quranirab/Routes/route.dart';
import 'package:quranirab/views/auth/login.screen.dart';
import 'package:quranirab/views/auth/signup.screen.dart';
import 'package:quranirab/views/home.page.dart';

import '../views/auth/landing.page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.homePage:
        return _GeneratePageRoute(widget: HomePage(), routeName: settings.name);
      case RoutesName.loginPage:
        return _GeneratePageRoute(
            widget: SigninWidget(), routeName: settings.name);
      case RoutesName.registerPage:
        return _GeneratePageRoute(
            widget: SignupWidget(), routeName: settings.name);
      default:
        return _GeneratePageRoute(
            widget: LandingPage(), routeName: settings.name);
    }
  }
}

class _GeneratePageRoute extends PageRouteBuilder {
  final Widget widget;
  final String? routeName;

  static List<Curve> curveList = [
    Curves.bounceIn,
    Curves.bounceInOut,
    Curves.bounceOut,
    Curves.decelerate,
    Curves.ease,
    Curves.easeIn,
    Curves.easeInBack,
    Curves.easeInCirc,
    Curves.easeInCubic,
    Curves.easeInExpo,
    Curves.easeInOut,
    Curves.easeInOutBack,
    Curves.easeInOutCirc,
    Curves.easeInOutCubic,
    Curves.easeInOutExpo,
    Curves.easeInOutQuad,
    Curves.easeInOutQuart,
    Curves.easeInOutQuint,
    Curves.easeInOutSine,
    Curves.easeInQuad,
    Curves.easeInQuart,
    Curves.easeInQuint,
    Curves.easeInSine,
    Curves.easeInToLinear,
    Curves.easeOut,
    Curves.easeOutBack,
    Curves.easeOutCubic,
    Curves.easeOutExpo,
    Curves.easeOutQuad,
    Curves.easeOutQuart,
    Curves.easeOutQuint,
    Curves.easeOutSine,
    Curves.elasticIn,
    Curves.elasticInOut,
    Curves.elasticOut,
    Curves.fastLinearToSlowEaseIn,
    Curves.fastOutSlowIn,
    Curves.linear,
    Curves.linearToEaseOut,
    Curves.slowMiddle
  ];

  _GeneratePageRoute({required this.widget, this.routeName})
      : super(
            settings: RouteSettings(name: routeName),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              animation =
                  CurvedAnimation(curve: curveList[20], parent: animation);
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            });
}
