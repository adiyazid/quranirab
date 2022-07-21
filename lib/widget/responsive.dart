import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Function() mobile;
  final Function()? tablet;
  final Function() desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return Container(child: desktop());
        } else if (constraints.maxWidth >= 800) {
          return tablet != null ? tablet!() : Container(child: mobile());
        } else {
          return Container(child: mobile());
        }
      },
    );
  }
}
