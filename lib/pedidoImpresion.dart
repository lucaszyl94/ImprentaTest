//import 'dart:ffi';

import 'dart:io';
import 'dart:typed_data';
//import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:app_imprenta/pedido.dart';
import 'package:app_imprenta/seccion.dart';
import 'package:app_imprenta/usPedidos.dart';
import 'package:aws_s3/aws_s3.dart';
import 'package:file_picker/file_picker.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_imprenta/mPago.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'fileManage.dart';
import 'AWSClient.dart';
import 'categoria.dart';
import 'login.dart';
//import 'package:http/http.dart';

// ignore: must_be_immutable
class PedidoImpresion extends StatefulWidget {
  PedidoImpresion({Key key, this.seccion, this.c, this.p}) : super(key: key);
  final Seccion seccion;
  List<dynamic> p;
  List<dynamic> c;

  PedidoImpresionState createState() => PedidoImpresionState(seccion, c, p);
}

class PedidoImpresionState extends State<PedidoImpresion> {
  FilePickerResult resulto;
  List<PlatformFile> _paths;
  File selectedFile;
  bool isFileUploading = false;
  String res;
  bool load = false;
  bool aux = false;
  bool archivoSec = false;
//  firebase_storage.FirebaseStorage storage =
  //    firebase_storage.FirebaseStorage.instance;
  String poolId;
  String awsFolderPath = 'ImpresionesPdf';
  String bucketName = 's3imprentatest';
  String nameFile;
  final GlobalKey<FormState> _keyPedidoImpresion = GlobalKey<FormState>();
  final _cantUnidades = TextEditingController();
  TextEditingController _total = TextEditingController();
  //final _urlPdf = TextEditingController();
//  final _portadas = List<String>.unmodifiable({'1 cara color', '1 cara B/N'});
  String _portadasSec = 'select'; //
  //final _papelPortadas =
  //  List<String>.unmodifiable({'billante', 'corrugado', 'cartulina'});
  String _papelPortadasSec = 'select'; //
  //final _gramajePortadas = List<int>.unmodifiable({300, 250, 200});
  String _gramajePortadasSec = 'select'; //
  // final _plastificado = List<String>.unmodifiable({'SI', 'NO'});
  String _plastificadoSec = 'select'; //
  //bool _plastificadoBool = false;
  final _paginasInteriores = TextEditingController();
  //final _impresionInterior =
  //    List<String>.unmodifiable({'2 caras B/N', '2 caras Color'});
  String _impresionInteriorSec = 'select';
  // final _tipoPapel = List<String>.unmodifiable(
  //   {'offset blanco', 'offset reciclado', 'estrucado semimate'});
  String _tipoPapelSec = 'select';
  int _tipoPapelSecId;
  //final _gramaje = List<int>.unmodifiable({90, 100, 110, 130});
  //String _gramajeSec = 'select';
  //final _formato_hoja = List<String>.unmodifiable({'A4', 'A6'});
  String _formato_hojaSec = 'select';
  //final _encuadernacion =
  //   List<String>.unmodifiable({'Encolado/Fresado', 'Cosido hilo vegetal'});
  //String _encuadernacionSec = 'select';
  Seccion sec;
  Pedido pedidoRealizado;
  PedidoImpresionState(this.sec, this.di, this.pedidosUs) {
    // inicio();
    // di = p;

    categoriaList();
    pedidosList();
  }
  String collectorId;
  int precio = 0;
  Pedido ped;
  Future<Pedido> pedF;
  Future<Pedido> _pedido;
  Future<Pedido> p;
  Future<dynamic> datosImpresion;
  List<dynamic> di;
  List<dynamic> _papelPortadaList = [];
  List<dynamic> _tipoPapelList = [];
  List<dynamic> _plastificadolList = [];
  List<dynamic> _impresionInteriorList = [];
  List<dynamic> _formatoHojaList = [];
  List<dynamic> _impresionPortadaList = [];
  List<SubCategoria> _gramajeList = [];
  List<SubCategoria> _gramajePPortList = [];
  int _papelPortadasId;
  int _gramajePPortId;
  int _plastificadoId;
  int _impresionInteriorId;
  int _formato_hojaId;
  int _impresionPortadaId;
  String _gramajePepelSec = 'select';
  int _gramajePepelId;
  //Pedido _pedidoRealizado = Pedido();
  //HACER METODO PARA BUSCAR EL GRAMAJE DEL PAPEL SEGUN
  void obtenerOpcionesPapelPortada(int id) {
    for (var i = 0; i < _papelPortadaList.length; i++) {
      var p = _papelPortadaList[i];
      // var y = p.id;
      if (id == p.id) {
        var list = p.opciones;
        if (list.isNotEmpty) {
          setState(() {
            _gramajePPortList = p.opciones;
          });
        }
      }
    }
  }

