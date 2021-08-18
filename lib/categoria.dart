import 'dart:async';
import 'dart:convert';
//import 'dart:html';
//import 'package:json_to_model/json_to_model.dart';
//import 'dart:io';
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final url = "http://127.0.0.1:8000/";

class Categoria {
  final int id;
  final String categoria;
  final String nombre;
  final String descripcion;
  final int precio;
  final List<SubCategoria> opciones;

  Categoria({
    this.id,
    this.categoria,
    this.descripcion,
    this.nombre,
    this.opciones,
    this.precio,
  });
  factory Categoria.fromJson(Map<String, dynamic> json) {
    //DESERIALIZADOR DE JSON A OBJETO, EN ESTE CASO A USER

    //List<Categoria> opcionesList = new List<Categoria>.from(opcionesFromJson);
    var list = json['opciones'] as List;

    List<SubCategoria> opcionesList =
        list.map((i) => SubCategoria.fromJson(i)).toList();
    return Categoria(
      categoria: json['categoria'] as String,
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      precio: json['precio'] as int,
      opciones: opcionesList,
    );
  }

  Future<List<dynamic>> fetchCategoria() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/v1/datosimpresion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ); //https://jsonplaceholder.typicode.com/posts
    return parseCategoria(response.body);
  }

  Future<dynamic> fetchCategoriaS() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/v1/datosimpresion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return jsonDecode(response
        .body); /*.cast <
        Map<dynamic, Map<String, dynamic>>();*/
  }

  Categoria postFromJson(String str) {
    final jsonData = json.decode(str);
    return Categoria.fromJson(jsonData);
  }

  String url1 = 'https://jsonplaceholder.typicode.com/posts';

  Future<Categoria> getPost() async {
    final response = await http.get(Uri.parse('$url1/1'));
    return postFromJson(response.body);
  }

//funcion que recibe un json y lo deserializa en una lista de fotos
  List<Categoria> parseCategoria(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<Categoria> l =
        parsed.map<Categoria>((json) => Categoria.fromJson(json)).toList();
    // return parsed.map<Categoria>((json) => Categoria.fromJson(json)).toList();
    return l;
  }
}

class SubCategoria {
  final int id;
  final int precio;
  final String categoria;
  final String nombre;
  final String descripcion;

  SubCategoria(
      {this.id, this.categoria, this.descripcion, this.nombre, this.precio});
  factory SubCategoria.fromJson(Map<String, dynamic> json) {
    return SubCategoria(
      categoria: json['categoria'] as String,
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      precio: json['precio'] as int,
    );
  }
}
