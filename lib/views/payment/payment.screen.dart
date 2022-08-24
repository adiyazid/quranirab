import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/views/payment/receipt.screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../provider/user.provider.dart';
import '../../services/stripe.service.dart';
import '../../theme/theme_provider.dart';
import 'generated/group1widget.dart';
import 'generated/group2widget.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
  }

  final _phone = TextEditingController();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> checkout(BuildContext context, String phone, cardNumber,
      expiryDate, cardHolderName, cvvCode) async {
    try {
      dynamic customer;
      dynamic paymentIntent;
      dynamic paymentMethod;
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
      var id = Provider.of<AppUser>(context, listen: false).pid;
      if (Provider.of<AppUser>(context, listen: false).pid == null) {
        paymentIntent = await StripeService.createPaymentIntent('5000', 'MYR');

        setState(() {});
        id = paymentIntent!['id'];
        Provider.of<AppUser>(context, listen: false).setPid(id);
      } else {
        setState(() {});
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
                    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return SafeArea(
      child: Consumer<AppUser>(builder: (context, app, _) {
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
                  title: Text(
                    AppLocalizations.of(context)!.buyPremium + ' QuranIrab',
                    style: TextStyle(
                        color: theme.isDarkMode ? Colors.white : Colors.orange),
                  ),
                  centerTitle: false,
                  floating: true,
                ),
              ];
            },
            body: kIsWeb
                ? ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: theme.isDarkMode
                                        ? Colors.white
                                        : Colors.orangeAccent)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 40),
                            child: app.receipt == null
                                ? Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.center,
                                    spacing: 16.0,
                                    children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.zero,
                                          child: Container(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                        ),
                                        Group1Widget(),
                                        Group2Widget()
                                      ])
                                : Consumer<AppUser>(builder: (context, app, _) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Column(
                                        children: [
                                          Flexible(
                                            child: ListView(
                                              children: [
                                                ListTile(
                                                    title: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .paymentID),
                                                    subtitle: Text(app.pid!)),
                                                ListTile(
                                                    title: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .paymentStatus),
                                                    subtitle:
                                                        Text(app.status!)),
                                                ListTile(
                                                    title: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .paymentAmount),
                                                    subtitle: Text('RM 50.00')),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: Colors
                                                                  .orange),
                                                      onPressed: () async {
                                                        if (!kIsWeb) {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ReceiptScreen(
                                                                          app.receipt!)));
                                                        } else {
                                                          launchUrl(Uri.parse(
                                                              app.receipt!));
                                                        }
                                                      },
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .getReceipt)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                          ),
                        ),
                      );
                    }),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: theme.isDarkMode
                                  ? Colors.white
                                  : Colors.orangeAccent)),
                    ),
                    child: app.receipt == null
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
                                      onCreditCardModelChange:
                                          onCreditCardModelChange,
                                      themeColor:
                                          Theme.of(context).primaryColor,
                                      formKey: formKey,
                                      cardNumberDecoration: InputDecoration(
                                          labelStyle: TextStyle(
                                              color: theme.isDarkMode
                                                  ? Colors.white
                                                  : null),
                                          hintStyle: TextStyle(
                                              color: theme.isDarkMode
                                                  ? Colors.white
                                                  : null),
                                          border: OutlineInputBorder(),
                                          label: Text(
                                              AppLocalizations.of(context)!
                                                  .number),
                                          hintText: 'xxxx xxxx xxxx xxxx'),
                                      expiryDateDecoration: InputDecoration(
                                          labelStyle: TextStyle(
                                              color: theme.isDarkMode
                                                  ? Colors.white
                                                  : null),
                                          hintStyle: TextStyle(
                                              color: theme.isDarkMode
                                                  ? Colors.white
                                                  : null),
                                          border: OutlineInputBorder(),
                                          label: Text(
                                              AppLocalizations.of(context)!
                                                  .expiredDate),
                                          hintText: 'xx/xx'),
                                      cvvCodeDecoration: InputDecoration(
                                          labelStyle: TextStyle(
                                              color: theme.isDarkMode
                                                  ? Colors.white
                                                  : null),
                                          border: OutlineInputBorder(),
                                          hintStyle: TextStyle(
                                              color: theme.isDarkMode
                                                  ? Colors.white
                                                  : null),
                                          label: Text('CVV'),
                                          hintText: 'xxx'),
                                      cardHolderDecoration: InputDecoration(
                                        labelStyle: TextStyle(
                                            color: theme.isDarkMode
                                                ? Colors.white
                                                : null),
                                        border: OutlineInputBorder(),
                                        hintStyle: TextStyle(
                                            color: theme.isDarkMode
                                                ? Colors.white
                                                : null),
                                        label: Text(
                                            AppLocalizations.of(context)!
                                                .cardHolder),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: Colors.blue),
                                          ),
                                          labelStyle: TextStyle(
                                              color: theme.isDarkMode
                                                  ? Colors.white
                                                  : null),
                                          border: OutlineInputBorder(),
                                          hintStyle: TextStyle(
                                              color: theme.isDarkMode
                                                  ? Colors.white
                                                  : null),
                                          label: Text(
                                              AppLocalizations.of(context)!
                                                  .phoneNumber),
                                        ),
                                        validator: (e) {
                                          if (e!.isEmpty) {
                                            return 'Phone number cannot be null';
                                          }
                                        },
                                        controller: _phone,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: false),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          primary: Color(0xff1b447b)),
                                      child: Container(
                                        margin: EdgeInsets.all(8.0),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .validate,
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
                                          await checkout(
                                              context,
                                              _phone.text,
                                              cardNumber,
                                              expiryDate,
                                              cardHolderName,
                                              cvvCode);
                                          if (kDebugMode) {
                                            print('valid');
                                          }
                                        } else {
                                          if (kDebugMode) {
                                            print('inValid');
                                          }
                                        }
                                      },
                                    )
                                  ],
                                ),
                              )),
                            ],
                          )
                        : Consumer<AppUser>(builder: (context, app, _) {
                            return Column(
                              children: [
                                Flexible(
                                  child: ListView(
                                    children: [
                                      ListTile(
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .paymentID),
                                          subtitle: Text(app.pid!)),
                                      ListTile(
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .paymentStatus),
                                          subtitle: Text(app.status!)),
                                      ListTile(
                                          title: Text(
                                              AppLocalizations.of(context)!
                                                  .paymentAmount),
                                          subtitle: Text('RM 50.00')),
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
                                                        builder: (context) =>
                                                            ReceiptScreen(
                                                                app.receipt!)));
                                              } else {
                                                launchUrl(
                                                    Uri.parse(app.receipt!));
                                              }
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .getReceipt)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                  ),
          ),
        );
      }),
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
