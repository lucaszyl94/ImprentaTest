import 'dart:convert';
//import 'package:app_imprenta/seccion.dart';
//import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
//import 'package:app_imprenta/seccion.dart';

class Usuario {
  //PROPIEDADES
  final String tipoUs;
  final int id;
  final String email;
  final String clave;
  final String nombre;
  final String apellido;
  //final String fechaNacimiento;
  final String telefono;
  //final url = 'http://127.0.0.1:8000/';
  final url = 'http://127.0.0.1:8000/'; //'http://34.216.222.114:80/';
//CONSTRUCTOR
  Usuario(
      {this.tipoUs,
      this.id,
      this.email,
      this.clave,
      this.apellido,
      //  this.fechaNacimiento,
      this.nombre,
      this.telefono});
/*  Usuario(String em, String cl, String ap, String fn, String nom, String tel) {
    this.email=em;
    this.clave=cl;
    this.apellido=ap;
    this.fechaNacimiento=fn;
    this.nombre=nom;
    this.telefono=tel;
  }*/
//METODOS
//MODIFICAR URL CUANDO ESTE PRONTA API
  factory Usuario.fromJsonPrueba(Map<String, dynamic> json) {
    return Usuario(
        nombre: json['nombre'] as String,
        email: json['email'] as String,
        clave: json['password'] as String,
        apellido: json['apellido'] as String,
        telefono: json['telefono'] as String,
        tipoUs: json['tipoUs'] as String,
        id: json['id'] as int);
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
        nombre: json['nombre'] as String,
        email: json['email'] as String,
        clave: json['clave'] as String,
        apellido: json['apellido'] as String,
        telefono: json['telefono'] as String,
        tipoUs: json['tipoUs'] as String,
        id: json['id'] as int);
  }

  Future<Usuario> getUsuario() async {
    final response =
        await http.get(Uri.parse(url + 'api/v1/user/$email'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Allow': 'POST, OPTIONS',
      // 'Content-Type': 'application/json',
      'Vary': 'Accept',
      'Access-Control-Allow-Origin': '*',
    });
    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Usuario no encontrado');
      //return null;
    }
  }

  Future<Usuario> verificarUsuario() async {
    http.Client client = http.Client();
    //final Seccion sec = Seccion();
    final response = await client.post(
      Uri.parse(url + 'api/v1/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Allow': 'POST, OPTIONS',
        // 'Content-Type': 'application/json',
        'Vary': 'Accept',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode({
        "email": email,
        'clave': clave,
      }),
    ); //modificado para ser compatible con la api beta
    if (response.statusCode == 200) {
      //final us = jsonDecode(response.body).cast<Map<String, dynamic>>();
      //  final sec = jsonDecode(response.body).cast<Map<String, dynamic>>();Usuario.fromJson(jsonDecode(response.body));
      return Usuario.fromJson(jsonDecode(response.body));
      // return sec.map<Seccion>((json) => Seccion.fromJson(json));
      // return true;
    } else {
      // return null;
      throw Exception('Error, usuario y/o clave incorrectos');
    }
  }

  Future<bool> borrarUsuario() async {
    final http.Response response = await http.delete(
      Uri.parse(url + 'api/v1/user/$email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<Usuario> modificarUsuario() async {
    final http.Response response = await http.put(
      Uri.parse(url + 'api/v1/user/$email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tipous': tipoUs,
        'email': email,
        // 'clave': clave,
        //'fechaNacimiento': fechaNacimiento,
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono
      }),
    );
    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error, no se pudo modificar');
    }
  }

  List<Usuario> parseUsuarios(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Usuario>((json) => Usuario.fromJson(json)).toList();
  }

  Future<List<Usuario>> fetchUsuario(http.Client client) async {
    final response = await client.get(Uri.parse(url));
    return parseUsuarios(response.body);
  }

  Future<Usuario> registrarUsuario() async {
    final response = await http.post(
      Uri.parse(url + 'api/v1/users/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        //'Access-Control-Allow-Origin': '*',
        //'Vary': 'Accept,Cookie',
        //'Allow': 'POST, OPTIONS',
      },
      body: jsonEncode({
        'tipoUs': tipoUs,
        'email': email,
        'clave': clave,
        //'fechaNacimiento': fechaNacimiento,
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono
      }),
    );
    //return response.statusCode.toString();
    if (response.statusCode == 201) {
      return Usuario.fromJson(jsonDecode(response.body));
    } /* else if (response.statusCode == 400) {
      return Usuario.fromJsonPrueba(jsonDecode(response.body));
    }*/
    else {
      throw Exception('Error, no se pudo registrar');
      // return null;
      //  return Usuario.fromJson(jsonDecode(response.body));
    }
  }
}
