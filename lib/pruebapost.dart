import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/*Future<Album> createAlbum(String title) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}*/

Future<User> createUser(String name, String alias) async {
  //LLAMADA A LA API PARA REALIZAR UN POST
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/v1/heroes/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'name': name, 'alias': alias}),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return User.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class User {
  // final String userId;
  final int id;
  final String name;
  final String alias;
  User({this.id, this.name, this.alias});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        // userId: json['userId'] as String,
        id: json['id'] as int,
        name: json['name'] as String,
        alias: json['alias'] as String);
  }
  Future<List<User>> fetchUser(http.Client client) async {
    final response = await client.get(Uri.parse(
        'http://127.0.0.1:8000/api/v1/heroes/')); //https://jsonplaceholder.typicode.com/posts
    return parseUser(response.body);
  }

//funcion que recibe un json y lo deserializa en una lista de fotos
  List<User> parseUser(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }
}

class Album {
  final int id;
  final String title;

  Album({this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}

class PruebaPost extends StatefulWidget {
  PruebaPost({Key key}) : super(key: key);

  @override
  _PruebaPostState createState() {
    return _PruebaPostState();
  }
}

class _PruebaPostState extends State<PruebaPost> {
  //final TextEditingController _controller = TextEditingController();
  //final TextEditingController _userId = TextEditingController();
  // final TextEditingController _id = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _body = TextEditingController();
  Future<User> _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureAlbum == null)
              ? buildColumn()
              : buildFutureBuilder(), //PREGUNTA SI FUTUREALBUN ESTA VACIO Y EN FUNCION DE ESO LLAMA AL WIDGET QUE CORRESPONDA
        ),
      ),
    );
  }

  Column buildColumn() {
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        /*  TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'Enter Title'),
        )*/
        /* TextField(
          controller: _userId,
          decoration: InputDecoration(hintText: 'userid'),
        ),*/
        TextField(
          controller: _title,
          decoration: InputDecoration(hintText: 'nombre'),
        ),
        /* TextField(
          controller: _id,
          decoration: InputDecoration(hintText: 'id'),
        ),*/
        TextField(
          controller: _body,
          decoration: InputDecoration(hintText: 'alias'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAlbum = createUser(
                  _title.text,
                  _body
                      .text); //AL COMPLETAR CAMPOS Y PRESIONAR EL BOTON DISPARA ESTA FUNCION QUE LLAMA A LA API PARA REALIZAR EL POST
            });
          },
          child: Text('Create Data'),
        ),
      ],
    );
  }

  FutureBuilder<User> buildFutureBuilder() {
    return FutureBuilder<User>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
              snapshot.data.name); //SI RECIBE DATA MUESTRA SOLO EL NOMBRE
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}'); //SI OCURRE UN ERROR LO MUESTRA
        }

        return CircularProgressIndicator();
      },
    );
  }
}
