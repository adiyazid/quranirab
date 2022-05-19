import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
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
  XFile? xfile;
  late File file;
  bool _load = false;
  Uint8List webImage = Uint8List(10);
  String? photoUrl;
  String? first_name;
  String? last_name;

  var lnamecontroller = TextEditingController();

  var fnamecontroller = TextEditingController();

  var currentpass = TextEditingController();
  var newpassword = TextEditingController();
  var confirmpass = TextEditingController();

  Future<PermissionStatus> requestPermissions() async {
    if (kIsWeb) return PermissionStatus.granted;
    await Permission.photos.request();
    return Permission.photos.status;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getImage();
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator UserprofileWidget - FRAME
    var themeProvider = Provider.of<ThemeProvider>(context);
    var imageDefault = themeProvider.isDarkMode
        ? 'https://firebasestorage.googleapis.com/v0/b/quranirab-74bba.appspot.com/o/profile%2Fdark.jpg?alt=media&token=87cba8ce-77aa-4940-be72-3830ee3e4edc'
        : 'https://firebasestorage.googleapis.com/v0/b/quranirab-74bba.appspot.com/o/profile%2Flight.jpg?alt=media&token=e13edb76-a409-4b3c-9bf2-57ba7dc7f609';
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
          if (_load == false)
            CircleAvatar(
                radius: 80,
                child: //if want to display the uploaded profile picture need to run at the terminal
                    //flutter run -d chrome --web-renderer html
                    //or need to setup CORS Configuration
                    // refer https://stackoverflow.com/questions/65653801/flutter-web-cant-load-network-image-from-another-domain
                    CachedNetworkImage(
                  imageUrl: photoUrl ?? imageDefault,
                  imageBuilder: (context, imageProvider) =>
                      Stack(alignment: Alignment.topRight, children: [
                    ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.low,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: 116,
                      child: ClipOval(
                        child: GestureDetector(
                          onTap: () {
                            chooseImage();
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
                  ]),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Stack(alignment: Alignment.topRight, children: [
                    Positioned(
                      right: 16,
                      top: 116,
                      child: ClipOval(
                        child: GestureDetector(
                          onTap: () {
                            chooseImage();
                            /*showDialog(
                                context: context,
                                builder:
                                    (BuildContext context) {
                                  return AlertDialog(title: Text("test1"),);
                                });*/
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
                  ]),
                ))
          else
            (kIsWeb)
                ? CircleAvatar(
                    //backgroundImage: AssetImage(themeProvider.isDarkMode?"images/dark.jpg":"images/light.jpg"),
                    radius: 80,
                    child: Stack(
                      children: [
                        ClipOval(
                          child: Image.memory(
                            webImage,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 16,
                          top: 116,
                          child: ClipOval(
                            child: GestureDetector(
                              onTap: () {
                                chooseImage();
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
                  )
                : Image.file(file),
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
            controller: currentpass,
          ),
          SizedBox(
            height: 16,
          ),
          ContainerUpdate(
            text: 'New password',
            controller: newpassword,
          ),
          SizedBox(
            height: 16,
          ),
          ContainerUpdate(
            text: 'Confirm password',
            controller: confirmpass,
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
                    if (fnamecontroller.value.text.isNotEmpty) {
                      print(fnamecontroller.value.text);
                    }
                    if (lnamecontroller.value.text.isNotEmpty) {
                      print(lnamecontroller.value.text);
                    }
                    updateProfile(context);
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

  chooseImage() async {
    var permissionStatus = requestPermissions();
    if (kIsWeb) {
      xfile = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxWidth: 300, maxHeight: 300);
      print("file " + xfile!.path);
      if (xfile != null) {
        var f = await xfile!.readAsBytes();
        setState(() {
          file = File(xfile!.path);
          webImage = f;
          _load = true;
        });
      } else {
        showToast("No file selected");
      }
    } else if (!kIsWeb && await permissionStatus.isGranted) {
      xfile = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxWidth: 300, maxHeight: 300);
      print("file " + xfile!.path);
      if (xfile != null) {
        var f = File(xfile!.path);
        setState(() {
          file = f;
          //webImage = f;
          _load = true;
        });
      } else {
        showToast("No file selected");
      }
    } else {
      showToast("Permission not granted");
    }
  }

  updateProfile(BuildContext context) async {
    //Map<String, dynamic> map = {};
    String? url;
    if (xfile != null) {
      User? currentUser = FirebaseAuth.instance.currentUser;
      url = await uploadImage();
      currentUser?.updatePhotoURL(url);
      showToast("Profile Images successfully updated!");
      Navigator.pop(context);
      // if (fnamecontroller.text.isNotEmpty && lnamecontroller.text.isNotEmpty) {
      //   User? currentUser = FirebaseAuth.instance.currentUser;
      //   url = await uploadImage();
      //   currentUser?.updatePhotoURL(url);
      //   //map['profileImage'] = url;
      //   //map['first_name'] = _textEditingController.text;
      // } else {
      //   showToast("Please fill in the information!");
      // }
    } else {
      /*showToast("Please choose the image!");
      if (fnamecontroller.text.isEmpty && lnamecontroller.text.isEmpty) {
        showToast("Please fill in the information!");
      }*/
    }
    if (fnamecontroller.text.isNotEmpty && lnamecontroller.text.isNotEmpty) {
      Provider.of<AppUser>(context, listen: false).updatedata(
          fnamecontroller.text,
          lnamecontroller.text,
          AppUser.instance.user!.email!);
      showToast("Profile successfully updated!");
      Navigator.pop(context);
    }
    if (currentpass.text.isNotEmpty &&
        newpassword.text.isNotEmpty &&
        confirmpass.text.isNotEmpty) {
      if (newpassword.text != confirmpass.text) {
        showToast("Password are not match");
      }
      Provider.of<AppUser>(context, listen: false)
          .updatePassword(newpassword.text);
        showToast("Password successfully updated!");
    }
  }

  Future<String> uploadImage() async {
    TaskSnapshot taskSnapshot = await FirebaseStorage.instance
        .refFromURL('gs://quranirab-74bba.appspot.com')
        .child("profile")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .putData(
          await xfile!.readAsBytes(),
          SettableMetadata(contentType: 'image/jpeg'),
        );
    taskSnapshot.ref.getDownloadURL().then((value) => print("Done: $value"));

    return taskSnapshot.ref.getDownloadURL();
  }

  void getImage() {
    var profileImage = AppUser.instance.user!.photoURL;
    setState(() {
      photoUrl = profileImage;
    });
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
  final TextEditingController controller;

  const ContainerUpdate({
    required this.text,
    required this.controller,
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
              obscureText: true,
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
          ),
        ));
  }
}
