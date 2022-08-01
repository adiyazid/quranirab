import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:credit_card_validator/validation_results.dart';
import 'package:flutter/material.dart';

class CardProvider extends ChangeNotifier {
  String? ccNum;
  String? expDate;
  String? cvv;
  ValidationResults? expDateResults;
  CCNumValidationResults? ccNumResults;
  ValidationResults? cvvResults;
  final CreditCardValidator _ccValidator = CreditCardValidator();

  bool validateCreditCardInfo() {
    if (ccNum != null && expDate != null && cvv != null) {
      var ccNumResults = _ccValidator.validateCCNum(ccNum!);
      var expDateResults = _ccValidator.validateExpDate(expDate!);
      var cvvResults = _ccValidator.validateCVV(cvv!, ccNumResults.ccType);

      if (ccNumResults.isPotentiallyValid &&
          expDateResults.isValid &&
          cvvResults.isValid) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  String setDate(String v) {
    expDate = v;
    expDateResults = _ccValidator.validateExpDate(v);
    notifyListeners();
    return expDateResults!.message;
  }

  String setCard(String v) {
    ccNum = v;
    ccNumResults = _ccValidator.validateCCNum(v);
    notifyListeners();
    return ccNumResults!.message;
  }

  String setCvv(String v) {
    if (ccNumResults != null) {
      cvv = v;
      cvvResults = _ccValidator.validateCVV(v, ccNumResults!.ccType);
      return cvvResults!.message;
    } else {
      cvv = v;
      return 'Insert Card First';
    }
  }
}
