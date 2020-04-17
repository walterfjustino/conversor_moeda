import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //PERMITE FAZER AS REQUISIÇÕES
import 'dart:async';  //PERMITE FAZER REQUISIÇOES SEM ESPERAR, DENOMINADA REQUISIÇÃO ASSINCRONA
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance/quotations?key=35b72e1a'; //PARA UTILIZAR ESSA API, DEVE SER CRIADA NO SITE https://hgbrasil.com/


void main() async { //FUNÇÃO ASSINCRONA
  runApp(MaterialApp(
    home: Home(),
  ));
}

Future<Map> getData() async{
  //RESPOSTA DO SERVIDOR  //ESPERA  //SOLICITANDO ALGO AO SERVIDOR,NÃO RESPONDE NA HORA
  http.Response response = await http.get(request);   //RETORNA UM DADO FUTURO
  return json.decode(response.body);
}

class  Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"), // PARA IDENTIFICAR UM CARACTERE ESPECIAL COMO TEXT COLOCAR UMA \(BARRA INVERTIDA) ANTES
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),

    );
  }
}