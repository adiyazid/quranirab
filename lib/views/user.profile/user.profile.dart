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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../theme/theme_provider.dart';
import '../../widget/appbar.widget.dart';
import 'container.update.dart';
import 'name.update.dart';

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
  var _obsecure = true;
  var _obsecure2 = true;
  var _obsecure3 = true;
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
      webPosition: "center",
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 24.0,
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
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: 2.0,
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : const Color(0xffE86F00)),
              ),
            ),
            height: 57,
            child: CustomScrollView(
              slivers: const [Appbar()],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Text(
            AppLocalizations.of(context)!.userProfile,
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
              radius: 85,
              child: CircleAvatar(
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
                              color: themeProvider.isDarkMode
                                  ? white
                                  : Colors.orangeAccent,
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
                  )),
            )
          else
            (kIsWeb)
                ? CircleAvatar(
                    radius: 85,
                    child: CircleAvatar(
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
                text: first_name ?? AppLocalizations.of(context)!.firstName,
                controller: fnamecontroller,
              ),
              SizedBox(
                width: 18,
              ),
              NameUpdate(
                text: last_name ?? AppLocalizations.of(context)!.lastName,
                controller: lnamecontroller,
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          ContainerUpdate(
            text: AppLocalizations.of(context)!.currentPassword,
            controller: currentpass,
            obsecure: _obsecure,
          ),
          SizedBox(
            height: 16,
          ),
          ContainerUpdate(
            text: AppLocalizations.of(context)!.newPassword,
            controller: newpassword,
            obsecure: _obsecure2,
          ),
          SizedBox(
            height: 16,
          ),
          ContainerUpdate(
            text: AppLocalizations.of(context)!.confirmPass,
            controller: confirmpass,
            obsecure: _obsecure3,
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              updateProfile(context);
            },
            child: Container(
                width: MediaQuery.of(context).size.width < 600
                    ? MediaQuery.of(context).size.width * 0.85
                    : 522,
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
                  child: Text(
                    AppLocalizations.of(context)!.saveChanges,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                )),
          ),
          SizedBox(
            height: 16,
          ),
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
        showToast(AppLocalizations.of(context)!.noFile);
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
        showToast(AppLocalizations.of(context)!.noFile);
      }
    } else {
      showToast(AppLocalizations.of(context)!.permissionError);
    }
  }

  updateProfile(BuildContext context) async {
    //Map<String, dynamic> map = {};
    String? url;
    if (xfile != null) {
      User? currentUser = FirebaseAuth.instance.currentUser;
      url = await uploadImage();
      currentUser?.updatePhotoURL(url);
      showToast(AppLocalizations.of(context)!.imageSuccess);
      Navigator.pop(context);
    }
    if (fnamecontroller.text.isNotEmpty && lnamecontroller.text.isNotEmpty) {
      Provider.of<AppUser>(context, listen: false).updatedata(
          fnamecontroller.text,
          lnamecontroller.text,
          AppUser.instance.user!.email!);
      showToast(AppLocalizations.of(context)!.profileSuccess);
      Navigator.pop(context);
    }

    if (currentpass.text.isNotEmpty &&
        newpassword.text.isNotEmpty &&
        confirmpass.text.isNotEmpty) {
      if (newpassword.text.length < 6 && confirmpass.text.length < 6) {
        showToast(AppLocalizations.of(context)!.passwordLengthError);
      } else if (newpassword.text != confirmpass.text) {
        showToast(AppLocalizations.of(context)!.passwordError);
      } else {
        Provider.of<AppUser>(context, listen: false)
            .updatePassword(newpassword.text);
        showToast(AppLocalizations.of(context)!.passwordSuccess);
        Navigator.pop(context);
      }
    }
    if (xfile == null &&
        currentpass.text.isEmpty &&
        newpassword.text.isEmpty &&
        confirmpass.text.isEmpty &&
        fnamecontroller.text.isEmpty &&
        lnamecontroller.text.isEmpty) {
      showToast(AppLocalizations.of(context)!.noChanges);
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
