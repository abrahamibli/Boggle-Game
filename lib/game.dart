import 'package:flutter/material.dart';
import 'boogle.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';


class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int nTablero = 1;
  Nodo trie;
  Tablero tablero;
  String user_string;
  final TextEditingController text_field_clean = TextEditingController();

  @override
  void initState() {
    super.initState();
    tablero = Tablero();
    trie = Nodo();
    tablero.crearTableroNuevo();
    user_string = "";
    initTrie();
    //print(trie.buscar("mapa"));
  }

  initTrie() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    print(appDocPath);
    //String filePath = '${appDocDir.path}/diccionario.txt';
    //await trie.inicializar(filePath);
  }

  verificarPalabra(String palabra) {
    String palabra; 
    int puntos = 0;
    Nodo donde;
    bool encontrado;

    encontrado = false;
    for(int i=0; i<Tablero.tamx; i++) {
      for(int j=0; j<Tablero.tamy; j++) {
          if(tablero.palabraExiste(palabra, 0, i, j)){
            donde = trie.buscar(palabra);
            if((palabra.length == Nodo.tam) && donde.fin) {
              puntos += 25;
              //print("Palabra correcta!... Ganaste 25 puntos");
              encontrado = true;
            }
            Nodo.tam = 0;
          }
      }
    }
    if(!encontrado) {
      //print("Palabra no existe!... Ganaste 0 puntos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Tablero $nTablero'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            //container del boton reset ////////////////////////////////////////
            Container(
              color: Theme.of(context).accentColor,
              width: 35,
              height: 35,
              child: Center(
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(
                    Icons.autorenew,
                  ),
                  iconSize: 20,
                  tooltip: "restart table",
                  onPressed: () {
                    print("click it");
                    setState(() {
                     tablero.crearTableroNuevo(); 
                    });
                  },
                ),
              ),
            ),
            //container del tablero ////////////////////////////////////////
            Container(
              width: 250,
              height: 250,
              child: Board(
                boardData: tablero.getTablero(),
              ),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
            ),
            //container del TextField ////////////////////////////////////////
            Container(
              margin: EdgeInsets.only(top: 50),
              width: 250,
              child: TextField(
                maxLength: 30,
                decoration: InputDecoration(
                  hintText: "Escribe tu palabra aqui",
                ),
                controller: text_field_clean,
                onSubmitted: (String in_string) {
                  setState(() {
                    user_string = in_string;
                    text_field_clean.text = "";
                  });
                },
              ),
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}

class Board extends StatelessWidget {
  final String boardData;

  const Board({
    Key key,
    this.boardData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 5,
      children: List.generate(25, (index) {
        return Center(
          child: Container(
            width: 35,
            height: 35,
            alignment: Alignment.center,
            child: Text(
              '${boardData[index]}',
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(color: Colors.black, fontSize: 20),
            ),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(
                  Radius.circular(5),
              ),
            ),
          ),
        );
      }),
    );
  }
}
