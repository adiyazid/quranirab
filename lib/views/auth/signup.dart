import 'package:quranirab/provider/user.provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/views/auth/login.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser>(context);
    final Size size = MediaQuery.of(context).size;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[700],
          elevation: 0,
          actions: [

          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.only(
                left: 20, right: 20, bottom: 200, top: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sign Up to QuranIrab",
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontSize: 50,
                        )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: 500,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: TextField(
                        controller: _name,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Full Name"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 500,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: TextField(
                        controller: _email,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Email"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 500,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: TextField(
                        controller: _pass,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Password"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Forgot Password?",
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        minimumSize: size*0.06,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        if (_pass.text == '' &&
                            _name.text == '' &&
                            _email.text == '') {
                          showTopSnackBar(
                            context,
                            const CustomSnackBar.error(
                              message: 'Please Fill All Field',
                            ),
                          );
                        } else {
                          try {
                            await appUser.signUp(
                                email: _email.text,
                                password: _pass.text,
                                name: _name.text);
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
                      child: const Center(
                          child: Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      child: Text("Login account",
                          style: Theme.of(context).textTheme.bodyText1),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage())),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );

  }
}
