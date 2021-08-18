import 'package:app_imprenta/pedido.dart';
import 'package:app_imprenta/seccion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'login.dart';

// ignore: must_be_immutable
class AdmPedidos extends StatefulWidget {
  AdmPedidos({Key key, this.seccion, this.p}) : super(key: key);
  final Seccion seccion;
  List<Pedido> p;

  @override
  State<StatefulWidget> createState() => AdmPedidosState(seccion, p);
}

class AdmPedidosState extends State<AdmPedidos> {
  List<Pedido> pedidos = [];
  Future<List<Pedido>> ped;

  AdmPedidosState(this.sec, this.pedidos) {
    // pedidosList();
    if (this.pedidos == null) {
      pedidosList();
    }

    //pedidosList();
    /* ped = Pedido(idCliente: sec.us.id).fetchPedido();
    ped.then((value) => pedidos = value);*/
  }
  Future<void> pedidosList() async {
    await Pedido().fetchPedidos().then((value) async {
      await setState(() {
        pedidos = value;
      });
    });
    //await ped.then((value) => pedidos = value);

    if (pedidos != null) {}
  }

  // Pedido(idCliente: sec.us.id).fetchPedido().then((value) =>pedidos=value );
  Seccion sec;
  @override
  Widget build(BuildContext context) {
    if (sec == null) {
      return Login();
    }

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
          margin: const EdgeInsets.only(left: 80, right: 80, top: 20),
          child: (pedidos != null)
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: pedidos.length,
                  // ignore: missing_return
                  itemBuilder: (context, index) {
                    return buildContainer(pedidos[index]);
                  })
              : CircularProgressIndicator()),
    );
  }
}

// ignore: must_be_immutable
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
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'ID: ' +
            pedido.id.toString() +
            '\n' +
            'Cantidad Unidades: ' +
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
            pedido.estado,
        textAlign: TextAlign.left,
      ),
      Container(
        alignment: Alignment.bottomCenter,
        child: bulidColumnActions(pedido), //btnVer(pedido),
      )
    ],
  );
}

ElevatedButton btnVer(Pedido p) {
  return ElevatedButton(
      onPressed: () {
        vistaPedido(p);
      },
      child: Text('Ver Pedido'));
}

CupertinoAlertDialog vistaPedido(Pedido pedido) {
  return CupertinoAlertDialog(
      title: Text('Pedido'),
      content: Column(
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
              pedido.estado),
          bulidColumnActions(pedido),
        ],
      ));
}

Row bulidColumnActions(Pedido p) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(
          onPressed: () {},
          child: Text('Descargar'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          )),
      ElevatedButton(
        onPressed: () {},
        child: Text('Aceptar'),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        ),
      ),
      ElevatedButton(
          onPressed: () {},
          child: Text('Rechazar'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ))
    ],
  );
}
