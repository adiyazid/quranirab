import 'package:quranirab/themes/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/views/nav.draw.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
        return Scaffold(
        drawer: navDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.orange[700],
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(themeNotifier.isDark
                ? Icons.nightlight_round
                : Icons.wb_sunny, color: themeNotifier.isDark ? Colors.white : Colors.grey.shade50),
              onPressed: () {
                themeNotifier.isDark
                  ? themeNotifier.isDark = false
                  : themeNotifier.isDark = true;
              }
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 200, top: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sign in to QuranIrab", style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 50,)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50,),
                    Container(
                      width: 500,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email or Phone number"
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      width: 500,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      child: const TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password"
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Text("Forgot Password?", style: Theme.of(context).textTheme.bodyText1,)
                  ],
                ),
                Column(
                  children: [
                    RaisedButton(
                      onPressed: () => {},
                      elevation: 0,
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.orange,
                      child: const Center(child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold),)),
                    ),
                    const SizedBox(height: 30,),
                    Text("Create account", style: Theme.of(context).textTheme.bodyText1)
                  ],
                )
              ],
            ),
          ),
        ),
      );
      }
    );
  }
}