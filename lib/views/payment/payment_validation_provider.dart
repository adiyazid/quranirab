import 'package:flutter/material.dart';

class PaymentValidationProvider with ChangeNotifier {
  bool? _phoneNumIsValid;
  bool? _cardNumIsValid;
  bool? _cvvNumIsValid;
  bool? _cardNameIsValid;
  bool? _cardDateIsValid;
  //bool? _paymentIsValid;

  //GETTERS
  bool? get phoneNumIsValid => _phoneNumIsValid;
  bool? get cardNumIsValid => _cardNumIsValid;
  bool? get cvvNumIsValid => _cvvNumIsValid;
  bool? get cardNameIsValid => _cardNameIsValid;
  bool? get cardDateIsValid => _cardDateIsValid;
  //bool? get paymentIsValid => _paymentIsValid;

  //SETTERS
  void validatePhoneNum(String value) {
    final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    if (regExp.hasMatch(value)) {
      _phoneNumIsValid = true;
    } else {
      _phoneNumIsValid = false;
    }
    notifyListeners();
  }

  void validateCardNum(String value) {
    _cardNumIsValid = 19 <= value.length ? true : false;
    notifyListeners();
  }

  void validateCvv(String value) {
    _cvvNumIsValid = value.length == 3 ? true : false;
    notifyListeners();
  }

  void validateCardName(String value) {
    _cardNameIsValid = value.isNotEmpty ? true : false;
    notifyListeners();
  }

  void validateCardDate(String value) {
    final regExp = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$');
    if (regExp.hasMatch(value)) {
      _cardDateIsValid = true;
    } else {
      _cardDateIsValid = false;
    }
    notifyListeners();
  }

  bool validateAllPaymentFields() {
    _phoneNumIsValid ??= false;
    _cardNumIsValid ??= false;
    _cvvNumIsValid ??= false;
    _cardNameIsValid ??= false;
    _cardDateIsValid ??= false;
    notifyListeners();
    if (_phoneNumIsValid! &&
        _cardNumIsValid! &&
        _cvvNumIsValid! &&
        _cardNameIsValid! &&
        _cardDateIsValid!) {
      // _paymentIsValid = true;
      return true;
    } else {
      //_paymentIsValid = false;
      return false;
    }
  }
}
