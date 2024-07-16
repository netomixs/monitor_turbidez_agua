import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monitor_sensores/cargar_daos.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Monitor extends StatefulWidget {
  const Monitor({super.key});

  @override
  State<Monitor> createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  var valorActual = 45;
  DateTime ultimaActualizaicion = DateTime.now();
  var topUserPostsRef = FirebaseDatabase.instance.ref("datos").limitToLast(1);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder(
                stream: topUserPostsRef.onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error al obtener la lista'));
                  } else {
                    var resultado = <dynamic, dynamic>{};
                    if (snapshot.hasData &&
                        snapshot.data!.snapshot.value != null) {
                      var elemento = snapshot.data!.snapshot.value
                          as Map<dynamic, dynamic>;

                      elemento.forEach((key, value) {
                        resultado = value;
                      });
                    }
                    valorActual = int.parse(resultado["agua"]);
                    DateFormat format = DateFormat("dd/MM/yyyy HH:mm:ss");
                    ultimaActualizaicion = format.parse(resultado["tiempo"]);
                  }

                  return Container(
                    margin: EdgeInsets.only(top: 32),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16, left: 16, right: 16, bottom: 4),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Text(
                                  "Calidad del agua",
                                  style: TextStyle(fontSize: 23),
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 80.0,
                                startAngle: 10,
                                lineWidth: 20.0,
                                percent: valorActual / 100,
                                center: Text(
                                  "$valorActual%",
                                  style: const TextStyle(fontSize: 28),
                                ),
                                progressColor: getColorForValue(valorActual),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Ultima actualizacion: $ultimaActualizaicion",
                                        style: const TextStyle(fontSize: 9),
                                      ),
                                    ]),
                              )
                            ]),
                      ),
                    ),
                  );
                }),
          ],
        ));
  }

  Color getColorForValue(int value) {
    if (value <= 5) {
      return Color.fromARGB(255, 0, 0, 0);
    }
    if (value <= 10) {
      return Color.fromARGB(255, 58, 47, 38);
    } else if (value <= 20) {
      return Color.fromARGB(255, 109, 81, 50);
    } else if (value <= 40) {
      return Color.fromARGB(255, 255, 0, 0);
    } else if (value <= 60) {
      return Color.fromARGB(255, 255, 123, 0);
    } else if (value <= 80) {
      return Color.fromARGB(255, 255, 208, 0);
    } else {
      // De negro a negro
      return const Color.fromARGB(255, 0, 0, 255);
    }
  }
}
