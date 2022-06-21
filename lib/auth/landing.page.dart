import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../Routes/route.dart';
import '../providers/user.provider.dart';
import '../theme/theme_provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), navigate);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
        size: 200,
        color: theme.isDarkMode ? Colors.blueGrey : Colors.orangeAccent,
      ),
    );
  }

  Future<void> navigate() async {
    var user = Provider.of<AppUser>(context, listen: false).user;
    if (user != null) {
      Navigator.pushReplacementNamed(context, RoutesName.homePage);
    } else {
      Navigator.pushReplacementNamed(context, RoutesName.loginPage);
    }
  }
}
