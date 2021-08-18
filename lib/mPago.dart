//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:app_imprenta/utils/globals.dart' as globals;
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:http/http.dart' as http;

class MPago {
  var collectorId;
  var preferenceId;
  var init_point;
  final bool msj;
  final int precio;
  final String nombre;
  final String mail;
  final url = 'http://127.0.0.1:8000/';
  MPago({this.mail, this.precio, this.nombre, this.msj});
  Future<Map<String, dynamic>> armarPreferencia() async {
    var mp = MP(globals.mpClientID, globals.mpClientSecret);

    var preference = {
      "items": [
        {
          "title": "Pedido Impresion",
          "quantity": 1,
          "currency_id": "UYU",
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

  Future<List<dynamic>> obtenerLinkDePago() async {
    List<dynamic> list = [];
    await armarPreferencia().then((result) {
      if (result != null) {
        collectorId = result['response']['id'];
        init_point = result['response']['init_point'];
        print(result);
        list = [collectorId, init_point];
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
      return list;
    });
    return list;
  }

  factory MPago.fromJson(Map<String, dynamic> json) {
    return MPago(
      msj: json['estadoPago'] as bool,
    );
  }
  Future<bool> verificarPago(int idPedido) async {
    final response = await http.get(
      Uri.parse(url + 'api/v1/checkpago/$idPedido'),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Vary': 'Accept,Cookie',
        'Allow': 'POST, OPTIONS',
      },
    );

    if (response.statusCode == 200) {
      if (MPago.fromJson(jsonDecode(response.body)).msj == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
      // return Pedido.fromJsonError(jsonDecode(response.body));
    }
  }
}
