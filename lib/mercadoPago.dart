import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:app_imprenta/utils/globals.dart' as globals;
import 'package:mercadopago_sdk/mercadopago_sdk.dart';

class MercadoPago extends StatefulWidget {
  @override
  MercadoPagoState createState() => MercadoPagoState();
}

class MercadoPagoState extends State<MercadoPago> {
  /*@override
  initState() {
    const channelMercadoPagoRespuesta =
        const MethodChannel("waviacademy.com/mercadoPagoRespuesta");

    channelMercadoPagoRespuesta.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'mercadoPagoOK':
          var idPago = call.arguments[0];
          var status = call.arguments[1];
          var statusDetails = call.arguments[2];
          return mercadoPagoOK(idPago, status, statusDetails);
        case 'mercadoPagoError':
          var error = call.arguments[0];
          return mercadoPagoERROR(error);
      }
    });
    super.initState();
  }*/

  int cantUnidades;
  int precio;
  String nombre;
  String mail;
  void mercadoPagoOK(idPago, status, statusDetails) {
    print("idPago $idPago");
    print("status $status");
    print("statusDetails $statusDetails");
  }

  void mercadoPagoERROR(error) {
    print("error $error");
  }

//url de marcado apgo + preferencia id lleva a la pagina para pagar
  Future<Map<String, dynamic>> armarPreferencia(
      int cantUnidades, int precio, String nombre, String mail) async {
    var mp = MP(globals.mpClientID, globals.mpClientSecret);

    var preference = {
      "items": [
        {
          "title": "Pedido Impresion",
          "quantity": cantUnidades,
          "currency_id": "USD",
          "unit_price": precio
        }
      ],
      "payer": {"name": nombre, "email": mail},
      "payment_methods": {
        "excluded_payment_types": [
          {"id": "ticket"},
          {"id": "atm"}
        ]
      }
    };

    var result = await mp.createPreference(preference);
    return result;
  }

  var collectorId;
  var preferenceId;
  var init_point;
  Future<void> ejecutarMercadoPago() async {
    armarPreferencia(cantUnidades, precio, nombre, mail).then((result) {
      if (result != null) {
        preferenceId = result['response']['id'];
        init_point = result['response']['init_point'];
        /* try {
          const channelMercadoPago =
              const MethodChannel("waviacademy.com/mercadoPago");
          final response = channelMercadoPago.invokeMethod(
              'mercadoPago', <String, dynamic>{
            "publicKey": globals.mpTESTPublicKey,
            "preferenceId": preferenceId
          });
          print(response);
        } on PlatformException catch (e) {
          print(e.message);
        }*/
        print(preferenceId);
        print(init_point);
        print(result);
        // Map<String, String> map;
        //  verificarPago().then((value) => print(value.values));
      }
    });
  }

  // ignore: missing_return
  Future<List<dynamic>> obtenerLinkDePago() async {
    armarPreferencia(cantUnidades, precio, nombre, mail).then((result) {
      if (result != null) {
        collectorId = result['response']['collector_id'];
        init_point = result['response']['init_point'];
        List<dynamic> list = [collectorId, init_point];
        /* try {
          const channelMercadoPago =
              const MethodChannel("waviacademy.com/mercadoPago");
          final response = channelMercadoPago.invokeMethod(
              'mercadoPago', <String, dynamic>{
            "publicKey": globals.mpTESTPublicKey,
            "preferenceId": preferenceId
          });
          print(response);
        } on PlatformException catch (e) {
          print(e.message);
        }*/
        //  print(preferenceId);
        //print(init_point);
        //  print(result);
        return list;
        //Map<String, String> map;
        //  verificarPago().then((value) => print(value.values));
      }
    });
  }