  void obtenerOpcionesTipoPapel(int id) {
    for (var i = 0; i < _tipoPapelList.length; i++) {
      var p = _tipoPapelList[i];
      // var y = p.id;
      if (id == p.id) {
        var list = p.opciones;
        if (list.isNotEmpty) {
          setState(() {
            _gramajeList = p.opciones;
          });
        }
      }
    }
  }

  Future<void> categoriaList() async {
    if (di == null) {
      datosImpresion = Categoria().fetchCategoriaS();
      await datosImpresion.then((value) => di = value);
    }

    await setState(() {
      List<dynamic> papelPortadaList = [];
      List<dynamic> tipoPapelList = [];
      List<dynamic> plastificadoList = [];
      List<dynamic> impresionInterior = [];
      List<dynamic> formatoHoja = [];
      List<dynamic> impresionPortada = [];
      // ignore: deprecated_member_use
      List<dynamic> l = List<dynamic>();
      if (datosImpresion != null || di != null) {
        for (var i = 0; i < di.length; i++) {
          //var z = di.cast<Map<dynamic, Map<String, dynamic>>>();
          var p = di[i];
          var x = Categoria.fromJson(di[i]);
          var y = p['categoria'];

          if (y == 'papelPortadas') {
            papelPortadaList.add(x);
          } else if (y == 'tipoPapel') {
            tipoPapelList.add(x);
          } else if (y == 'plastificado') {
            plastificadoList.add(x);
          } else if (y == 'impresionInterior') {
            impresionInterior.add(x);
          } else if (y == 'formatoHoja') {
            formatoHoja.add(x);
          } else if (y == 'impresionPortada') {
            impresionPortada.add(x);
          }
          //l.add(Categoria(nombre: y.toString()));
          l.add(x);
        }
        _papelPortadaList = papelPortadaList;
        _tipoPapelList = tipoPapelList;
        _plastificadolList = plastificadoList;
        _impresionInteriorList = impresionInterior;
        _formatoHojaList = formatoHoja;
        _impresionPortadaList = impresionPortada;
      }

      if (datosImpresion != null) {}
    });
  }

