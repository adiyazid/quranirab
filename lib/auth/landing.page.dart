import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:multiquranirab/auth/login.screen.dart';
import 'package:multiquranirab/view/home.dart';
import 'package:provider/provider.dart';

import '../providers/user.provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AppUser>(context, listen: false).user;
    if (user != null) {
      return Scaffold(
          body: DoubleBackToCloseApp(
              snackBar: SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.fixed,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Exit? ',
                  message: 'Press back again to exit!',
                  contentType: ContentType.warning,
                ),
              ),
              child: const MyHomePage(title: 'Multi Quran Irab')));
    } else {
      return Scaffold(
          body: DoubleBackToCloseApp(
              snackBar: SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.fixed,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Exit? ',
                  message: 'Press back again to exit!',
                  contentType: ContentType.warning,
                ),
              ),
              child: const SigninWidget()));
    }
  }
}
