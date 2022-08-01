import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/quiz_module/LeaderBoard.Menu.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Routes/route.dart';
import '../views/user.profile/user.profile.dart';
import '../views/privacy.policy/privacy.policy.dart';
import '../views/feedback/feedback.dart';

class Menu extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 10);

  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    String _url = 'https://www.freeprivacypolicy.com/live/8a9abf43-a7bd-4edb-8038-276754fc5d97';
    return Drawer(
      semanticLabel: 'Menu',
      child: Material(
        color: Theme.of(context).primaryColor,
        child: ListView(
          padding: padding,
          children: <Widget>[
            const SizedBox(height: 10),
            Stack(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(30, 16, 0, 15),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/quranirab.png'),
                    radius: 20.0,
                  ),

                  // child: Text(
                  //   'Settings',
                  //   style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(255, 0, 0, 0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                    color: Theme.of(context).textSelectionTheme.selectionColor,
                    iconSize: 20,
                    splashRadius: 15,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
            const SizedBox(height: 18),
            buildMenuItem(
                text: AppLocalizations.of(context)!.home,
                icon: Icons.home_outlined,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, RoutesName.homePage);
                },
                darkMode: themeProvider.isDarkMode),
            const SizedBox(height: 16),
            buildMenuItem(
                text: AppLocalizations.of(context)!.aboutUs,
                icon: Icons.info_outline,
                onTap: () async{
                  const url = 'https://aqwise.my/about-us/';
                  openBrowserURL(url: url, inApp: false);
                },
                darkMode: themeProvider.isDarkMode),
            const SizedBox(height: 16),
            buildMenuItem(
                text: AppLocalizations.of(context)!.userProfile,
                icon: Icons.person_outline,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserprofileWidget()));
                },
                darkMode: themeProvider.isDarkMode),
            const SizedBox(height: 16),
            buildMenuItem(
                text: AppLocalizations.of(context)!.privacy,
                icon: Icons.privacy_tip_outlined,
                onTap: () {
                  if (kIsWeb){
                    launchUrl(Uri.parse(_url));
                  }else{
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Privacypolicy()));
                  }
                },
                darkMode: themeProvider.isDarkMode),
            const SizedBox(height: 16),
            buildMenuItem(
                text: AppLocalizations.of(context)!.feedback,
                icon: Icons.feedback_outlined,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => EmailScreen()));
                },
                darkMode: themeProvider.isDarkMode),
            const SizedBox(height: 16),
            buildMenuItem(
              text: AppLocalizations.of(context)!.help,
              icon: Icons.help_outline,
              onTap: () {},
              darkMode: themeProvider.isDarkMode,
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              darkMode: themeProvider.isDarkMode,
              text: AppLocalizations.of(context)!.leaderboard,
              icon: Icons.score_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LeaderBoardMenu()));
              },
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              darkMode: themeProvider.isDarkMode,
              text: AppLocalizations.of(context)!.logout,
              icon: Icons.exit_to_app,
              onTap: () async {
                Navigator.pop(context);
                await AppUser.instance.signOut();
                Navigator.pushReplacementNamed(context, RoutesName.loginPage);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    required bool darkMode,
    required var onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: (darkMode) ? Colors.white : Colors.black),
      title: Text(text,
          style: TextStyle(
            color: (darkMode) ? Colors.white : Colors.black,
          )),
      onTap: onTap,
    );
  }

  void SelectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
  }

  Future openBrowserURL({
    required String url,
    bool inApp = false,
  }) async{
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: inApp,
        forceWebView: inApp,
        enableJavaScript: true,
      );
    }
  }
}