  List<Pedido> pedidosUs;
  Future<void> pedidosList() async {
    if (pedidosUs == null) {
      await Pedido(idCliente: sec.us.id).fetchPedido().then((value) async {
        await setState(() {
          pedidosUs = value;
        });
        if (pedidosUs != null) {}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    categoriaList();
    pedidosList();
    /*  if (sec == null) {
      return Login();
    }
*/
    setState(() {});
    return Scaffold(
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
          title: Text("Pedido Impresion"),
          centerTitle: true,
        ),
        persistentFooterButtons: [
          IconButton(
            alignment: Alignment.centerLeft,
            icon: const Icon(Icons.arrow_circle_up_sharp),
            tooltip: 'Ver Pedidos',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UsPedidos(seccion: sec, p: pedidosUs)));
            },
          ),
        ],
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            margin: const EdgeInsets.only(left: 120, right: 120, top: 20),
            child: Form(
                key: _keyPedidoImpresion,
                child: Center(
                    child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      /* Container(
                          child: (di != null) ? Text(di.toString()) : null),*/
                      TextFormField(
                        controller: _cantUnidades,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          // ignore: deprecated_member_use
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            hintText: "Cantidad Unidades",
                            helperText:
                                'Cantidad de ejemplates que desea imprimir, ejemplo: 200'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresar Cantidad';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          actualizarPrecio();
                        },
                      ),
                      TextFormField(
                        controller: _paginasInteriores,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          // ignore: deprecated_member_use
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            hintText: "Cantidad de paginas",
                            helperText:
                                'Cantidad de paginas, debe coincidir con la cantidad de paginas del archivo a imprimir'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresar cantidad de paginas';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          actualizarPrecio();
                        },
                      ),
                      /*   TextFormField(
                        controller: _urlPdf,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                            hintText: "Url PDF",
                            helperText:
                                'Ejemplo: http://127.0.0.1:8000/api/v1/pedido/'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresar url del Archivo PDF';
                          }

                          return null;
                        },
                      ),*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 40),
                              child: (_papelPortadaList != null)
                                  ? Column(
                                      children: [
                                        Text('Impresion Portadas'),
                                        DropdownButton(
                                          focusColor: Colors.blueAccent,
                                          items: _impresionPortadaList.map((a) {
                                            return DropdownMenuItem(
                                                value: a,
                                                child: Text(a.nombre));
                                          }).toList(),
                                          onChanged: (_value) => {
                                            setState(() {
                                              setState(() {
                                                _portadasSec = _value.nombre;
                                                _impresionPortadaId = _value.id;
                                              });

                                              actualizarPrecio();
                                            })
                                          },
                                          hint: Text(_portadasSec),
                                        ),
                                      ],
                                    )
                                  : null),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Column(
                                children: [
                                  Text('Papel Portadas'),
                                  DropdownButton(
                                    focusColor: Colors.blueAccent,
                                    items: _papelPortadaList.map((a) {
                                      return DropdownMenuItem(
                                          value: a, child: Text(a.nombre));
                                    }).toList(),
                                    onChanged: (_value) => {
                                      setState(() {
                                        setState(() {
                                          _papelPortadasSec = _value.nombre;
                                          _papelPortadasId = _value.id;
                                        });

                                        obtenerOpcionesPapelPortada(_value.id);
                                        actualizarPrecio();
                                      })
                                    },
                                    hint: Text(_papelPortadasSec),
                                  ),
                                ],
                              )),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Column(
                                children: [
                                  Text('Gramaje Portadas'),
                                  DropdownButton(
                                    focusColor: Colors.blueAccent,
                                    items: _gramajePPortList.map((a) {
                                      return DropdownMenuItem(
                                          value: a, child: Text(a.nombre));
                                    }).toList(),
                                    onChanged: (_value) => {
                                      setState(() {
                                        setState(() {
                                          _gramajePortadasSec = _value.nombre;
                                          _gramajePPortId = _value.id;
                                        });

                                        actualizarPrecio();
                                      })
                                    },
                                    hint: Text(_gramajePortadasSec),
                                  ),
                                ],
                              )),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Column(
                                children: [
                                  Text('Plastificado'),
                                  DropdownButton(
                                    focusColor: Colors.blueAccent,
                                    items: _plastificadolList.map((a) {
                                      return DropdownMenuItem(
                                          value: a, child: Text(a.nombre));
                                    }).toList(),
                                    onChanged: (_value) => {
                                      setState(() {
                                        setState(() {
                                          _plastificadoId = _value.id;
                                          _plastificadoSec = _value.nombre;
                                        });

                                        actualizarPrecio();
                                      })
                                    },
                                    hint: Text(_plastificadoSec.toString()),
                                  ),
                                ],
                              )),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Column(
                                children: [
                                  Text('Impresion Interior'),
                                  DropdownButton(
                                    focusColor: Colors.blueAccent,
                                    items: _impresionInteriorList.map((a) {
                                      return DropdownMenuItem(
                                          value: a, child: Text(a.nombre));
                                    }).toList(),
                                    onChanged: (_value) => {
                                      setState(() {
                                        setState(() {
                                          _impresionInteriorId = _value.id;
                                          _impresionInteriorSec = _value.nombre;
                                        });

                                        actualizarPrecio();
                                      })
                                    },
                                    hint: Text(_impresionInteriorSec),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 30),
                              child: Column(
                                children: [
                                  Text('Tipo Papel'),
                                  DropdownButton(
                                    focusColor: Colors.blueAccent,
                                    items: _tipoPapelList.map((a) {
                                      return DropdownMenuItem(
                                        value: a,
                                        child: Text(a.nombre),
                                      ); //
                                    }).toList(),
                                    onChanged: (_value) => {
                                      setState(() {
                                        _tipoPapelSec = _value.nombre;
                                        _tipoPapelSecId = _value.id;
                                        obtenerOpcionesTipoPapel(_value.id);
                                        actualizarPrecio();
                                      })
                                    },
                                    hint: Text(_tipoPapelSec),
                                  ),
                                ],
                              )),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 30),
                              child: Column(
                                children: [
                                  Text('Papel Gramaje'),
                                  DropdownButton(
                                    focusColor: Colors.blueAccent,
                                    items: _gramajeList.map((a) {
                                      return DropdownMenuItem(
                                        value: a,
                                        child: Text(a.nombre),
                                      ); //
                                    }).toList(),
                                    onChanged: (_value) => {
                                      setState(() {
                                        setState(() {
                                          _gramajePepelSec = _value.nombre;
                                          _gramajePepelId = _value.id;
                                        });

                                        actualizarPrecio();
                                      })
                                    },
                                    hint: Text(_gramajePepelSec),
                                  ),
                                ],
                              )),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 30),
                              child: Column(
                                children: [
                                  Text('Formato Hoja'),
                                  DropdownButton(
                                    focusColor: Colors.blueAccent,
                                    items: _formatoHojaList.map((a) {
                                      return DropdownMenuItem(
                                          value: a, child: Text(a.nombre));
                                    }).toList(),
                                    onChanged: (_value) => {
                                      setState(() {
                                        setState(() {
                                          _formato_hojaId = _value.id;
                                          _formato_hojaSec = _value.nombre;
                                        });

                                        actualizarPrecio();
                                      })
                                    },
                                    hint: Text(_formato_hojaSec),
                                  ),
                                ],
                              )),
                          /*    Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 30),
                              child: Column(
                                children: [
                                  Text('Encuadernacion'),
                                  DropdownButton(
                                    focusColor: Colors.blueAccent,
                                    items: _en.map((String a) {
                                      return DropdownMenuItem(
                                          value: a, child: Text(a));
                                    }).toList(),
                                    onChanged: (_value) => {
                                      setState(() {
                                        _encuadernacionSec = _value;
                                        actualizarPrecio();
                                      })
                                    },
                                    hint: Text(_encuadernacionSec),
                                  ),
                                ],
                              )),*/
                        ],
                      ),
                      Text(
                        'TOTAL: ',
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 250, vertical: 20),
                        child: TextField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          controller: _total,
                          decoration: InputDecoration(
                              helperText:
                                  'Total a pagar, importe en pesos uruguayos +iva'),
                        ),
                      ),
                      buildFutureTotal(), //METODO DE OBJETO QUE MUESTRA EL SELECTOR DE ARCHIVOS
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          child: (archivoSec == true)
                              ?
                              // ? buildColumn()
                              // :
                              // (pagoGenerado == false)
                              // ?
                              btnAccionesPago()
                              : null
                          /* : ElevatedButton(
                                   onPressed: () => launch(link.text),
                                    child: Text('Ir a pagar')),*/
                          ),
                    ],
                  ),
                )))));
  }

  bool pagoGenerado = false;
  void actualizarPrecio() {
    _total.text = "";
    if (_cantUnidades.text.isNotEmpty &&
        _papelPortadasSec != 'select' &&
        _gramajePortadasSec != 'select' &&
        _plastificadoSec != 'select' &&
        _paginasInteriores.text.isNotEmpty &&
        _impresionInteriorSec != 'select' &&
        _tipoPapelSec != 'select' &&
        _gramajePepelSec != 'select' &&
        _formato_hojaSec != 'select' &&
        _impresionPortadaId != 0)
      p = Pedido().solicitarPrecio(
          int.parse(_cantUnidades.text),
          _papelPortadasId,
          _gramajePPortId,
          _plastificadoId,
          int.parse(_paginasInteriores.text),
          _impresionInteriorId,
          _tipoPapelSecId,
          _gramajePepelId,
          _formato_hojaId,
          sec.us.id,
          _impresionPortadaId);
    p.then((value) {
      if (value != null) {
        setState(() {
          _total.text = value.precio.toString();
        });
      }
    });
  }

  List<dynamic> atributosPago = [];
  TextEditingController link = TextEditingController();
  Column btnAccionesPago() {
    return Column(
      children: [
        //linkPagoColumn(),
        Container(
          child: (pagoGenerado == true)
              ? ElevatedButton(
                  onPressed: () async {
                    bool pago = false;
                    await MPago()
                        .verificarPago(pedidoRealizado.id)
                        .then((value) => pago = value);
                    if (pago == false) {
                      await setState(() {
                        setState(() {
                          msjPago = 'Verificar pago';
                          // pagoGenerado = false;
                          launch(link.text);
                        });
                      });
                    } else {
                      setState(() {
                        msjPago =
                            'Pago verificado'; //hacer logica para verificar pago
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PedidoImpresion(
                                    seccion: sec, c: di, p: pedidosUs)));
                      });
                    }
                  },
                  child: Text(msjPago))
              : ElevatedButton(
                  onPressed: () async {
                    // await linkPagoColumn();
                    if (_cantUnidades.text.isNotEmpty &&
                        _papelPortadasSec != 'select' &&
                        _gramajePortadasSec != 'select' &&
                        _plastificadoSec != 'select' &&
                        _paginasInteriores.text.isNotEmpty &&
                        _impresionInteriorSec != 'select' &&
                        _tipoPapelSec != 'select' &&
                        _gramajePepelSec != 'select' &&
                        _formato_hojaSec != 'select' &&
                        _impresionPortadaId != 0) {
                      final name = _paths[0].name;
                      final data = _paths[0].bytes;
                      nameFile = name;
                      await MPago(
                              mail: sec.us.email,
                              precio: int.parse(_total.text),
                              nombre: sec.us.nombre)
                          .obtenerLinkDePago()
                          .then((value) {
                        if (value != null) {
                          link.text = value[1];
                          collectorId = value[0];
                        }
                        atributosPago = value;
                        setState(() async {
                          pagoGenerado = true;

                          Pedido()
                              .realizarPedidoId(
                                  //AL CONFIRMAR EL PEDIDO SE SUBIRA EL ARCHIVO PDF A AWS
                                  int.parse(_cantUnidades.text),
                                  _papelPortadasId,
                                  _gramajePPortId,
                                  _plastificadoId,
                                  int.parse(_paginasInteriores.text),
                                  _impresionInteriorId,
                                  _tipoPapelSecId,
                                  _gramajePepelId,
                                  _formato_hojaId,
                                  sec.us.id,
                                  _impresionPortadaId,
                                  int.parse(_total.text),
                                  name, //selectedFile.uri.path,
                                  link.text,
                                  collectorId)
                              .then((value) {
                            pedidoRealizado = value;
                            pedidosUs.add(value);
                            setState(() {});
                          });
                          setState(() {
                            aux = true;
                          });

                          res = await AWSClient()
                              .uploadData('ImpresionesPdf', name, data);

                          setState(() {
                            if (res == '204') {
                              load = true;
                            }
                          });
                        });
                        //  return atributosPago;
                      });
                    }
                    //  setState(() async {});
                  },
                  child: Text('Confirmar')), //linkPagoColumn() : null,
        ),
      ],
    );
  }

  String msjPago = 'Ir a pagar';
  FutureBuilder<List> linkPago() {
    return FutureBuilder<List>(
      future: MPago(
              mail: sec.us.email,
              precio: int.parse(_total.text),
              nombre: sec.us.nombre)
          .obtenerLinkDePago(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text('Pedido solicitado'),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }

  Column linkPagoColumn() {
    return Column(
      children: [
        TextFormField(
          controller: link,
          keyboardType: TextInputType.url,
          inputFormatters: <TextInputFormatter>[
            // ignore: deprecated_member_use
            WhitelistingTextInputFormatter.digitsOnly
          ],
          readOnly: true,
          decoration: InputDecoration(
              //hintText:,
              helperText: 'hacer click en el link para realizar pago'),
          /* validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresar Cantidad';
                          }

                          return null;
                        },*/
        ),
      ],
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            setState(() {
              p =
                  /*Pedido(
                cantidadUnidades: int.parse(_cantUnidades.text),
                //  portada: _portadasSec,
                papelPortada: _papelPortadasSec,
                gramajePortada: _gramajePortadasSec,
                plastificado: _plastificadoBool,
                paginasInteriores: int.parse(_paginasInteriores.text),
                impresionInterior: _impresionInteriorSec,
                tipoPapel: _tipoPapelSec,
                gramaje: _gramajeSec,
                formatoHoja: _formato_hojaSec,
                encuadernacion: _encuadernacionSec,
                idCliente: sec.us.id,
              ).solicitarPedido().*/
                  Pedido().realizarPedidoId(
                      int.parse(_cantUnidades.text),
                      _papelPortadasId,
                      _gramajePPortId,
                      _plastificadoId,
                      int.parse(_paginasInteriores.text),
                      _impresionInteriorId,
                      _tipoPapelSecId,
                      _gramajePepelId,
                      _formato_hojaId,
                      sec.us.id,
                      _impresionPortadaId,
                      int.parse(_total.text),
                      selectedFile.path,
                      link.text,
                      collectorId);
            });
          },
          child: Text('Realizar Pedido'),
        ),
      ],
    );
  }

  FutureBuilder<Pedido> buildFutureTotal() {
    return FutureBuilder<Pedido>(
      future: p,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text('Pedido Configurado, por favor suba el archivo a imprimir'),
              /* ElevatedButton(
                onPressed: () {
                  setState(() {
                    //  FilePickerDemo();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login(
                                  //SE MODIFICO RUTEO TEMPORALMENTE
                                  seccion: sec,
                                )));
                  });
                },
                child: Text('subir archivo'),
              )*/
              /* Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: new Builder(
                  builder: (ctx) {
                    return buildGridView(context);
                  },
                ),
              ),*/
              ElevatedButton(
                onPressed: () {
                  _openFileExplorer();
                },
                child: const Text("Buscar archivo"),
              ),
              /*  ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      aux = true;
                    });
                    final name = _paths[0].name;
                    final data = _paths[0].bytes;
                    res = await AWSClient()
                        .uploadData('ImpresionesPdf', name, data);

                    setState(() {
                      if (res == '204') {
                        load = true;
                      }
                    });
                  },
                  child: Text('Subir Archivo')),*/
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: (aux == true) ? buildContainer() : null)
              /*FloatingActionButton(
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                onPressed: submitMessage, //al presionar el boton de enviar
              ),*/
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return Text('Configure su pedido'); //CircularProgressIndicator();
      },
    );
  }

  FutureBuilder<Pedido> buildFutureBuilder() {
    return FutureBuilder<Pedido>(
      future: _pedido,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.toString());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }

  Widget buildGridView(BuildContext context) {
    return Wrap(
      children: List.generate(2, (index) {
        var content;
        if (index == 0) {
          // Add picture button
          var addCell = InkWell(
            onTap: () => pickerModal(context),
            child: Container(
              width: 70,
              height: 72,
              child: Icon(
                Icons.add,
                size: 50.0,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          );
          content = addCell;
        } else {
          // Selected image
          content = Container(
            decoration: BoxDecoration(
              color: const Color(0xFFECECEC),
              border: Border.all(color: Colors.transparent),
            ),
            child: (selectedFile != null)
                ? Image.file(
                    selectedFile,
                    fit: BoxFit.cover,
                    width: 70.0,
                    height: 70.0,
                  )
                : SizedBox(),
          );
        }
        return new Container(
          margin: const EdgeInsets.all(2.0),
          color: const Color(0xFFECECEC),
          child: content,
        );
      }),
    );
  }

  pickerModal(ctx) {
    showModalBottomSheet<void>(context: context, builder: _bottomSheetBuilder);
  }

  Widget _bottomSheetBuilder(BuildContext context) {
    return new Container(
      height: 260.0,
      child: new Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
        child: new Column(
          children: <Widget>[
            _renderBottomMenuItem(Icons.image, "Selecionar Archivo",
                type: FileType.any),
            new Divider(
              height: 2.0,
            ),
            /*_renderBottomMenuItem(Icons.video_label, "Video",
                type: FileType.video),*/
          ],
        ),
      ),
    );
  }

  String _fileName;

  String _directoryPath;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '')?.split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      //ESCRIBIR MANEJO DE SETEAR VARIABLE DE BOTONES
      archivoSec = true;
      _loadingPath = false;
      print(_paths.first.extension);
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  _renderBottomMenuItem(icon, title, {FileType type}) {
    var item = new Container(
      height: 60.0,
      child: Row(
        children: <Widget>[
          new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Icon(icon,
                  size: 40.0, color: Theme.of(context).primaryColorLight)),
          new Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 20.0),
                  child: new Text(
                    title,
                    style: new TextStyle(
                        fontSize: 22.0, fontStyle: FontStyle.normal),
                  ))),
        ],
      ),
    );
    return new InkWell(
      child: item,
      onTap: () async {
        Navigator.of(context).pop();
        // if
        // (type == FileType.any) {
        //selectedFile =
        // ignore: unnecessary_statements
        //FilePickerResult result = await FilePicker.platform.pickFiles();
        File a;
        // FilePickerResult
        resulto = await FilePicker.platform.pickFiles();
        setState(() {
          //selectedFile = File(resulto.files.first.extension);
        });

        // selectedFile = File.fromRawPath(result.files.first.bytes);
        /* } else if 
        (type == FileType.image) {
          selectedFile = (await FilePicker.platform
              .pickFiles(type: FileType.image)) as File;
        }*/
      },
    );
  }

  /*Future<void> submitMessage() async {
    await MPago().verificarPago(collectorId).then((value) => null);
    bool pagoRealizado;
    if (pagoRealizado == false) {}
    await _upload(selectedFile, 1);

    /* debugPrint("Subject: " + _textController1.text);
    debugPrint("Message: " + _textController2.text);*/
  }*/

  Column buildColumnExito() {
    archivoSec = true;
    return Column(
      children: [
        Text('Archivo subido con exito'),
      ],
    );
  }

  Container buildContainer() {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: (load == true)
            ? buildColumnExito()
            : const CircularProgressIndicator());
  }
}

