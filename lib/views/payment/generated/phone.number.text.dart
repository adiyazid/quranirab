import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/views/payment/payment_validation_provider.dart';

import '../../../theme/theme_provider.dart';

class PhoneNumberText extends StatefulWidget {
  @override
  State<PhoneNumberText> createState() => _PhoneNumberTextState();
}

class _PhoneNumberTextState extends State<PhoneNumberText> {
  final _phone = TextEditingController();

  bool labelHidden = false;

  @override
  Widget build(BuildContext context) {
    final validationProvider =
        Provider.of<PaymentValidationProvider>(context, listen: true);
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.isDarkMode
          ? Color(0xff67748E)
          : Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Material(
          color: theme.isDarkMode ? Color(0xff67748E) : Colors.white,
          child: TextFormField(
            controller: _phone,
            decoration: InputDecoration(
                errorText: validationProvider.phoneNumIsValid != null &&
                        !validationProvider.phoneNumIsValid!
                    ? 'Phone Number not valid! Eg: 60134567890'
                    : null,
                errorStyle: TextStyle(
                    color: theme.isDarkMode ? Colors.tealAccent : Colors.red),
                border: InputBorder.none,
                filled: true,
                fillColor: theme.isDarkMode ? Color(0xff67748E) : Colors.white,
                labelText: labelHidden ? null : ('Phone Number'),
                labelStyle:
                    TextStyle(color: theme.isDarkMode ? white : Colors.black)),
            style: TextStyle(color: theme.isDarkMode ? white : Colors.black),
            onChanged: (String value) {
              Provider.of<PaymentValidationProvider>(context, listen: false)
                  .validatePhoneNum(value);
              if (value.isEmpty) {
                setState(() {});
                labelHidden = false;
              } else {
                setState(() {});
                labelHidden = true;
              }
            },
          ),
        ),
      ),
    );
  }
}
