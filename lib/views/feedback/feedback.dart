import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'package:quranirab/widget/LanguagePopup.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.popup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../theme/theme_provider.dart';

class EmailScreen extends StatefulWidget {
  static String tag = '/MLEmailScreen';

  const EmailScreen({Key? key}) : super(key: key);

  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String? brand;
  String? device;
  String? model;
  String? version;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    // _initPackageInfo();
    // initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData =
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        } else if (Platform.isLinux) {
          deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
        } else if (Platform.isMacOS) {
          deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
        } else if (Platform.isWindows) {
          deviceData =
              _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'androidId': build.androidId,
    'systemFeatures': build.systemFeatures,
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname:': data.utsname.sysname,
    'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    'utsname.machine:': data.utsname.machine,
  };
}

Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'version': data.version,
    'id': data.id,
    'idLike': data.idLike,
    'versionCodename': data.versionCodename,
    'versionId': data.versionId,
    'prettyName': data.prettyName,
    'buildId': data.buildId,
    'variant': data.variant,
    'variantId': data.variantId,
    'machineId': data.machineId,
  };
}

Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
  return <String, dynamic>{
    'browserName': describeEnum(data.browserName),
    'appCodeName': data.appCodeName,
    'appName': data.appName,
    'appVersion': data.appVersion,
    'deviceMemory': data.deviceMemory,
    'language': data.language,
    'languages': data.languages,
    'platform': data.platform,
    'product': data.product,
    'productSub': data.productSub,
    'userAgent': data.userAgent,
    'vendor': data.vendor,
    'vendorSub': data.vendorSub,
    'hardwareConcurrency': data.hardwareConcurrency,
    'maxTouchPoints': data.maxTouchPoints,
  };
}

Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
  return <String, dynamic>{
    'computerName': data.computerName,
    'hostName': data.hostName,
    'arch': data.arch,
    'model': data.model,
    'kernelVersion': data.kernelVersion,
    'osRelease': data.osRelease,
    'activeCPUs': data.activeCPUs,
    'memorySize': data.memorySize,
    'cpuFrequency': data.cpuFrequency,
    'systemGUID': data.systemGUID,
  };
}

Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
  return <String, dynamic>{
    'numberOfCores': data.numberOfCores,
    'computerName': data.computerName,
    'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
  };
}

  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Confirm to exit app?'),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            print('yes selected');
                            exit(0);
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red.shade800),
                          child: const Text('Yes'),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              print('no selected');
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                            child: const Text('No',
                                style: TextStyle(color: Colors.black)),
                          ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

final _formKey = GlobalKey<FormState>();
final nameController = TextEditingController();
final subjectController = TextEditingController();
final messageController = TextEditingController();

@override
Widget build(BuildContext context) {
var themeProvider = Provider.of<ThemeProvider>(context);

return Scaffold(
    drawer: const Menu(),
    body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                iconTheme: Theme.of(context).iconTheme,
                leading: IconButton(
                  icon: const Icon(
                    Icons.menu,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: const CircleAvatar(
                  backgroundImage: AssetImage('assets/quranirab.png'),
                  radius: 18.0,
                ),
                centerTitle: false,
                floating: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          size: 26.0,
                        )),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: LangPopup()),
                  const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: SettingPopup()),
                ],
              ),
            ];
          },



  body: Padding(
    padding: const EdgeInsets.all(0.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              width: 2.0,
              color: themeProvider.isDarkMode
                  ? Colors.white
                  : const Color(0xffE86F00)),
        ),
        color: themeProvider.isDarkMode
            ? const Color(0xff808BA1)
            : const Color.fromRGBO(255, 237, 173, 1),
      ),
      child: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left : 20.00,
                    right : 20.00,
                  ),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.name, style: TextStyle(color : themeProvider.isDarkMode ?Colors.white : Colors.black,)),
                        border: OutlineInputBorder(),),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left : 20.00,
                    right : 20.00,
                  ),
                  child: TextFormField(
                    controller: subjectController,
                    decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context)!.subject, style: TextStyle(color : themeProvider.isDarkMode ?Colors.white : Colors.black,)),
                        border: OutlineInputBorder(),),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left : 20.00,
                    right : 20.00,
                  ),
                  child: TextFormField(
                    controller: messageController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context)!.body, style: TextStyle(color : themeProvider.isDarkMode ?Colors.white : Colors.black,)),
                        border: OutlineInputBorder(),),
                    maxLines: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left : 20.00,
                    right : 20.00,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await sendEmail(
                          nameController.value.text,
                          'rzainal@gmail.com',
                          subjectController.value.text,
                          messageController.value.text,

                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                            response == 200
                                ? const SnackBar(
                                content: Text('Message Sent!'),
                                backgroundColor: Colors.green)
                                : const SnackBar(
                                content: Text('Failed to send message!'),
                                backgroundColor: Colors.red));
                        nameController.clear();
                        subjectController.clear();
                        messageController.clear();
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.submit,
                    style: TextStyle(color: themeProvider.isDarkMode ?Colors.white : Colors.black,)),
                  ),
                ),
              ],
            ),
          ),
        ),
       ),
    ),
    ),
   )
  )
 );
}

  Future sendEmail(String name, String email, String subject, String message,
      ) async {
    const serviceId = 'service_6lja4yp';
    const templateId = 'template_pmqipei';
    const userId = '7oBv-Wgkr224QQXQd';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user_name': name,
            'user_email': email,
            'user_subject': subject,
            'user_message': message,

          },
        }));
    return response.statusCode;
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }
}