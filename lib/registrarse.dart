import 'package:app_imprenta/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';
//import 'package:http/http.dart';

class Registrarse extends StatefulWidget {
  Registrarse({Key key}) : super(key: key);
  RegistrarseState createState() => RegistrarseState();
}

class RegistrarseState extends State<Registrarse> {
  final GlobalKey<FormState> _keyRegistrarse = GlobalKey<FormState>();
  final _mail = TextEditingController();
  final _nombre = TextEditingController();
  final _apellido = TextEditingController();
  final _telefono = TextEditingController();
  final _pass1 = TextEditingController();
  final _pass2 = TextEditingController();
  Usuario _us;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("REGISTRARSE"),
          centerTitle: true,
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            margin: const EdgeInsets.only(left: 120, right: 120, top: 20),
            child: Form(
                key: _keyRegistrarse,
                child: Center(
                    child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _mail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "Mail",
                            helperText: 'ejemplo@ejemplo.com'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains("@") ||
                              !value.contains(".com")) {
                            return 'Ingresar Mail';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _nombre,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Nombre", helperText: 'Primer nombre'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresar Nombre';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _apellido,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Apellido",
                            helperText: 'Primer apellido'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresar Apellido';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _telefono,
                        decoration: InputDecoration(
                            hintText: "Telefono",
                            helperText: 'telefono fijo o celular'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresar numero de contacto';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _pass1,
                        decoration: InputDecoration(
                            hintText: "ingrese clave",
                            helperText:
                                'ingresar clave con mas de 6 caracteres'),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6) {
                            return 'Ingresar clave con minimo 6 caracteres';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _pass2,
                        decoration: InputDecoration(
                            hintText: "ingrese clave",
                            helperText:
                                'ingresar clave con mas de 6 caracteres'),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              _pass1.text != _pass2.text ||
                              value.length < 6) {
                            return 'No coinciden claves, reingrese';
                          }

                          return null;
                        },
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        child: buildColumn(),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        child: (us != null) ? buildFutureBuilder() : null,
                      ),
                    ],
                  ),
                )))));
  }

  Future<Usuario> us;
  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (_keyRegistrarse.currentState.validate() == true) {
                us = null;
                us = Usuario(
                        tipoUs: 'cliente',
                        email: _mail.text,
                        clave: _pass2.text,
                        apellido: _apellido.text,
                        nombre: _nombre.text,
                        telefono: _telefono.text)
                    .registrarUsuario();
              }
            });
            us.then((value) {
              _us = value;
            });
          },
          child: Text('Registrarse'),
        ),
      ],
    );
  }

  FutureBuilder<Usuario> buildFutureBuilder() {
    return FutureBuilder<Usuario>(
      future: us,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AlertDialog(
              content: Column(
            children: [
              Text('Usuario registrado: Nombre: ' +
                  _us.nombre +
                  ' Email: ' +
                  _us.email),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text('Iniciar Seccion'))
            ],
          ));
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }
}
