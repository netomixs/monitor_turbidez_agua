import 'package:firebase_database/firebase_database.dart';

class CaragrDatos {
  static Future<Map<dynamic, dynamic>?>? loadList(String route) async {
    Map<dynamic, dynamic> lista;

    try {
      DatabaseReference commentsRef = FirebaseDatabase.instance.ref(route);
      DatabaseEvent event = await commentsRef.once();
      lista = event.snapshot.value as Map<dynamic, dynamic>;

      return lista;
    } catch (e) {
      return null;
    }
  }

  static Future<Map<dynamic, dynamic>?>? cargarCalidadAgua() async {
    var topUserPostsRef =  FirebaseDatabase.instance.ref("datos").limitToLast(1);
    DatabaseEvent event = await topUserPostsRef.once();
    var elemento = event.snapshot.value as Map<dynamic, dynamic>;
    var resultado = <dynamic, dynamic>{};
    elemento.forEach((key, value) {
      resultado = value;
    });
    print("Aqui");
    print(resultado);
    return resultado;
  }
}
