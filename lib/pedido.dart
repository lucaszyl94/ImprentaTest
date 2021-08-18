import 'dart:convert';

//import 'package:app_imprenta/seccion.dart';
//import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
//import 'package:app_imprenta/Usuario.dart';

class Pedido {
  final int cantidadUnidades;
  // final String portada;
  final String papelPortada;
  final String gramajePortada;
  final String plastificado;
  final int paginasInteriores;
  final String impresionInterior;
  final String tipoPapel;
  final String gramaje;
  final String formatoHoja;
  final String encuadernacion;
  //final DateTime fechaSolicitud = DateTime.now();
  // final DateTime fechaEntrega;
  // final int precioTotal;
  final String estado;
  final String urlPdf;
  final int id;
//  final String cliente;
  final int idCliente;
  final int precio;
  final String mensaje;
  final String linkPago;
  final String collectorId;

  //final url = 'http://127.0.0.1:8000/';
  final url = 'http://127.0.0.1:8000/';
  Pedido({
    this.linkPago,
    this.mensaje,
    this.cantidadUnidades,
    this.encuadernacion,
    this.formatoHoja,
    this.gramaje,
    this.gramajePortada,
    this.impresionInterior,
    // this.fechaEntrega,
    this.estado,
    this.id,
    this.paginasInteriores,
    this.papelPortada,
    this.plastificado,
    // this.portada,
    // this.precioTotal,
    this.tipoPapel,
    this.urlPdf,
    this.idCliente,
    //this.cliente,
    this.precio,
    this.collectorId,
  });
  factory Pedido.fromJsonError(Map<String, dynamic> json) {
    return Pedido(
      mensaje: json['message'] as String,
    );
  }

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      cantidadUnidades: json['cantidadUnidades'] as int,
      //  portada: json['portada'] as String,
      papelPortada: json['papelPortadas'] as String,
      gramajePortada: json['gramajePortadas'] as String,
      plastificado: json['plastificado'] as String,
      paginasInteriores: json['paginasInteriores'] as int,
      impresionInterior: json['impresionInterior'] as String,
      tipoPapel: json['tipoPapel'] as String,
      gramaje: json['gramaje'] as String,
      formatoHoja: json['formatoHoja'] as String,
      //encuadernacion: json['encuadernacion'] as String,
      estado: json['estado'] as String,
      // fechaSolicitud: json['fechaSolicitud'] as DateTime,
      //fechaEntrega: json['fechaEntrega'] as DateTime,
      //   precioTotal: json['precioTotal'] as int,
      urlPdf: json['url'] as String,
      id: json['id'] as int,
      idCliente: json['cliente'] as int,
      precio: json['precio'] as int,
      linkPago: json['linkPago'] as String,
      collectorId: json['collectorId'] as String,

