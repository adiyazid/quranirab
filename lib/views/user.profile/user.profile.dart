import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/widget/menu.dart';

import '../../theme/theme_provider.dart';
import '../../widget/appbar.widget.dart';

class UserprofileWidget extends StatefulWidget {
  const UserprofileWidget({Key? key}) : super(key: key);

  @override
  _UserprofileWidgetState createState() => _UserprofileWidgetState();
}

class _UserprofileWidgetState extends State<UserprofileWidget> {
  String? first_name;
  String? last_name;

  var lnamecontroller = TextEditingController();

  var fnamecontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator UserprofileWidget - FRAME
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      drawer: Menu(),
      backgroundColor: themeProvider.isDarkMode
          ? Color(0xff808BA1)
          : Color.fromRGBO(255, 255, 255, 1),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: CustomScrollView(
              slivers: const [Appbar()],
            ),
          ),
          Text(
            AppUser.instance.user!.displayName!,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 36,
                letterSpacing: -0.38723403215408325,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          Text(
            'User Profile',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 36,
                letterSpacing: -0.38723403215408325,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          SizedBox(
            height: 24,
          ),
          CircleAvatar(
            backgroundImage: AssetImage(themeProvider.isDarkMode
                ? "images/dark.jpg"
                : "images/light.jpg"),
            radius: 80,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Positioned(
                  right: 16,
                  top: 116,
                  child: ClipOval(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("test1"),
                              );
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.white,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NameUpdate(
                text: first_name ?? 'First name',
                controller: fnamecontroller,
              ),
              SizedBox(
                width: 18,
              ),
              NameUpdate(
                text: last_name ?? 'Last name',
                controller: lnamecontroller,
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          ContainerUpdate(
            text: 'Current password',
          ),
          SizedBox(
            height: 16,
          ),
          ContainerUpdate(
            text: 'New password',
          ),
          SizedBox(
            height: 16,
          ),
          ContainerUpdate(
            text: 'Confirm password',
          ),
          SizedBox(
            height: 16,
          ),
          Container(
              width: 522,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: themeProvider.isDarkMode
                    ? Color(0xff67748E)
                    : Color.fromRGBO(255, 181, 94, 1),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (fnamecontroller.value.text.isNotEmpty){
                      print (fnamecontroller.value.text);
                    }
                    if (lnamecontroller.value.text.isNotEmpty){
                    print (lnamecontroller.value.text);
                    }
                  },
                  child: Text(
                    'Save Changes',
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
              )),
        ]),
      ),
    );
  }

  void getName() {
    var name = AppUser.instance.user!.displayName!;
    setState(() {
      first_name = name.split(" ")[0];
      last_name = name.split(" ")[1];
    });
  }
}

class NameUpdate extends StatelessWidget {
  final String text;
  final TextEditingController controller;

  const NameUpdate({
    required this.text,
    required this.controller,
    Key? key,
  }) : super(key: key);

  get theColor => Colors.transparent;

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    return Container(
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: theme.isDarkMode
              ? Color(0xff808BA1)
              : Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(
            color: theme.isDarkMode
                ? Color(0xff67748E)
                : Color.fromRGBO(255, 181, 94, 1),
            width: 1,
          ),
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: controller,
            cursorColor: theme.isDarkMode ? Colors.white : Colors.black,
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
                hintText: text,
                hintStyle: TextStyle(
                    color: theme.isDarkMode
                        ? Colors.white
                        : const Color.fromRGBO(151, 151, 151, 1),
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1)),
          ),
        )));
  }
}

class ContainerUpdate extends StatelessWidget {
  final String text;

  const ContainerUpdate({
    required this.text,
    Key? key,
  }) : super(key: key);

  get theColor => Colors.transparent;

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    return Container(
        width: 522,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: theme.isDarkMode
              ? Color(0xff808BA1)
              : Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(
            color: theme.isDarkMode
                ? Color(0xff67748E)
                : Color.fromRGBO(255, 181, 94, 1),
            width: 1,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              cursorColor: theme.isDarkMode ? Colors.white : Colors.black,
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
                  hintText: text,
                  hintStyle: TextStyle(
                      color: theme.isDarkMode
                          ? Colors.white
                          : const Color.fromRGBO(151, 151, 151, 1),
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                      height: 1)),
            ),
          ),
        ));
  }
}
