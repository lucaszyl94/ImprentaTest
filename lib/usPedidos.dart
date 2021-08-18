// ignore_for_file: must_be_immutable

import 'package:app_imprenta/pedido.dart';
import 'package:app_imprenta/seccion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter/services.dart';
import 'login.dart';

class UsPedidos extends StatefulWidget {
  UsPedidos({Key key, this.seccion, this.p}) : super(key: key);
  final Seccion seccion;
  List<Pedido> p;
  /*Future<List<Pedido>> pedidosList() async {
    return Pedido(idCliente: seccion.us.id)
        .fetchPedido()
        .then((value) => p = value);
  }*/

  @override
  State<StatefulWidget> createState() => UsPedidosState(seccion, p);
}

class UsPedidosState extends State<UsPedidos> {
  List<Pedido> pedidos;
  Future<List<Pedido>> ped;
  UsPedidosState(this.sec, this.pedidos) {
    // pedidosList();
    if (this.pedidos == null) {
      pedidosList();
    }
    //pedidosList();
    /* ped = Pedido(idCliente: sec.us.id).fetchPedido();
    ped.then((value) => pedidos = value);*/
  }
  Future<void> pedidosList() async {
    await Pedido(idCliente: sec.us.id).fetchPedido().then((value) async {
      await setState(() {
        pedidos = value;
      });
      if (pedidos != null) {}
    });
  }

  // Pedido(idCliente: sec.us.id).fetchPedido().then((value) =>pedidos=value );
  Seccion sec;
  @override
  Widget build(BuildContext context) {
    if (sec == null) {
      return Login();
    }
    setState(() {});
    //  Pedido(idCliente: sec.us.id).fetchPedido().then((value) => pedidos = value);
    // Pedido(idCliente: sec.us.id).fetchPedido().then((value) =>pedidos=value );
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
        title: Text("Pedidos"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        margin: const EdgeInsets.only(left: 120, right: 120, top: 20),
        child: (pedidos == null)
            ? CircularProgressIndicator()
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  return buildContainer(pedidos[index]);
                }),
      ),
    );
  }
}

class PedidosList extends StatefulBuilder {
  //CLASE QUE TOMARA LA LISTA DE USUARIOS DE FUNCIONAR EL GET
  List<Pedido> pedidos;
  PedidosList({Key key, this.pedidos});
  @override
  // ignore: override_on_non_overriding_member
  Widget build(BuildContext context) {
    if (pedidos == null) {
      return CircularProgressIndicator();
    } else {
      return GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: pedidos.length,
          itemBuilder: (context, index) {
            return Text(pedidos[index].url);
          });
    }
  }
}

Column buildContainer(Pedido pedido) {
  return Column(
    children: [
      Text('Cantidad Unidades: ' +
              pedido.cantidadUnidades.toString() +
              '\n' +
              'Formato Hoja: ' +
              pedido.formatoHoja +
              '\n' +
              'Impresion Interior: ' +
              pedido.impresionInterior +
              '\n' +
              'Papel Portada: ' +
              pedido.papelPortada +
              '\n' +
              'Tipo Papel: ' +
              pedido.tipoPapel +
              '\n' +
              'Gramaje: ' +
              pedido.gramaje.toString() +
              '\n' +
              'Gramaje Portada: ' +
              pedido.gramajePortada.toString() +
              '\n' +
              'Paginas Interiores: ' +
              pedido.paginasInteriores.toString() +
              '\n' +
              'Plastificado: ' +
              pedido.plastificado.toString() +
              '\n' +
              'Precio: ' +
              pedido.precio.toString() +
              '\n' +
              'Estado: ' +
              pedido
                  .estado /*+
          '\n' +
          'Link de Pago: ' +
          pedido.linkPago*/
          ),
      Container(
        child: (pedido.estado == 'pendiente')
            ? btnCompletarPago(pedido.linkPago)
            : null,
      )
    ],
  );
}

ElevatedButton btnCompletarPago(String link) {
  return ElevatedButton(
      onPressed: () => launch(link), child: Text('Completar Pago'));
}
