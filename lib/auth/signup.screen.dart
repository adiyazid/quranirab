import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'landing.page.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({Key? key}) : super(key: key);

  @override
  _SignupWidgetState createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget>
    with SingleTickerProviderStateMixin {
  var _obsecure = true;
  var _obsecure2 = true;

  var loading = false;

  get theColor => Colors.transparent;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _pass1 = TextEditingController();
  final TextEditingController _pass2 = TextEditingController();
  CollectionReference users =
      FirebaseFirestore.instance.collection('quranIrabUsers');
  bool _check = false;
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.bounceIn, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator SignupWidget - FRAME
    final appUser = Provider.of<AppUser>(context);
    final theme = Provider.of<ThemeProvider>(context);
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
                      : Colors.white,
                ),
                child: Stack(children: <Widget>[
                  if (MediaQuery.of(context).size.width > 818)
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.37,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.isDarkMode
                                ? const Color.fromRGBO(255, 255, 255, 1)
                                : const Color(0xffFF9E0C),
                            width: 10,
                          ),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(0, 4),
                                blurRadius: 4)
                          ],
                          color: theme.isDarkMode
                              ? const Color(0xff808BA1)
                              : const Color(0xffFFEEB0),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 400,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .welcomeToQuranIrabOfficialWebsite,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 50,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Align(
                    alignment: MediaQuery.of(context).size.width > 818
                        ? Alignment.centerLeft
                        : Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width > 818
                              ? MediaQuery.of(context).size.width * 0.06
                              : 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width > 818
                            ? MediaQuery.of(context).size.width * 0.55
                            : MediaQuery.of(context).size.width,
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
                                AppLocalizations.of(context)!
                                    .registerForQuranIrab,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 45,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ),
                            Flexible(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width > 818
                                    ? MediaQuery.of(context).size.width * 0.4
                                    : MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width >
                                                  818
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.18
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.46,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        color: theme.isDarkMode
                                            ? const Color(0xff808BA1)
                                            : const Color(0xffFFEEB0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8),
                                        child: TextFormField(
                                          cursorColor: theme.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          controller: _firstName,
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: theColor),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: theColor),
                                              ),
                                              border: UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: theColor),
                                              ),
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .firstName,
                                              hintStyle: TextStyle(
                                                  color: theme.isDarkMode
                                                      ? Colors.white
                                                      : const Color.fromRGBO(
                                                          151, 151, 151, 1),
                                                  fontFamily: 'Poppins',
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1)),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width >
                                                  818
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.18
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.46,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        color: theme.isDarkMode
                                            ? const Color(0xff808BA1)
                                            : const Color(0xffFFEEB0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8),
                                        child: TextFormField(
                                          cursorColor: theme.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          controller: _lastName,
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: theColor),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: theColor),
                                              ),
                                              border: UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: theColor),
                                              ),
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .lastName,
                                              hintStyle: TextStyle(
                                                  color: theme.isDarkMode
                                                      ? Colors.white
                                                      : const Color.fromRGBO(
                                                          151, 151, 151, 1),
                                                  fontFamily: 'Poppins',
                                                  letterSpacing:
                                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width > 818
                                  ? MediaQuery.of(context).size.width * 0.37
                                  : MediaQuery.of(context).size.width * 0.96,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                color: theme.isDarkMode
                                    ? const Color(0xff808BA1)
                                    : const Color(0xffFFEEB0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8),
                                child: TextFormField(
                                  cursorColor: theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  controller: _email,
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: theColor),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: theColor),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: theColor),
                                      ),
                                      hintText:
                                          AppLocalizations.of(context)!.email,
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
                            Container(
                              width: MediaQuery.of(context).size.width > 818
                                  ? MediaQuery.of(context).size.width * 0.37
                                  : MediaQuery.of(context).size.width * 0.96,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                color: theme.isDarkMode
                                    ? const Color(0xff808BA1)
                                    : const Color(0xffFFEEB0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8),
                                child: TextFormField(
                                  cursorColor: theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  obscureText: _obsecure,
                                  obscuringCharacter: '*',
                                  controller: _pass1,
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
                                        borderSide: BorderSide(color: theColor),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: theColor),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: theColor),
                                      ),
                                      hintText: AppLocalizations.of(context)!
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
                            Container(
                              width: MediaQuery.of(context).size.width > 818
                                  ? MediaQuery.of(context).size.width * 0.37
                                  : MediaQuery.of(context).size.width * 0.96,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                color: theme.isDarkMode
                                    ? const Color(0xff808BA1)
                                    : const Color(0xffFFEEB0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8),
                                child: TextFormField(
                                  cursorColor: theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  obscureText: _obsecure2,
                                  obscuringCharacter: '*',
                                  controller: _pass2,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        color: theme.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        onPressed: () {
                                          setState(() {});
                                          _obsecure2 = !_obsecure2;
                                        },
                                        icon: Icon(
                                          !_obsecure2
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: theColor),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: theColor),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: theColor),
                                      ),
                                      hintText: AppLocalizations.of(context)!
                                          .confirmPass,
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
                            Flexible(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Checkbox(
                                    activeColor: Colors.lightBlue,
                                    checkColor: Colors.white,
                                    tristate: false,
                                    value: _check,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _check = value!;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .iAgreeTermCondition,
                                      textAlign: TextAlign.left,
                                      maxLines: 3,
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, RoutesName.loginPage),
                              child: Text(
                                AppLocalizations.of(context)!.haveAccSignIn,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: theme.isDarkMode
                                        ? const Color.fromRGBO(255, 255, 255, 1)
                                        : const Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ),

                            ///button
                            InkWell(
                              onTap: () async {
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(_email.text.trim());
                                if (_pass1.text.isEmpty ||
                                    _pass2.text.isEmpty ||
                                    _firstName.text.isEmpty ||
                                    _lastName.text.isEmpty ||
                                    _email.text.isEmpty) {
                                  showTopSnackBar(
                                    context,
                                    CustomSnackBar.error(
                                      message: AppLocalizations.of(context)!
                                          .fillAllField,
                                    ),
                                  );
                                } else if (!emailValid) {
                                  showTopSnackBar(
                                    context,
                                    CustomSnackBar.error(
                                      message: AppLocalizations.of(context)!
                                          .emailError,
                                    ),
                                  );
                                } else if (_pass1.text.length < 6 ||
                                    _pass2.text.length < 6) {
                                  showTopSnackBar(
                                    context,
                                    CustomSnackBar.error(
                                      message: AppLocalizations.of(context)!
                                          .passwordLengthError,
                                    ),
                                  );
                                } else if (_pass1.text != _pass2.text) {
                                  showTopSnackBar(
                                    context,
                                    CustomSnackBar.error(
                                      message: AppLocalizations.of(context)!
                                          .passwordError,
                                    ),
                                  );
                                } else if (_check == false) {
                                  showTopSnackBar(
                                    context,
                                    CustomSnackBar.error(
                                      message: AppLocalizations.of(context)!
                                          .termConditionError,
                                    ),
                                  );
                                } else {
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  loading = true;
                                  try {
                                    await appUser.signUp(
                                        email: _email.text,
                                        password: _pass1.text,
                                        lastName: _lastName.text,
                                        firstName: _firstName.text);
                                    await addUser().then((value) {
                                      showTopSnackBar(
                                        context,
                                        CustomSnackBar.success(
                                          message: AppLocalizations.of(context)!
                                              .newAccCreated,
                                        ),
                                      );
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LandingPage()));
                                    });

                                    if (mounted) {
                                      setState(() {});
                                    }
                                    loading = false;
                                  } catch (e) {
                                    if (mounted) {
                                      setState(() {});
                                    }
                                    loading = false;
                                    if (e.toString() ==
                                        '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
                                      showTopSnackBar(
                                          context,
                                          CustomSnackBar.error(
                                            message:
                                                AppLocalizations.of(context)!
                                                    .duplicateEmail,
                                          ));
                                    } else {
                                      showTopSnackBar(
                                          context,
                                          CustomSnackBar.error(
                                              message: e.toString()));
                                    }
                                  }
                                }
                              },
                              child: Container(
                                width: 248,
                                height: 54,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  color: theme.isDarkMode
                                      ? const Color(0xff808AB1)
                                      : const Color(0xffFFB55F),
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.signUp,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
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
      ),
    );
  }

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(AppUser.instance.user!.uid)
        .set({
          'role': 'user',
          'first_name': _firstName.text, // John Doe
          'last_name': _lastName.text, // Stokes and Sons
          'email': _email.text,
          'uid': AppUser.instance.user!.uid
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
