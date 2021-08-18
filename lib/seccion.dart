import 'package:app_imprenta/usuario.dart';

class Seccion {
  final String token;
  Usuario us;
  Seccion({this.token, this.us});

  /* factory Seccion.fromJson(Map<String, dynamic> json) {
    return Seccion(
      token: json['token'] as String,
    );
  }*/
}
