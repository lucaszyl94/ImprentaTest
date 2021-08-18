import 'package:app_imprenta/admPedidos.dart';
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

import 'login.dart';

class AdmPrincipal extends StatefulWidget {
  AdmPrincipal({Key key, this.seccion, this.p}) : super(key: key);
  final Seccion seccion;
  List<dynamic> p;

  AdmPrincipalState createState() => AdmPrincipalState(seccion, p);
}

class AdmPrincipalState extends State<AdmPrincipal> {
  final Seccion s;
  List<Pedido> pList;

  AdmPrincipalState(this.s, this.pList);
  final GlobalKey<FormState> _keyRegistrarseAdm = GlobalKey<FormState>();
  final GlobalKey<FormState> _keyBajaAdm = GlobalKey<FormState>();
  final GlobalKey<FormState> _keyModificacionAdm = GlobalKey<FormState>();
  final _mail = TextEditingController();
  final _nombre = TextEditingController();
  final _apellido = TextEditingController();
  final _fechaNacimiento = TextEditingController();
  final _telefono = TextEditingController();
  final _pass1 = TextEditingController();
  final _pass2 = TextEditingController();
  final _idBorrar = TextEditingController();
  final _idModificar = TextEditingController();
  final _usuarioTipo = List<String>.unmodifiable({'Administrador', 'Cliente'});
  String _usuarioSelec = 'Seleccione Usuario';
  Future<Usuario> us;
  @override
  Widget build(BuildContext context) {
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
                    builder: (context) => AdmPedidos(seccion: s, p: pList)));
          },
        ),
      ],
      appBar: AppBar(
          title: Text("Interfaz Principal Adm"),
          centerTitle: true,
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
          ]),
      body: Container(
        //color: Colors.blueGrey,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        margin: const EdgeInsets.only(left: 120, right: 120, top: 20),
        child: SingleChildScrollView(
          child: Row(
            children: <Widget>[
              Form(
                  key: _keyRegistrarseAdm,
                  child: Expanded(
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
                        controller: _fechaNacimiento,
                        decoration: InputDecoration(
                            hintText: "Edad", helperText: 'Edad en Años'),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresar Edad';
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
                        child: (us == null)
                            ? buildColumn()
                            : buildFutureBuilder(), //PREGUNTA SI FUTUREALBUN ESTA VACIO Y EN FUNCION DE ESO LLAMA AL WIDGET QUE CORRESPONDA
                      ),
                      /*TextButton(
                        onPressed: () {
                          setState() {
                            us = Usuario(
                                    tipoUs: _usuarioSelec,
                                    email: _mail.text,
                                    clave: _pass2.text,
                                    apellido: _apellido.text,
                                    fechaNacimiento: _fechaNacimiento.text,
                                    nombre: _nombre.text,
                                    telefono: _telefono.text)
                                .registrarUsuario();
                          }

                          ;
                          if (!_keyRegistrarseAdm.currentState.validate() ||
                              _usuarioSelec == 'Seleccione Usuario' ||
                              us == null) {
                            return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    content: Text('Error ingrese nuevamente'));
                              },
                            );
                          } else {
                            return showDialog(
                              context: context,
                              builder: (context) {
                                /*  Usuario(
                                    tipoUs:_usuarioSelec,
                                    email: _mail.text,
                                    clave: _pass2.text,
                                    apellido: _apellido.text,
                                    fechaNacimiento: _fechaNacimiento.text,
                                    nombre: _nombre.text,
                                    telefono: _telefono.text).registrarUsuario();*/ // llamada a api para registrar usuario
                                return AlertDialog(
                                    content: Text('Bienvenido ' +
                                        _nombre.text +
                                        '' +
                                        _apellido.text));
                              },
                            );
                          }
                        },
                        child: Text('Registrar'),
                      ),*/
                    ],
                  ))),
              Form(
                  key: _keyBajaAdm,
                  child: Expanded(
                    child: Column(
                      children: <Widget>[
                        Text('Baja'),
                        TextFormField(
                          controller: _idBorrar,
                          decoration: InputDecoration(
                            hintText: "ingrese numero de usuario a eliminar",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            // ignore: unrelated_type_equality_checks
                            if (/*Usuario(id: value).borrarUsuario() != 200 ||*/ value
                                    .isEmpty ||
                                value == null) {
                              return 'No se pudo eliminar';
                            }

                            return 'Usuario eliminado';
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            if (!_keyBajaAdm.currentState.validate() ||
                                _usuarioSelec == 'Seleccione Usuario') {
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      content:
                                          Text('Error ingrese nuevamente'));
                                },
                              );
                            } else {
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      content: Text(
                                          'El usuario $_idBorrar fue eliminado'));
                                },
                              );
                            }
                          },
                          child: Text('Borrar'),
                        ),
                      ],
                    ),
                  )),
              Form(
                  key: _keyModificacionAdm,
                  child: Expanded(
                    child: Column(
                      children: <Widget>[
                        Text("Modificar"),
                        TextFormField(
                          controller: _idModificar,
                          decoration: InputDecoration(
                            hintText: "ingrese numero de usuario a eliminar",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            // ignore: unrelated_type_equality_checks
                            if (/*Usuario(id: value).verificarId() != 200 ||*/
                                value == null || value.isEmpty) {
                              return 'No se encontro usuario';
                            }

                            return 'existe usuario';
                          },
                        ),
                        TextFormField(
                          controller: _mail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Mail",
                              helperText: 'ejemplo@ejemplo.com'),
                          validator: (value) {
                            if (value.isEmpty ||
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
                            if (value.isEmpty) {
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
                            if (value.isEmpty) {
                              return 'Ingresar Apellido';
                            }

                            return null;
                          },
                        ),
                        /*    TextFormField(
                          controller: _fechaNacimiento,
                          decoration: InputDecoration(
                              hintText: "Edad", helperText: 'Edad en Años'),
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Ingresar Edad';
                            }

                            return null;
                          },
                        ),*/
                        TextFormField(
                          controller: _telefono,
                          decoration: InputDecoration(
                              hintText: "Telefono",
                              helperText: 'telefono fijo o celular'),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Ingresar numero de contacto';
                            }

                            return null;
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            if (!_keyModificacionAdm.currentState.validate()) {
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      content:
                                          Text('Error ingrese nuevamente'));
                                },
                              );
                            } else {
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  /*  Usuario(
                                    
                                    email: _mail.text,
                                    
                                    apellido: _apellido.text,
                                    fechaNacimiento: _fechaNacimiento.text,
                                    nombre: _nombre.text,
                                    telefono: _telefono.text).modificarUsuario();*/ // llamada a api para registrar usuario
                                  return AlertDialog(
                                      content: Text('Modificacion realizada'));
                                },
                              );
                            }
                          },
                          child: Text('Modificar'),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Column buildColumn() {
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            setState(() {
              us = Usuario(
                      tipoUs: _usuarioSelec,
                      email: _mail.text,
                      clave: _pass2.text,
                      apellido: _apellido.text,
                      //    fechaNacimiento: _fechaNacimiento.text,
                      nombre: _nombre.text,
                      telefono: _telefono.text)
                  .registrarUsuario(); //AL COMPLETAR CAMPOS Y PRESIONAR EL BOTON DISPARA ESTA FUNCION QUE LLAMA A LA API PARA REALIZAR EL POST
            });
          },
          child: Text('Registrar'),
        ),
      ],
    );
  }

  FutureBuilder<Usuario> buildFutureBuilder() {
    return FutureBuilder<Usuario>(
      future: us,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
              snapshot.data.email); //SI RECIBE DATA MUESTRA SOLO EL NOMBRE
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}'); //SI OCURRE UN ERROR LO MUESTRA
        }

        return CircularProgressIndicator();
      },
    );
  }
}
