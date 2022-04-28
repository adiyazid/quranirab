import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({Key? key}) : super(key: key);

  @override
  _SignupWidgetState createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  get theColor => Colors.transparent;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _pass1 = TextEditingController();
  final TextEditingController _pass2 = TextEditingController();
  CollectionReference users =
      FirebaseFirestore.instance.collection('quranIrabUsers');
  bool _check = false;

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator SignupWidget - FRAME
    final appUser = Provider.of<AppUser>(context);
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Container(
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
                  child: const Center(
                    child: SizedBox(
                      width: 400,
                      child: Text(
                        'Welcome to QuranIrab official website',
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
                    left: MediaQuery.of(context).size.width > 818 ?MediaQuery.of(context).size.width * 0.06:0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 818
                      ? MediaQuery.of(context).size.width * 0.55
                      : MediaQuery.of(context).size.width * 0.8,
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
                          'Register for QuranIrab',
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
                              ? MediaQuery.of(context).size.width * 0.37
                              : MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width > 818
                                    ? MediaQuery.of(context).size.width * 0.17
                                    : MediaQuery.of(context).size.width * 0.37,
                                height: 54,
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
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextFormField(
                                    controller: _firstName,
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
                                        hintText: 'First Name',
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
                                    ? MediaQuery.of(context).size.width * 0.17
                                    : MediaQuery.of(context).size.width * 0.37,
                                height: 54,
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
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextFormField(
                                    controller: _lastName,
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
                                        hintText: 'Last Name',
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
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width > 818
                            ? MediaQuery.of(context).size.width * 0.37
                            : MediaQuery.of(context).size.width * 0.8,
                        height: 54,
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
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
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
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width > 818
                            ? MediaQuery.of(context).size.width * 0.37
                            : MediaQuery.of(context).size.width * 0.8,
                        height: 54,
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
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            cursorColor:
                                theme.isDarkMode ? Colors.white : Colors.black,
                            obscureText: true,
                            obscuringCharacter: '*',
                            controller: _pass1,
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
                      Container(
                        width: MediaQuery.of(context).size.width > 818
                            ? MediaQuery.of(context).size.width * 0.37
                            : MediaQuery.of(context).size.width * 0.8,
                        height: 54,
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
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            cursorColor:
                                theme.isDarkMode ? Colors.white : Colors.black,
                            obscureText: true,
                            obscuringCharacter: '*',
                            controller: _pass2,
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
                                hintText: 'Confirm Password',
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
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width > 818
                                ? MediaQuery.of(context).size.width * 0.06
                                : 0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width > 818
                              ? MediaQuery.of(context).size.width * 0.5
                              : MediaQuery.of(context).size.width * 0.8,
                          child: Row(
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
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: const Text(
                                  'I accept the terms and conditions and I have read the privacy policy ',
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  style: TextStyle(
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
                      ),

                      ///button
                      InkWell(
                        onTap: () async {
                          if (_pass1.text == '' &&
                              _pass2.text == '' &&
                              _firstName.text == '' &&
                              _lastName.text == '' &&
                              _email.text == '') {
                            showTopSnackBar(
                              context,
                              const CustomSnackBar.error(
                                message: 'Please Fill All Field',
                              ),
                            );
                          } else if (_pass1.text != _pass2.text) {
                            showTopSnackBar(
                              context,
                              const CustomSnackBar.error(
                                message:
                                    'Password did not match. Please insert again',
                              ),
                            );
                          } else if (_check == false) {
                            showTopSnackBar(
                              context,
                              const CustomSnackBar.error(
                                message:
                                    'Please agree with terms and condition before proceed',
                              ),
                            );
                          } else {
                            try {
                              await appUser.signUp(
                                  email: _email.text,
                                  password: _pass1.text,
                                  lastName: _lastName.text,
                                  firstName: _firstName.text);
                              await addUser();
                              Navigator.pop(context);
                              showTopSnackBar(
                                context,
                                const CustomSnackBar.success(
                                  message: 'New Account Created',
                                ),
                              );
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
                          child: const Center(
                            child: Text(
                              'Sign up',
                              textAlign: TextAlign.left,
                              style: TextStyle(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(AppUser.instance.user!.uid)
        .set({
          'first_name': _firstName.text, // John Doe
          'last_name': _lastName.text, // Stokes and Sons
          'email': _email.text,
          'uid': AppUser.instance.user!.uid
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
