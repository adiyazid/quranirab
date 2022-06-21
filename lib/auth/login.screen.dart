import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Routes/route.dart';
import '../../main.dart';
import '../providers/user.provider.dart';
import '../theme/theme_provider.dart';

class SigninWidget extends StatefulWidget {
  const SigninWidget({Key? key}) : super(key: key);

  @override
  State<SigninWidget> createState() => _SigninWidgetState();
}

class _SigninWidgetState extends State<SigninWidget>
    with SingleTickerProviderStateMixin {
  var _obsecure = true;

  get theColor => Colors.transparent;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool loading = false;
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.bounceIn, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser>(context, listen: false);
    final theme = Provider.of<ThemeProvider>(context);
    // Figma Flutter Generator SigninWidget - FRAME
    return SafeArea(
      child: Scaffold(
        body: loading
            ? Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  size: 200,
                  color:
                      theme.isDarkMode ? Colors.blueGrey : Colors.orangeAccent,
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: theme.isDarkMode
                      ? const Color.fromRGBO(78, 78, 78, 1)
                      : const Color.fromRGBO(255, 255, 255, 1),
                ),
                child: Stack(children: <Widget>[
                  ///assalamualaikum container
                  if (MediaQuery.of(context).size.width > 600)
                    Positioned(
                        top: 0,
                        left: -6,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.height,
                          decoration: theme.isDarkMode
                              ? BoxDecoration(
                                  color: const Color.fromRGBO(127, 139, 161, 1),
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    width: 10,
                                  ),
                                )
                              : BoxDecoration(
                                  color: const Color.fromRGBO(255, 243, 201, 1),
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(255, 157, 11, 1),
                                    width: 10,
                                  ),
                                ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.helloWorld,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: theme.isDarkMode
                                      ? Colors.white
                                      : const Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Poppins',
                                  fontSize: 40,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ),
                        )),

                  Align(
                    alignment: MediaQuery.of(context).size.width > 600
                        ? Alignment.centerRight
                        : Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width > 600
                              ? MediaQuery.of(context).size.width * 0.06
                              : 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width > 600
                            ? MediaQuery.of(context).size.width * 0.5
                            : MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: Container(
                                  width: 125,
                                  height: 112,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                      bottomLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                    ),
                                    image: DecorationImage(
                                        image:
                                            AssetImage('assets/quranirab.png'),
                                        fit: BoxFit.fitWidth),
                                  )),
                            ),
                            Flexible(
                              child: Text(
                                AppLocalizations.of(context)!.loginToQuranIrab,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: theme.isDarkMode
                                        ? const Color.fromRGBO(255, 255, 255, 1)
                                        : const Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Poppins',
                                    fontSize: 40,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                  width: MediaQuery.of(context).size.width > 600
                                      ? MediaQuery.of(context).size.width * 0.4
                                      : MediaQuery.of(context).size.width * 0.7,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: theme.isDarkMode
                                        ? const Color.fromRGBO(128, 139, 161, 1)
                                        : const Color.fromRGBO(
                                            255, 237, 176, 1),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: TextFormField(
                                        cursorColor: theme.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        controller: _email,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: theColor),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: theColor),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: theColor),
                                            ),
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .email,
                                            hintStyle: TextStyle(
                                                color: theme.isDarkMode
                                                    ? Colors.white
                                                    : const Color.fromRGBO(
                                                        151, 151, 151, 1),
                                                fontFamily: 'Poppins',
                                                fontSize: 20,
                                                letterSpacing:
                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.normal,
                                                height: 1)),
                                      ),
                                    ),
                                  )),
                            ),
                            Flexible(
                              child: Container(
                                width: MediaQuery.of(context).size.width > 600
                                    ? MediaQuery.of(context).size.width * 0.4
                                    : MediaQuery.of(context).size.width * 0.7,
                                height: 64,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  color: theme.isDarkMode
                                      ? const Color.fromRGBO(128, 139, 161, 1)
                                      : const Color.fromRGBO(255, 237, 176, 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Center(
                                    child: TextFormField(
                                      cursorColor: theme.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      obscureText: _obsecure,
                                      obscuringCharacter: '*',
                                      controller: _pass,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            color: theme.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            onPressed: () {
                                              setState(() {});
                                              _obsecure = !_obsecure;
                                            },
                                            icon: Icon(
                                              !_obsecure
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: theColor),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: theColor),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: theColor),
                                          ),
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .password,
                                          hintStyle: TextStyle(
                                              color: theme.isDarkMode
                                                  ? Colors.white
                                                  : const Color.fromRGBO(
                                                      151, 151, 151, 1),
                                              fontFamily: 'Poppins',
                                              fontSize: 20,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height: 1)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                AppLocalizations.of(context)!.forgotPassword,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: theme.isDarkMode
                                        ? const Color.fromRGBO(255, 255, 255, 1)
                                        : const Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ),
                            Flexible(
                              child: InkWell(
                                onTap: () async {
                                  if (_pass.text == '' && _email.text == '') {
                                    showTopSnackBar(
                                      context,
                                      const CustomSnackBar.error(
                                        message: 'Please Fill All Field',
                                      ),
                                    );
                                  } else {
                                    if (mounted) {
                                      setState(() {});
                                    }
                                    loading = true;
                                    try {
                                      await appUser
                                          .signIn(
                                              email: _email.text,
                                              password: _pass.text)
                                          .then((value) {
                                        setState(() {});
                                        loading = false;
                                        Navigator.pushReplacementNamed(
                                            context, RoutesName.homePage);
                                      });
                                    } catch (e) {
                                      setState(() {});
                                      loading = false;
                                      showTopSnackBar(
                                          context,
                                          CustomSnackBar.error(
                                            message: e.toString(),
                                          ));
                                    }
                                  }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: theme.isDarkMode
                                        ? const Color.fromRGBO(128, 138, 177, 1)
                                        : const Color.fromRGBO(255, 181, 94, 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.login,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: theme.isDarkMode
                                              ? Colors.white
                                              : const Color.fromRGBO(
                                                  0, 0, 0, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: 24,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.dontHaveAcc,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: theme.isDarkMode
                                            ? const Color.fromRGBO(
                                                255, 255, 255, 1)
                                            : const Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.pushNamed(
                                        context, RoutesName.registerPage),
                                    child: Text(
                                      AppLocalizations.of(context)!.signUp,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: theme.isDarkMode
                                              ? const Color.fromRGBO(
                                                  255, 255, 255, 1)
                                              : const Color.fromRGBO(
                                                  0, 0, 0, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ])),
        floatingActionButton: FloatingActionBubble(
          iconData: Icons.settings,
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),
          animation: _animation,
          items: <Bubble>[
            Bubble(
              title: "Arabic",
              iconColor: theme.isDarkMode ? Colors.white : Colors.black,
              bubbleColor:
                  theme.isDarkMode ? Colors.blueGrey : Colors.orangeAccent,
              icon: Icons.language,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                MyApp.of(context)!
                    .setLocale(const Locale.fromSubtags(languageCode: 'ar'));
                _animationController.reverse();
              },
            ),
            Bubble(
              title: "English",
              iconColor: theme.isDarkMode ? Colors.white : Colors.black,
              bubbleColor:
                  theme.isDarkMode ? Colors.blueGrey : Colors.orangeAccent,
              icon: Icons.language,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                MyApp.of(context)!
                    .setLocale(const Locale.fromSubtags(languageCode: 'en'));
                _animationController.reverse();
              },
            ),
            Bubble(
              title: "Bahasa Melayu",
              iconColor: theme.isDarkMode ? Colors.white : Colors.black,
              bubbleColor:
                  theme.isDarkMode ? Colors.blueGrey : Colors.orangeAccent,
              icon: Icons.language,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                MyApp.of(context)!
                    .setLocale(const Locale.fromSubtags(languageCode: 'mas'));
                _animationController.reverse();
              },
            ),
            // Floating action menu item
            Bubble(
              title: theme.isDarkMode ? "Light mode" : "Dark Mode",
              iconColor: theme.isDarkMode ? Colors.white : Colors.black,
              bubbleColor:
                  theme.isDarkMode ? Colors.blueGrey : Colors.orangeAccent,
              icon: theme.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                theme.isDarkMode
                    ? theme.toggleTheme(false)
                    : theme.toggleTheme(true);
                _animationController.reverse();
              },
            ),
          ],
          backGroundColor:
              theme.isDarkMode ? Colors.blueGrey : Colors.orangeAccent,
          iconColor: theme.isDarkMode ? Colors.white : Colors.black,
        ),
        //BUTTON LOCATION
      ),
    );
  }
}