      // cliente: Usuario.fromJson(json['cliente'])
    );
  }
  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'cantidadUnidades': cantidadUnidades,
      // 'portada': portada,
      'papelPortada': papelPortada,
      'gramajePortada': gramajePortada,
      'plastificado': plastificado,
      'paginasInteriores': paginasInteriores,
      'impresionInterior': impresionInterior,
      'tipoPapel': tipoPapel,
      'gramaje': gramaje,
      'formatoHoja': formatoHoja,
      'encuadernacion': encuadernacion,
      // fechaSolicitud: json['fechaSolicitud'] as DateTime,
      // 'fechaEntrega': fechaEntrega,
      // 'precioTotal': precioTotal,
      'url': urlPdf,
      'id': id,
      //'cliente': idCliente,
      'precio': precio,
    };
  }

  Future<List<dynamic>> obtenerImpresiones() async {
    final http.Response response = await http.get(
      Uri.parse(url + 'api/v1/datosimpresion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var c = jsonDecode(response.body);

    //print(response.body);

    return c;
  }

  Future<int> borrarUsuario() async {
    final http.Response response = await http.get(
      Uri.parse(url + '/deleted' + '/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response.statusCode;
  }

  Future<int> modificarPedido() async {
    final http.Response response = await http.put(
      Uri.parse(url + '/put'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'estado': estado}),
    );
    return response.statusCode;
  }

  List<Pedido> parsePedidos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Pedido>((json) => Pedido.fromJson(json)).toList();
  }

  Future<List<Pedido>> fetchPedido() async {
    //RESOLVER API PARA QUE EL GET DEVUELVA TODOS LOS PEDIDOS POR USUARIO
    final response =
        await http.get(Uri.parse(url + 'api/v1/pedidosUser/$idCliente'));
    return await parsePedidos(response.body);
  }

  Future<List<Pedido>> fetchPedidos() async {
    //RESOLVER API PARA QUE EL GET DEVUELVA TODOS LOS PEDIDOS POR USUARIO
    final response = await http.get(Uri.parse(url + 'api/v1/pedido/'));
    return await parsePedidos(response.body);
  }

  Future<Pedido> solicitarPedido() async {
    final response = await http.post(
      Uri.parse(url + 'api/v1/precio/'),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Vary': 'Accept,Cookie',
        'Allow': 'POST, OPTIONS',
      },
      body: jsonEncode({
        'cantidadUnidades': cantidadUnidades, //int.parse(cantidadUnidades),
        //  'portada': portada,
        'papelPortadas': papelPortada,
        'gramajePortadas': gramajePortada,
        'plastificado': plastificado,
        'paginasInteriores': paginasInteriores,
        'impresionInterior': impresionInterior,
        'tipoPapel': tipoPapel,
        'gramaje': gramaje,
        'formatoHoja': formatoHoja,
        'encuadernacion': encuadernacion,
        "cliente": idCliente,
        "precio": precio,
        'estado': 'pendiente',
        // "url": urlPdf
      }),
    );

    if (response.statusCode == 200) {
      return Pedido.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(Pedido.fromJsonError(jsonDecode(response.body)));
      // return Pedido.fromJsonError(jsonDecode(response.body));
    }
  }

  Future<Pedido> solicitarPrecio(
      int cantU,
      int pPortId,
      int gPortId,
      int plast,
      int pagInt,
      int impIntId,
      int tipPapelId,
      int gPapelid,
      int fHojaId,
      int idClient,
      int impPort) async {
    final response = await http.post(
      Uri.parse(url + 'api/v1/precio/'),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Vary': 'Accept,Cookie',
        'Allow': 'POST, OPTIONS',
      },
      body: jsonEncode({
        'cantidadUnidades': cantU, //int.parse(cantidadUnidades),
        'impresionPortada': impPort,
        'papelPortadas': pPortId,
        'gramajePortadas': gPortId,
        'plastificado': plast,
        'paginasInteriores': pagInt,
        'impresionInterior': impIntId,
        'tipoPapel': tipPapelId,
        'gramaje': gPapelid,
        'formatoHoja': fHojaId,
        //'encuadernacion': encId,
        "cliente": idClient,
        // "precio": precio,
        'estado': 'pendiente',
        // "url": urlPdf
      }),
    );

    if (response.statusCode == 200) {
      return Pedido.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(Pedido.fromJsonError(jsonDecode(response.body)));
      // return Pedido.fromJsonError(jsonDecode(response.body));
    }
  }

  Future<Pedido> realizarPedidoId(
      int cantU,
      int pPortId,
      int gPortId,
      int plast,
      int pagInt,
      int impIntId,
      int tipPapelId,
      int gPapelid,
      int fHojaId,
      int idClient,
      int impPort,
      int precio,
      String url,
      String linkDePago,
      String collectorId) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/v1/pedido/'),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Vary': 'Accept,Cookie',
        'Allow': 'POST, OPTIONS',
      },
      body: jsonEncode({
        'cantidadUnidades': cantU, //int.parse(cantidadUnidades),
        'impresionPortada': impPort,
        'papelPortadas': pPortId,
        'gramajePortadas': gPortId,
        'plastificado': plast,
        'paginasInteriores': pagInt,
        'impresionInterior': impIntId,
        'tipoPapel': tipPapelId,
        'gramaje': gPapelid,
        'formatoHoja': fHojaId,
        //'encuadernacion': encId,
        "cliente": idClient,
        "precio": precio,
        // 'estado': 'pendiente',
        "url": url,
        'linkPago': linkDePago,
        'collectorId': collectorId
      }),
    );

    if (response.statusCode == 201) {
      return Pedido.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(Pedido.fromJsonError(jsonDecode(response.body)));
      // return Pedido.fromJsonError(jsonDecode(response.body));
    }
  }

  Future<Pedido> realizarPedido() async {
    final response = await http.post(
      Uri.parse(url + 'api/v1/pedido/'),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Vary': 'Accept,Cookie',
        'Allow': 'POST, OPTIONS',
      },
      body: jsonEncode({
        'cantidadUnidades': cantidadUnidades, //int.parse(cantidadUnidades),
        //  'portada': portada,
        'papelPortadas': papelPortada,
        'gramajePortadas': gramajePortada,
        'plastificado': plastificado,
        'paginasInteriores': paginasInteriores,
        'impresionInterior': impresionInterior,
        'tipoPapel': tipoPapel,
        'gramaje': gramaje,
        'formatoHoja': formatoHoja,
        'encuadernacion': encuadernacion,
        "cliente": idCliente,
        "precio": precio,
        'estado': 'pendiente',

        // "url": urlPdf
      }),
    );

    if (response.statusCode == 201) {
      return Pedido.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(Pedido.fromJsonError(jsonDecode(response.body)));
      // return Pedido.fromJsonError(jsonDecode(response.body));
    }
  }
}