/*Future<String> _upload(File file, int number,
      {String extension = 'pdf'}) async {
    //FilePickerResult result = await FilePicker.platform.pickFiles();

    /*if (resulto != null) {
      Uint8List fileBytes = resulto.files.first.bytes;
      String fileName = resulto.files.first.name;

      // Upload file
      await FirebaseStorage.instance
          .ref('uploads/$fileName')
          .putData(fileBytes);
    }*/
    String result;

    if (result == null) {
      // generating file name
      String fileName =
          "$number$extension\_${DateTime.now().millisecondsSinceEpoch}.$extension";
      File a = file;
      //File b = File(resulto.files.single.bytes);
      AwsS3 awsS3 = AwsS3(
          awsFolderPath: awsFolderPath,
          file: a,
          fileNameWithExt: fileName,
          poolId: '',
          region: Regions.US_WEST_2,
          bucketName: bucketName);

      setState(() => isFileUploading = true);
      displayUploadDialog(awsS3);
      try {
        try {
          result = await awsS3.uploadFile;
          debugPrint("Result :'$result'.");
        } on PlatformException {
          debugPrint("Result :'$result'.");
        }
      } on PlatformException catch (e) {
        debugPrint("Failed :'${e.message}'.");
      }
    }
    Navigator.of(context).pop();
    return result;
  }*/

/*Future displayUploadDialog(AwsS3 awsS3) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StreamBuilder(
        stream: awsS3.getUploadStatus,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return buildFileUploadDialog(snapshot, context);
        },
      ),
    );
  }*/

AlertDialog buildFileUploadDialog(
    AsyncSnapshot snapshot, BuildContext context) {
  return AlertDialog(
    title: Container(
      padding: EdgeInsets.all(6),
      child: LinearProgressIndicator(
        value: (snapshot.data != null) ? snapshot.data / 100 : 0,
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColorDark),
      ),
    ),
    content: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Text('Uploading...')),
          Text("${snapshot.data ?? 0}%"),
        ],
      ),
    ),
  );
}
