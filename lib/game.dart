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
  static int nTablero = 1, puntos = 0;
  int puntosGanados;
  Nodo trie;
  Tablero tablero;
  String user_string;
  double visi = 0.0;
  final TextEditingController text_field_clean = TextEditingController();

  @override
  void initState() {
    super.initState();
    tablero = Tablero();
    trie = Nodo();
    tablero.crearTableroNuevo();
    user_string = "";
    trie.inicializar();
  }

  verificarPalabra(String palabra) {
    Nodo donde;
    bool encontrado;

    encontrado = false;
    for (int i = 0; i < Tablero.tamx; i++) {
      for (int j = 0; j < Tablero.tamy; j++) {
        if (tablero.palabraExiste(palabra, 0, i, j)) {
          donde = trie.buscar(palabra);
          if ((palabra.length == Nodo.tam) && donde.fin) {
            puntosGanados = 5 * palabra.length;
            puntos += puntosGanados;
            print("Palabra correcta!...");
            visi = 1.0;
            //visi = 0.0;
            encontrado = true;
          }
          Nodo.tam = 0;
        }
      }
    }
    if (!encontrado) {
      print("Palabra no existe!...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text('Tablero: $nTablero'),
            SizedBox(
              width: 45,
            ),
            Text('Puntos: $puntos'),
          ],
          mainAxisSize: MainAxisSize.max,
        ),
        //title: Text('Tablero $nTablero        Puntos $puntos'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedOpacity(
              child: Container(
                child: Text(
                  'Has ganado $puntosGanados puntos!',
                  style: Theme.of(context).textTheme.display1.copyWith(fontSize: 20,),
                ),
              ),
              opacity: visi == 1.0? 1.0 : 0.0,
              duration: Duration(seconds: 1),
            ),
            SizedBox(
              height: 30,
            ),
            //container del boton reset ////////////////////////////////////////
            Container(
              width: 250,
              alignment: Alignment.bottomRight,
              child: Container(
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
                        nTablero++;
                        tablero.crearTableroNuevo();
                      });
                    },
                  ),
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
                    print(in_string);
                    verificarPalabra(in_string);
                  });
                  /*print(in_string);
                  verificarPalabra(in_string);
                  Text(in_string);*/
                },
              ),
            ),
            SizedBox(
              height: 70,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/end');
        },
        label: Text('Terminar'),
        icon: Icon(Icons.check),
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
            width: 37,
            height: 37,
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

class EndScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Text('Juego Finalizado!',
                  style: Theme.of(context).textTheme.display1.copyWith(fontSize: 42),),
            ),
            SizedBox(height: 40,),
            Container(
              child: Text('con', style: Theme.of(context).textTheme.display1),
            ),
            Container(
              child: Text('${_GameScreenState.puntos}', style: Theme.of(context).textTheme.display4.copyWith(fontSize: 200),)
            ),
            Container(
              child: Text('puntos y ${_GameScreenState.nTablero} ${(_GameScreenState.nTablero == 1) ? 'tablero' : 'tableros'}', style: Theme.of(context).textTheme.display1,)
            ),
            SizedBox(height: 40,),
            Container(
              child: RaisedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                label: Text('Regresar al Menu Principal', style: Theme.of(context).textTheme.button.copyWith(fontSize: 20)),
                icon: Icon(Icons.arrow_back),
                shape: StadiumBorder(),
              )
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}
