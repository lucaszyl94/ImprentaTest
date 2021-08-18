import 'dart:async';
import 'dart:convert';
//import 'dart:html';
//import 'package:json_to_model/json_to_model.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final url = "http://127.0.0.1:8000/";

/*class User {
  final int userId;
  final int id;
  final String title;
  final String body;
  User({this.userId, this.id, this.title, this.body});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'] as int,
        id: json['id'] as int,
        title: json['title'] as String,
        body: json['body'] as String);
  }
  Future<List<User>> fetchUser(http.Client client) async {
    final response = await client.get(Uri.parse(url));
    return parseUser(response.body);
  }

//funcion que recibe un json y lo deserializa en una lista de fotos
  List<User> parseUser(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }
}*/
class User {
  //CLASE PARA PROBAR USARIO DE URL http://127.0.0.1:8000/api/v1/heroes/
  // final String userId;
  // final int id;
  //final String name;
  final String users;
  //final double price;
  User({
    //this.id,
    //this.name,
    this.users,
    //this.price
  }); //ADAPTO ATRIBUTOS DE LOS QUE VAYA A USAR

  factory User.fromJson(Map<String, dynamic> json) {
    //DESERIALIZADOR DE JSON A OBJETO, EN ESTE CASO A USER
    return User(
      // userId: json['userId'] as String,
      //   id: json['Id'] as int,
      // name: json['Name'] as String,
      users: json['users'] as String,
      //price: json['Price'] as double
    );
  }
  Future<List<User>> fetchUser(http.Client client) async {
    final response = await client.get(Uri.parse('http://127.0.0.1:8000/'),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "true"
        }); //https://jsonplaceholder.typicode.com/posts
    return parseUser(response.body);
  }

  User postFromJson(String str) {
    final jsonData = json.decode(str);
    return User.fromJson(jsonData);
  }

  String url1 = 'https://jsonplaceholder.typicode.com/posts';

  Future<User> getPost() async {
    final response = await http.get(Uri.parse('$url1/1'));
    return postFromJson(response.body);
  }

  Future<User> createPost(User post) async {
    final response = await http.post(Uri.parse('$url'),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode(post));
    return postFromJson(response.body);
  }

//funcion que recibe un json y lo deserializa en una lista de fotos
  List<User> parseUser(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }
}

///clase que deberia ir en un archivo diferente y ser importada??
class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }

  //METODOS
  //funcion llama y devuelve una lista de fotos
  Future<List<Photo>> fetchPhotos(http.Client client) async {
    final response = await client.get(
        Uri.parse("https://jsonplaceholder.typicode.com/photos"),
        headers: {
          "Accept": "application/json",
          'Access-Control-Allow-Credentials': 'true'
        });
    return parsePhotos(response.body);
  }

//funcion que recibe un json y lo deserializa en una lista de fotos
  List<Photo> parsePhotos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
  }
}

////FIN DE CLASE PHOTO
///
///
///
// ignore: must_be_immutable
class PhotoPrueba extends StatelessWidget {
  PhotoPrueba({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<User>>(
            future: User().fetchUser(
                http.Client()), //REALIZA LA LLAMADA A LA API USANDO EL GET
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return UserList(users: snapshot.data);
              } else if (snapshot.hasError) {
                //SI OCURRE ALGUN ERROR LO MOSTRARA
                return Text("${snapshot.error}"); //ACA
              }

              // Por defecto, muestra un loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class PhotoList extends StatelessWidget {
  final List<Photo> photos;
  PhotoList({Key key, this.photos}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Text(photos[index].thumbnailUrl);
        });
  }
}

class UserList extends StatelessWidget {
  //CLASE QUE TOMARA LA LISTA DE USUARIOS DE FUNCIONAR EL GET
  final List<User> users;
  UserList({Key key, this.users}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Text(users[index].users);
        });
  }
}