  Future<Map<String, dynamic>> verificarPago() async {
    var filters = {"id": '', "external_reference": ''};
    var mp = MP("2506955747165343", "kkfXCTWtnUlMjP7RVn1hozLxfufhAej8");
    var searchResult = await mp.searchPayment(filters);

    // print(searchResult);
    return searchResult;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mercado Pago"),
        ),
        body: Center(
          child: MaterialButton(
            color: Colors.blue,
            onPressed: ejecutarMercadoPago,
            child: Text(
              "Comprar con Mercado Pago",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}


/*import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';

// Get your app public from the credentials pages:
// https://www.mercadopago.com/mla/account/credentials
const publicKey = "TEST-1a2528ec-2a3a-4c10-8c26-ccf7ad0e2d8b";

// The preferenceId should be fetch from your backend server. Do not
// expose your Access Token. Also you can create a preference using
// curl:
// ```bash
// curl -X POST \
//     'https://api.mercadopago.com/checkout/preferences?access_token=TEST-2506955747165343-072522-a87758349b2da934ead6b76e8e2851f1-133187590";

//     -H 'Content-Type: application/json' \
//     -d '{
//           "items": [
//               {
//               "title": "Dummy Item",
//               "description": "Multicolor Item",
//               "quantity": 1,
//               "currency_id": "ARS",
//               "unit_price": 10.0
//               }
//           ],
//           "payer": {
//               "email": "payer@email.com"
//           }
//     }'
// ```
const preferenceId = "0";

class MercadoPago extends StatefulWidget {
  @override
  MercadoPagoState createState() => MercadoPagoState();
}

class MercadoPagoState extends State<MercadoPago> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MercadoPagoMobileCheckout.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(
                onPressed: () async {
                  PaymentResult result =
                      await MercadoPagoMobileCheckout.startCheckout(
                    publicKey,
                    preferenceId,
                  );
                  print(result.toString());
                },
                child: Text("Pagar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

/*import 'package:mercadopago_sdk/mercadopago_sdk.dart';

class MercadoPago extends StatefulWidget {
  MercadoPago({this.seccion});
  final Seccion seccion;
  @override
  MercadoPagoState createState() => MercadoPagoState(sec: seccion);
}

class MercadoPagoState extends State<MercadoPago> {
  String clientId = '2506955747165343';
  String clientSecretId = "kkfXCTWtnUlMjP7RVn1hozLxfufhAej8";
  final Seccion sec;
  String publicKey = "TEST-1a2528ec-2a3a-4c10-8c26-ccf7ad0e2d8b";
  MercadoPagoState({this.sec});
  String token;
  void main() async {
    var mp = MP(clientId, clientSecretId);

    token = await mp.getAccessToken();

    print('Mercadopago token ${token}');
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    main();
    return Text('');
  }
}*/
/*
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class MySample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MySampleState();
  }
}

class MySampleState extends State<MySample> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        themeColor: Colors.blue,
                        cardNumberDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Card Holder',
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          primary: const Color(0xff1b447b),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: const Text(
                            'Validate',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'halter',
                              fontSize: 14,
                              package: 'flutter_credit_card',
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            print('valid!');
                          } else {
                            print('invalid!');
                          }
                        },
                      )
                    ],
                  ),
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
}*/
/*import 'package:flutter/material.dart';

import 'package:flutter_pay/flutter_pay.dart';

class MercadoPago extends StatefulWidget {
  MercadoPago({this.seccion});
  final Seccion seccion;
  @override
  MercadoPagoState createState() => MercadoPagoState();
}

class MercadoPagoState extends State<MercadoPago> {
  FlutterPay flutterPay = FlutterPay();

  String result = "Result will be shown here";

  @override
  void initState() {
    super.initState();
  }

  void makePayment() async {
    List<PaymentItem> items = [PaymentItem(name: "T-Shirt", price: 2.98)];

    flutterPay.setEnvironment(environment: PaymentEnvironment.Test);

    flutterPay.requestPayment(
      googleParameters: GoogleParameters(
        gatewayName: "example",
        gatewayMerchantId: "example_id",
      ),
      appleParameters:
          AppleParameters(merchantIdentifier: "merchant.flutterpay.example"),
      currencyCode: "USD",
      countryCode: "US",
      paymentItems: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  this.result,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                ElevatedButton(
                  child: Text("Can make payments?"),
                  onPressed: () async {
                    try {
                      bool result = await flutterPay.canMakePayments();
                      setState(() {
                        this.result = "Can make payments: $result";
                      });
                    } catch (e) {
                      setState(() {
                        this.result = "$e";
                      });
                    }
                  },
                ),
                ElevatedButton(
                  child: Text("Can make payments with verified card: $result"),
                  onPressed: () async {
                    try {
                      bool result =
                          await flutterPay.canMakePaymentsWithActiveCard(
                        allowedPaymentNetworks: [
                          PaymentNetwork.visa,
                          PaymentNetwork.masterCard,
                        ],
                      );
                      setState(() {
                        this.result = "$result";
                      });
                    } catch (e) {
                      setState(() {
                        this.result = "Error: $e";
                      });
                    }
                  },
                ),
                ElevatedButton(
                    child: Text("Try to pay?"),
                    onPressed: () {
                      makePayment();
                    })
              ]),
        ),
      ),
    );
  }
}*/
