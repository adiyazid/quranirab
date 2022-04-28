import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/views/auth/signup.screen.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SigninWidget extends StatefulWidget {
  const SigninWidget({Key? key}) : super(key: key);

  @override
  State<SigninWidget> createState() => _SigninWidgetState();
}

class _SigninWidgetState extends State<SigninWidget> {
  get theColor => Colors.transparent;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser>(context);
    final theme = Provider.of<ThemeProvider>(context);
    // Figma Flutter Generator SigninWidget - FRAME
    return Scaffold(
      body: Container(
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
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              width: 10,
                            ),
                          )
                        : BoxDecoration(
                            color: const Color.fromRGBO(255, 243, 201, 1),
                            border: Border.all(
                              color: const Color.fromRGBO(255, 157, 11, 1),
                              width: 10,
                            ),
                          ),
                    child: Center(
                      child: Text(
                        'Assalamualaikum',
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
                    right:  MediaQuery.of(context).size.width > 600 ?MediaQuery.of(context).size.width * 0.06:0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width * 0.5
                      : MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.7,
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
                                  image: AssetImage('assets/quranirab.png'),
                                  fit: BoxFit.fitWidth),
                            )),
                      ),
                      Flexible(
                        child: Text(
                          'Login to QuranIrab',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: theme.isDarkMode
                                  ? const Color.fromRGBO(255, 255, 255, 1)
                                  : const Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Poppins',
                              fontSize: 45,
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
                                  : const Color.fromRGBO(255, 237, 176, 1),
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
                                        borderSide: BorderSide(color: theColor),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: theColor),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: theColor),
                                      ),
                                      hintText: 'Email',
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Center(
                              child: TextFormField(
                                cursorColor: theme.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                obscureText: true,
                                obscuringCharacter: '*',
                                controller: _pass,
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
                                    hintText: 'Password',
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
                          'Forgot Password?',
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
                              try {
                                await appUser.signIn(
                                    email: _email.text, password: _pass.text);
                                showTopSnackBar(
                                    context,
                                    const CustomSnackBar.success(
                                      message: 'Login Success',
                                    ),
                                    showOutAnimationDuration:
                                        Duration(milliseconds: 200),
                                    hideOutAnimationDuration:
                                        Duration(milliseconds: 250),
                                    displayDuration:
                                        Duration(milliseconds: 1000));
                              } catch (e) {
                                showTopSnackBar(
                                    context,
                                    CustomSnackBar.error(
                                      message: e.toString(),
                                    ));
                              }
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.35,
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
                                'Login',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: theme.isDarkMode
                                        ? Colors.white
                                        : const Color.fromRGBO(0, 0, 0, 1),
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
                              'Don’t have account? ',
                              textAlign: TextAlign.left,
                              style: TextStyle(
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
                            InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupWidget())),
                              child: Text(
                                'Sign up ',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ])),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {
            theme.isDarkMode
                ? theme.toggleTheme(false)
                : theme.toggleTheme(true);
          },
          child: theme.isDarkMode
              ? const Icon(Icons.wb_sunny)
              : const Icon(Icons.nightlight_round),
        ),
      ),
      //BUTTON LOCATION
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
