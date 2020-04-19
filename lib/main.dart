

// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //PERMITE FAZER AS REQUISIÇÕES
import 'dart:async'; //PERMITE FAZER REQUISIÇOES SEM ESPERAR, DENOMINADA REQUISIÇÃO ASSINCRONA
import 'dart:convert';

const request =
    'https://api.hgbrasil.com/finance/quotations?key=35b72e1a'; //PARA UTILIZAR ESSA API, DEVE SER CRIADA NO SITE https://hgbrasil.com/

void main() async {
  //FUNÇÃO ASSINCRONA
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData( //DEFINE UM TEMA PARA O APP INTEIRO
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  //RESPOSTA DO SERVIDOR  //ESPERA  //SOLICITANDO ALGO AO SERVIDOR,NÃO RESPONDE NA HORA
  http.Response response = await http.get(request); //RETORNA UM DADO FUTURO
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //CONTROLADORES
  final realController = TextEditingController(); //UTILIZA-SE O FINAL, QUANDO O CONTROLADOR NÃO IRÁ MUDAR EM NENHUM MOMENTO
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar; //DECLARANDO VARIAVEIS
  double euro;

  //FUNÇÕES
  void _realChanged(String text){
    double real = double.parse(text); //TRANSFORMANDO TEXTO DE STRING PARA DOUBLE
    dolarController.text = (real/dolar).toStringAsFixed(2); // CONVERTENDO REAL/DOLAR
    euroController.text = (real/euro).toStringAsFixed(2);   // CONVERTENDO REAL/EURO
  }
  void _dolarChanged(String text){
    double dolar = double.parse(text); //TRANSFORMANDO TEXTO DE STRING PARA DOUBLE
    realController.text = (dolar * this.dolar).toStringAsFixed(2); // CONVERTENDO DOLAR/REAL
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);   // CONVERTENDO VALOR PARA REAL E DIVIDINDO POR EURO
  }
  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2); // CONVERTENDO EURO/REAL
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2); //CONVERTENDO VALOR PARA REAL E DIVIDINDO POR DOLAR
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        // PARA IDENTIFICAR UM CARACTERE ESPECIAL COMO TEXT COLOCAR UMA \(BARRA INVERTIDA) ANTES
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>( //ESPECIFICA O FUTURO
          future: getData(), // SOLICITA OS DADOS E RETORNA NO FUTURO
          builder: (context, snapshot) {
            switch (snapshot.connectionState) { //ESTADO DA CONEXÃO
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text("Carregando Dados...",
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0),
                  textAlign: TextAlign.center,)
                );
              default:
                if (snapshot.hasError) {//QUANDO HOUVER ERRO SERÁ EXECUTADO
                  return Center(
                      child: Text("Erro ao Carregar Dados :(",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0),
                    textAlign: TextAlign.center,)
                  );
                }else{//CASO NÃO OCORRA ERRO SERÁ EXECUTADO
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                        buildTextField("Reais", "R\$", realController, _realChanged),   //CHAMADA DA FUNÇÃO
                        Divider(),
                        buildTextField("Dólares", "US\$", dolarController, _dolarChanged), //CHAMADA DA FUNÇÃO
                        Divider(),
                        buildTextField("Euros", "€", euroController, _euroChanged),      //CHAMADA DA FUNÇÃO
                    ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){ //FUNÇÃO
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber, fontSize: 25.0
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );

}