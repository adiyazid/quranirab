import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/services/stripe.service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quranirab/views/payment/payment.screen.dart';
import 'package:quranirab/views/payment/receipt.screen.dart';

class PaymentValidationProvider with ChangeNotifier {
  // Validation Variables
  bool? _phoneNumIsValid;
  bool? _cardNumIsValid;
  bool? _cvvNumIsValid;
  bool? _cardNameIsValid;
  bool? _cardDateIsValid;

  // Checkout function Variables
  String? phone;
  String? cardNumber;
  String? expiryDate;
  String? cardHolderName;
  String? cvvCode;

  //GETTERS
  bool? get phoneNumIsValid => _phoneNumIsValid;

  bool? get cardNumIsValid => _cardNumIsValid;

  bool? get cvvNumIsValid => _cvvNumIsValid;

  bool? get cardNameIsValid => _cardNameIsValid;

  bool? get cardDateIsValid => _cardDateIsValid;

  //SETTERS
  void validatePhoneNum(String value) {
    final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    if (regExp.hasMatch(value)) {
      _phoneNumIsValid = true;
      phone = value;
    } else {
      _phoneNumIsValid = false;
    }
    notifyListeners();
  }

  void validateCardNum(String value) {
    if (19 <= value.length) {
      _cardNumIsValid = true;
      cardNumber = value;
    } else {
      _cardNumIsValid = false;
    }
    notifyListeners();
  }

  void validateCvv(String value) {
    if (value.length == 3 && value.isInt) {
      _cvvNumIsValid = true;
      cvvCode = value;
    } else {
      _cvvNumIsValid = false;
    }
    notifyListeners();
  }

  void validateCardName(String value) {
    if (value.isNotEmpty) {
      _cardNameIsValid = true;
      cardHolderName = value;
    } else {
      _cardNameIsValid = false;
    }
    notifyListeners();
  }

  void validateCardDate(String value) {
    final regExp = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$');
    if (regExp.hasMatch(value)) {
      _cardDateIsValid = true;
      expiryDate = value;
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
      return true;
    } else {
      return false;
    }
  }

  Future<void> checkout(
    BuildContext context,
  ) async {
    try {
      dynamic customer;
      dynamic paymentIntent;
      dynamic paymentMethod;
      var custId = Provider.of<AppUser>(context, listen: false).cid;
      if (Provider.of<AppUser>(context, listen: false).cid == null) {
        customer = await StripeService.createCustomer(cardHolderName!,
            '+6' + phone!, AppUser.instance.user!.email!, cardHolderName!);
        notifyListeners();
        custId = customer['id'];
        Provider.of<AppUser>(context, listen: false).setCid(custId);
      } else {
        customer = await StripeService.getCustomer(custId);
      }

      paymentMethod = await StripeService.createCardPaymentMethod(
          number: cardNumber!,
          expMonth: expiryDate!.substring(0, 2),
          expYear: '20${expiryDate!.substring(3)}',
          cvc: cvvCode!);
      notifyListeners();
      var paymentMethodID = paymentMethod['id'];
      var id = Provider.of<AppUser>(context, listen: false).pid;
      if (Provider.of<AppUser>(context, listen: false).pid == null) {
        paymentIntent = await StripeService.createPaymentIntent('5000', 'MYR');

        notifyListeners();
        id = paymentIntent!['id'];
        Provider.of<AppUser>(context, listen: false).setPid(id);
      } else {
        notifyListeners();
        paymentIntent = await StripeService.getIntent(id!);
      }
      await showDialog(
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.buyPremium + ' QuranIrab',
              ),
              content: ListTile(
                  title: Text('${AppLocalizations.of(context)!.name} : ' +
                      customer!['name']),
                  subtitle: Text(
                      '${AppLocalizations.of(context)!.amount} : RM ' +
                          paymentIntent!['amount'].toString().substring(0, 2))),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    dynamic paymentConfirm;
                    notifyListeners();
                    paymentConfirm = await StripeService.confirmPayment(
                        paymentIntent!['id'], paymentMethodID);
                    if (paymentConfirm['error'] != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Payment Fail. ${paymentConfirm['error']['message']}')));
                      Navigator.pop(context);
                    } else {
                      if (paymentConfirm['status'] == 'succeeded') {
                        Provider.of<AppUser>(context, listen: false).updateData(
                            paymentConfirm['charges']['data']
                                .last['receipt_url'],
                            paymentConfirm['status']);
                        Provider.of<AppUser>(context, listen: false).updateRole(
                            paymentConfirm['charges']['data']
                                .last['receipt_url'],
                            id,
                            custId);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Payment ${paymentConfirm['status']}')));
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(paymentConfirm['status'])));
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.confirmPayment),
                )
              ],
            );
          },
          context: context);
    } catch (e) {
      await showDialog(
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Payment Fail. ' + e.toString()),
            );
          },
          context: context);
    }
  }
}
