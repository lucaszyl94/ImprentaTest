import 'package:app_imprenta/pedidoImpresion.dart';
import 'package:app_imprenta/seccion.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//import 'AWSClient.dart';
import 'AWSClient.dart';
import 'login.dart';

class FilePickerDemo extends StatefulWidget {
  final Seccion seccion;

  const FilePickerDemo({Key key, this.seccion}) : super(key: key);
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState(seccion);
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _FilePickerDemoState(this.sec);
  Seccion sec;
  String _fileName;
  List<PlatformFile> _paths;
  String _directoryPath;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();
  //TextEditingController _res = TextEditingController();
  String res;
  bool load = false;
  bool aux = false;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

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
      _loadingPath = false;
      print(_paths.first.extension);
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  @override
  Widget build(BuildContext context) {
    /*  if (sec == null) {
      return Login();
    }*/
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
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
            IconButton(
              alignment: Alignment.centerRight,
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Volver',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PedidoImpresion(
                              seccion: sec,
                            )));
              },
            ),
          ],
          title: const Text('Subir archivo para imprimir'),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 100.0),
                  child: const SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _openFileExplorer(),
                        child: const Text("Buscar archivo"),
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (BuildContext context) => _loadingPath
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: const CircularProgressIndicator(),
                        )
                      : _directoryPath != null
                          ? ListTile(
                              title: const Text('Directory path'),
                              subtitle: Text(_directoryPath),
                            )
                          : _paths != null
                              ? Container(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  child: Scrollbar(
                                      child: ListView.separated(
                                    itemCount:
                                        _paths != null && _paths.isNotEmpty
                                            ? _paths.length
                                            : 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final bool isMultiPath =
                                          _paths != null && _paths.isNotEmpty;
                                      final String name = 'Archivo ' +
                                          (isMultiPath
                                              ? _paths
                                                  .map((e) => e.name)
                                                  .toList()[index]
                                              : _fileName ?? '...');

                                      return ListTile(
                                        title: Text(
                                          name,
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(),
                                  )),
                                )
                              : const SizedBox(),
                ),
                ElevatedButton(
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
                    child: Text('Subir Archivo')),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: (aux == true) ? buildContainer() : null),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Column buildColumn() {
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
        child:
            (load == true) ? buildColumn() : const CircularProgressIndicator());
  }
}
