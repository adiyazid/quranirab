import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/payment.output.dart';
import 'package:quranirab/views/payment/receipt.screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../provider/user.provider.dart';
import '../../services/stripe.service.dart';
import '../../theme/theme_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _phone = TextEditingController();
  var intentId = GetStorage().read('intent');
  PaymentOutput? _paymentOutput;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> checkout(BuildContext context, String phone, cardNumber,
      expiryDate, cardHolderName, cvvCode) async {
    try {
      var customer;
      var paymentIntent;
      var paymentMethod;
      var custId = Provider.of<AppUser>(context, listen: false).cid;
      if (Provider.of<AppUser>(context, listen: false).cid == null) {
        customer = await StripeService.createCustomer(cardHolderName,
            '+6' + phone, AppUser.instance.user!.email!, cardHolderName);
        setState(() {});
        custId = customer['id'];
        Provider.of<AppUser>(context, listen: false).setCid(custId);
      } else {
        customer = await StripeService.getCustomer(custId);
      }

      paymentMethod = await StripeService.createCardPaymentMethod(
          number: cardNumber,
          expMonth: expiryDate.substring(0, 2),
          expYear: '20${expiryDate.substring(3)}',
          cvc: cvvCode);
      setState(() {});
      var paymentMethodID = paymentMethod['id'];
      paymentIntent = await StripeService.createPaymentIntent('5000', 'MYR');
      var id = paymentIntent!['id'];
      showDialog(
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Buy QuranIrab Premium'),
              content: ListTile(
                  title: Text('Name: ' + customer!['name']),
                  subtitle: Text('Amount: RM ' +
                      paymentIntent!['amount'].toString().substring(0, 2) +
                      '\n' +
                      'Tel-No: ' +
                      _phone.text)),
              actions: [
                ElevatedButton.icon(
                  onPressed: () async {
                    var paymentConfirm;
                    try {
                      setState(() {});
                      paymentConfirm = await StripeService.confirmPayment(
                          paymentIntent!['id'], paymentMethodID);
                      setState(() {});
                      _paymentOutput =
                          paymentOutputFromJson(jsonEncode(paymentConfirm));
                      Navigator.pop(context);
                      if (_paymentOutput!.status == 'succeeded') {
                        Provider.of<AppUser>(context, listen: false).updateRole(
                            _paymentOutput!.charges.data.last.receiptUrl,
                            id,
                            custId);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Payment ${_paymentOutput!.status}')));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Error. Payment already made or card had been blacklist')));
                      Navigator.pop(context);
                    }
                  },
                  label: Text('Confirm Payment'),
                  icon: Icon(Icons.save),
                )
              ],
            );
          },
          context: context);
    } catch (e) {
      showDialog(
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(e.toString()),
            );
          },
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor:
      theme.isDarkMode ? const Color(0xFF67748E) : Colors.white,
      resizeToAvoidBottomInset: true,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              iconTheme: Theme.of(context).iconTheme,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text('Buy Premium QuranIrab'),
              centerTitle: false,
              floating: true,
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color:
                    theme.isDarkMode ? Colors.white : Colors.orangeAccent)),
          ),
          child: _paymentOutput == null
              ? Column(
            children: [
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                onCreditCardWidgetChange: (CreditCardBrand) {},
              ),
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CreditCardForm(
                          cardNumber: cardNumber,
                          expiryDate: expiryDate,
                          cardHolderName: cardHolderName,
                          cvvCode: cvvCode,
                          onCreditCardModelChange: onCreditCardModelChange,
                          themeColor: Theme.of(context).primaryColor,
                          formKey: formKey,
                          cardNumberDecoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color:
                                  theme.isDarkMode ? Colors.white : null),
                              hintStyle: TextStyle(
                                  color:
                                  theme.isDarkMode ? Colors.white : null),
                              border: OutlineInputBorder(),
                              label: Text('Number'),
                              hintText: 'xxxx xxxx xxxx xxxx'),
                          expiryDateDecoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color:
                                  theme.isDarkMode ? Colors.white : null),
                              hintStyle: TextStyle(
                                  color:
                                  theme.isDarkMode ? Colors.white : null),
                              border: OutlineInputBorder(),
                              label: Text('Expired Date'),
                              hintText: 'xx/xx'),
                          cvvCodeDecoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color:
                                  theme.isDarkMode ? Colors.white : null),
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(
                                  color:
                                  theme.isDarkMode ? Colors.white : null),
                              label: Text('CVV'),
                              hintText: 'xxx'),
                          cardHolderDecoration: InputDecoration(
                            labelStyle: TextStyle(
                                color:
                                theme.isDarkMode ? Colors.white : null),
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                color:
                                theme.isDarkMode ? Colors.white : null),
                            label: Text('Card Holder'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 1, color: Colors.blue),
                              ),
                              labelStyle: TextStyle(
                                  color:
                                  theme.isDarkMode ? Colors.white : null),
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(
                                  color:
                                  theme.isDarkMode ? Colors.white : null),
                              label: Text('Phone Number'),
                            ),
                            validator: (e) {
                              if (e!.isEmpty) {
                                return 'Phone number cannot be null';
                              }
                            },
                            controller: _phone,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: false),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              primary: Color(0xff1b447b)),
                          child: Container(
                            margin: EdgeInsets.all(8.0),
                            child: Text(
                              'validate',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'halter',
                                fontSize: 14,
                                package: 'flutter_credit_card',
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await checkout(context, _phone.text, cardNumber,
                                  expiryDate, cardHolderName, cvvCode);
                              print('valid');
                            } else {
                              print('inValid');
                            }
                          },
                        )
                      ],
                    ),
                  )),
            ],
          )
              : Column(
            children: [
              Flexible(
                child: ListView(
                  children: [
                    ListTile(
                        title: Text('Payment ID'),
                        subtitle: Text(_paymentOutput!.id)),
                    ListTile(
                        title: Text('Payment Status'),
                        subtitle: Text(_paymentOutput!.status)),
                    ListTile(
                        title: Text('Payment Amount'),
                        subtitle: Text(_paymentOutput!.currency +
                            ' ' +
                            _paymentOutput!.amount.toString().substring(
                                0,
                                _paymentOutput!.amount.toString().length -
                                    2))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.orange),
                          onPressed: () async {
                            if (!kIsWeb) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ReceiptScreen(
                                          _paymentOutput!.charges.data
                                              .last.receiptUrl)));
                            } else {
                              launchUrl(Uri.parse(_paymentOutput!
                                  .charges.data.last.receiptUrl));
                            }
                          },
                          child: Text('Get Receipt')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
