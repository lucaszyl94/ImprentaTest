import 'package:app_imprenta/pedido.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:app_imprenta/registrarse.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
//import 'package:app_imprenta/usuario.dart';
import 'package:app_imprenta/seccion.dart';
import 'package:app_imprenta/usuario.dart';

import 'admPedidos.dart';
import 'login.dart';

class FrontEndAdm extends StatefulWidget {
  FrontEndAdm({Key key, this.seccion, this.p}) : super(key: key);
  final Seccion seccion;
  List<Pedido> p;
  /*void redirect() => {
        if (seccion == null) {Navigator.pushNamed(null, '/')}
      };*/
  FrontEndAdmState createState() => FrontEndAdmState(seccion, p);
}

class FrontEndAdmState extends State<FrontEndAdm> {
  final Seccion s;
  FrontEndAdmState(this.s, this.pedidos);
  List<Pedido> pedidos = [];
  final GlobalKey<FormState> _keyRegistrarseAdm = GlobalKey<FormState>();
  final GlobalKey<FormState> _keyBuscar = GlobalKey<FormState>();
//  final GlobalKey<FormState> _keyModificacionAdm = GlobalKey<FormState>();
  TextEditingController _mail = TextEditingController();
  TextEditingController _nombre = TextEditingController();
  TextEditingController _apellido = TextEditingController();
//  TextEditingController _fechaNacimiento = TextEditingController();
  TextEditingController _telefono = TextEditingController();
  TextEditingController _pass1 = TextEditingController();
  TextEditingController _pass2 = TextEditingController();
  TextEditingController _id = TextEditingController();
  final _usuarioTipo = List<String>.unmodifiable({'admin', 'cliente'});
  String _usuarioSelec = 'Seleccione Usuario';
  Future<Usuario> us;
  Future<Usuario> usm;
  bool del = false;
  void redirect() {
    if (s == null) {
      /*  Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ));*/
    }
  }

  @override
  Widget build(BuildContext context) {
    if (s == null) {
      return Login();
    }
    redirect();
    return Scaffold(
      persistentFooterButtons: [
        IconButton(
          alignment: Alignment.centerLeft,
          icon: const Icon(Icons.view_array),
          tooltip: 'Ver Pedidos',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdmPedidos(seccion: s, p: pedidos)));
          },
        ),
      ],
      appBar: AppBar(
        actions: [
          IconButton(
            alignment: Alignment.centerLeft,
            icon: const Icon(Icons.arrow_circle_up_sharp),
            tooltip: 'Salir',
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
        ],
        title: Text("Interfaz Principal Adm"),
        centerTitle: true,
      ),
      body: Container(
        //color: Colors.blueGrey,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        margin: const EdgeInsets.only(left: 120, right: 120, top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: _keyBuscar,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //   Text('Buscar'),
                        /*  Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(8.0),
                          child: (us == null) ? msjBusqueda() : msjResultado(),
                        ),*/
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // int i = int.parse(_id.text.toString());
                              us = null;
                              us = Usuario(email: _id.text).getUsuario();
                              us.then((value) {
                                if (value != null) {
                                  _usuarioSelec = value.tipoUs;
                                  _mail.text = value.email;
                                  _nombre.text = value.nombre;
                                  _apellido.text = value.apellido;

                                  _telefono.text = value.telefono;
                                }
                              });
                            });
                          },
                          child: Text('Buscar'),
                        ),
                        TextFormField(
                          controller: _id,
                          decoration: InputDecoration(
                            hintText: "ingrese mail de usuario",
                          ),
                          keyboardType: TextInputType.number,
                          // ignore: missing_return
                          validator: (value) {
                            // ignore: unrelated_type_equality_checks
                            if (value.isEmpty || value == null) {
                              return 'No se pudo encontrar';
                            }

                            return 'Usuario encontrado';
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: (us == null) ? msjResultado() : buildFutureBuilder()),
              Form(
                  key: _keyRegistrarseAdm,
                  child: Column(
                    children: <Widget>[
                      Text("Alta"),
                      Container(
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
                      ),
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
                              // _pass1 != _pass2 ||
                              value.length < 6) {
                            return 'No coinciden claves, reingrese';
                          }

                          return null;
                        },
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        child: (_id.text == "")
                            ? buildBtnRegistrar()
                            : buildBtnModEl(),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  AlertDialog msjBusqueda() {
    return AlertDialog(
      content: Text(
        'Para eliminar o modificar ingrese mail',
        textAlign: TextAlign.center,
      ),
    );
  }

  FutureBuilder<Usuario> msjResultado() {
    return FutureBuilder<Usuario>(
      future: us,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AlertDialog(
            content: Text(
              'Realizado',
              textAlign: TextAlign.center,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData == false) {
          return Text('');
        }
        return CircularProgressIndicator();
      },
    );
  }

  Row buildBtnRegistrar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            if (_keyRegistrarseAdm.currentState.validate()) {
              setState(() {
                us = null;
                us = Usuario(
                  tipoUs: _usuarioSelec,
                  email: _mail.text,
                  clave: _pass2.text,
                  apellido: _apellido.text,
                  nombre: _nombre.text,
                  telefono: _telefono.text,
                ).registrarUsuario();
                us.then((value) {
                  if (value != null) {
                    _mail.text = value.email;
                    _nombre.text = value.nombre;
                    _apellido.text = value.apellido;

                    _telefono.text = value.telefono;

                    _usuarioSelec = value.tipoUs;
                  }
                });
              });
            }
          },
          child: Text('Registrar'),
        ),
      ],
    );
  }

  Row buildBtnModEl() {
    //

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            if (us != null)
              setState(() {
                Usuario(
                        tipoUs: _usuarioSelec,
                        email: _mail.text,
                        apellido: _apellido.text,
                        nombre: _nombre.text,
                        telefono: _telefono.text)
                    .modificarUsuario()
                    .then((value) {
                  if (value != null) {
                    _mail.text = value.email;
                    _nombre.text = value.nombre;
                    _apellido.text = value.apellido;
                    _telefono.text = value.telefono;
                    _usuarioSelec = value.tipoUs;
                  }
                });
              });
          },
          child: Text('Modificar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (Usuario(email: _id.text).borrarUsuario() == true) {
              //  return Text('eliminado');
            } else {
              //   return Text('No se pudo eliminar');
            }
          },
          child: Text('Eliminar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FrontEndAdm(
                          seccion: s,
                        )));
          },
          child: Text('Registrar Nuevo'),
        ),
      ],
    );
  }

  FutureBuilder<Usuario> buildFutureBuilder() {
    return FutureBuilder<Usuario>(
      future: us,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.email);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }
}
