import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://economia.awesomeapi.com.br/all/USD-BRL,EUR-BRL";

void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChange(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }
  void _dolarChange(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }
  void _euroChange(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando Dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if(snapshot.hasError){
                  return Center(
                    child: Text(
                      "Erro ao Carregar Dados :(",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                }else{
//                  print(snapshot.data["USD"]["ask"].replaceAll(",", "."));
                  dolar = double.parse(snapshot.data["USD"]["ask"].replaceAll(",", "."));
                  euro =  double.parse(snapshot.data["EUR"]["ask"].replaceAll(",", "."));
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 150.0,
                          color: Colors.amber,
                        ),
                        buildTextField("Reais", "R\$", realController, _realChange),
                        Divider(),
                        buildTextField("Dólares", "US\$", dolarController, _dolarChange),
                        Divider(),
                        buildTextField("Euros", "€", euroController, _euroChange),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField( String label, String prefix, TextEditingController c, Function f){
  return TextField(
    decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber)
        ),
        border: OutlineInputBorder(),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.amber,
        ),
        prefixText: prefix,
        prefixStyle: TextStyle(
            color: Colors.amber
        )
    ),
    style: TextStyle(
        color: Colors.amber,
        fontSize: 25.0
    ),
    controller: c,
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
