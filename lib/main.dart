import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //asegurarse que las variables esten inicializadas antes de empezar
  await dotenv.load(
    fileName: ".env",
  ); //llamar al archivo de las variables de entorno
  assert(
    dotenv.env['apiurl'] != null,
    'url mal configurada',
  ); //verificar que el archivo este bien cargado
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _mensaje = 'nada';
  @override
  void initState() {
    super.initState();
    verificarConexion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(_mensaje)],
        ),
      ),
    );
  }

  Future<void> verificarConexion() async {
    final String _url = dotenv.get('apiurl');
    final respuesta = await http.get(Uri.parse('$_url/obtener'));
    Map<String, dynamic> mensaje = jsonDecode(respuesta.body);
    if (respuesta.statusCode == 200) {
      setState(() {
        _mensaje = mensaje['message'];
      });
    } else {
      setState(() {
        _mensaje = "conexion fallida";
      });
    }
  }
}
