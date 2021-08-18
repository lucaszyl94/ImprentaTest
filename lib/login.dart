//import 'package:app_imprenta/admPrincipal.dart';
import 'package:app_imprenta/frontendAdm.dart';
import 'package:app_imprenta/pedido.dart';
import 'package:app_imprenta/pedidoImpresion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_imprenta/registrarse.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'package:app_imprenta/usuario.dart';
import 'package:app_imprenta/seccion.dart';

import 'categoria.dart';

class Login extends StatefulWidget {
  Login({Key key, this.seccion}) : super(key: key);
  final Seccion seccion;
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> _keyLogin = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  LoginState() {
    //  categoriaList();
  }
  Future<Usuario> _us;
  Usuario user = Usuario();
  Seccion sec = Seccion();
  List<dynamic> di;
  List<Pedido> pedidosUs;
  bool isEmail(String string) {
    // Null or empty string is invalid
    if (string == null || string.isEmpty) {
      return false;
    }

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }

  Future<void> categoriaList() async {
    await Categoria().fetchCategoriaS().then((value) => di = value);

    await setState(() {});
  }

  Future<void> pedidosList(int id) async {
    await Pedido(idCliente: id).fetchPedido().then((value) async {
      await setState(() {
        pedidosUs = value;
      });
    });
  }

  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("LOGIN"),
          centerTitle: true,
        ),
        body: Container(
            //color: Colors.blueGrey,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            margin: const EdgeInsets.only(left: 120, right: 120, top: 20),
            child: Form(
              key: _keyLogin,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    /* Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 30),
                      child: DropdownButton(
                        focusColor: Colors.blueAccent,
                        items: _usuarioTipo.map((String a) {
                          return DropdownMenuItem(value: a, child: Text(a));
                        }).toList(),
                        onChanged: (_value) => {
                          setState(() {
                            _usuarioSelec = _value;
                          })
                        },
                        hint: Text(_usuarioSelec),
                      ),
                    ),*/
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(hintText: "Mail"),
                      validator: (value) {
                        if (value == null || value.isEmpty || !isEmail(value)) {
                          return 'Ingresar Mail';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _pass,
                      decoration: InputDecoration(hintText: "Password"),
                      obscureText: true,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return 'Ingrese password';
                        }

                        return null;
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      child:
                          (_us == null) ? buildColumn() : buildFutureBuilder(),
                    ),
                    Container(
                        child: Material(
                      child: InkWell(
                          child: Text(
                            "¿Primera vez?, CREA UNA CUENTA",
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Registrarse()));
                          }),
                    ))
                  ],
                ),
              ),
            )));
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            setState(() {
              Usuario(clave: _pass.text, email: _email.text)
                  .verificarUsuario()
                  .then((value) async {
                if (value.tipoUs == 'admin' && value != null) {
                  sec.us = value;
                  await Pedido(idCliente: value.id)
                      .fetchPedidos()
                      .then((value) async {
                    await setState(() async {
                      pedidosUs = value;
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FrontEndAdm(seccion: sec, p: pedidosUs)));
                    });
                  });
                } else if (value != null) {
                  sec.us = value;
                  await Categoria()
                      .fetchCategoriaS()
                      .then((value) => di = value)
                      .whenComplete(() async =>
                          await Pedido(idCliente: value.id)
                              .fetchPedido()
                              .then((value) async {
                            await setState(() async {
                              pedidosUs = value;
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PedidoImpresion(
                                          seccion: sec, c: di, p: pedidosUs)));
                            });
                          }));
                } else {
                  _us = Usuario(clave: _pass.text, email: _email.text)
                      .verificarUsuario();
                }
              });
              _us = Usuario(clave: _pass.text, email: _email.text)
                  .verificarUsuario();
            });
          },
          child: Text('Ingresar'),
        ),
      ],
    );
  }

  FutureBuilder<Usuario> buildFutureBuilder() {
    return FutureBuilder<Usuario>(
      future: _us,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Error, usuario y/o clave incorrectos'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _us = Usuario(clave: _pass.text, email: _email.text)
                          .verificarUsuario();
                    });
                  },
                  child: Text('Ingresar'),
                )
              ]); //Text('${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }
}
