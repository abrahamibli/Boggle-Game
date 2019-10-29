import 'package:flutter/material.dart';
import 'boogle.dart';
import 'package:flutter/foundation.dart';

/// Controla la pantalla del tablero
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

/// Instancia las clases principales Tablero y Nodo para crear la logica del juego y,
/// define el Widget que muestra los elementos principales del juego
/// y de interaccion con el usuario
class _GameScreenState extends State<GameScreen> {
  static int nTablero, puntos, nDiccionario; // Numero de refrescos del tablero, puntos totales del usuario, numero de palabras en el diccionario
  int puntosGanados; // Puntos parciales, multiplicador x5 cuando encuentra una palabra
  Nodo trie; // Nueva estructura trie
  Tablero tablero; // Nuevo Tablero
  String user_string; // Captura cadena escrita por el usuario en el TextField
  List<String> encontradas; // Lista palabras encontradas por el usuario
  double visi; // Controla animacion de texto cuando usuario encuentra palabra
  final TextEditingController text_field_clean = TextEditingController(); // Controlador que limpia TextField cuando usuario deja de escribir en él

  @override
  void initState() {
    super.initState();
    visi = 0.0;
    puntos = 0;
    puntosGanados = 0;
    nTablero = 1;
    nDiccionario = 80257;
    encontradas = List<String>();
    tablero = Tablero();
    trie = Nodo();
    tablero.crearTableroNuevo();
    user_string = "";
    trie.inicializar();
  }

  /// Suma puntos a [puntos] si la palabra fue correcta.
  ///
  /// Actualiza valores de variables [puntos], [nDiccionario] y la lista [encontradas] cuando
  /// una palabra es encontrada tanto en el tablero como en el trie
  verificarPalabra(String palabra) {
    Nodo donde;
    bool encontrado = false;

    for (int i = 0; i < Tablero.tamx; i++) {
      for (int j = 0; j < Tablero.tamy; j++) {
        if (tablero.palabraExiste(palabra, 0, i, j)) {
          donde = trie.buscar(palabra);
          if ((palabra.length == Nodo.tam) && donde.fin) {
            print("Palabra correcta!...");
            if (!encontradas.contains(palabra)) {
              puntosGanados = 5 * palabra.length;
              puntos += puntosGanados;
              nDiccionario--;
              encontradas.add(palabra);
              encontrado = true;
            }
            visi = 1.0;
          }
          Nodo.tam = 0;
        }
      }
    }
    if (!encontrado) {
      puntosGanados = 0;
      visi = 1.0;
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
            /// Coloca el numero de tableros actuales de la partida en la AppBar
            Text('Tablero: $nTablero'),

            /// Caja vacia con ancho de 45 p
            SizedBox(
              width: 45,
            ),

            /// Coloca el puntaje actual del usuario en la AppBar
            Text('Puntos: $puntos'),
          ],
          mainAxisSize: MainAxisSize.max,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
              child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /// Muestra Texto animado cuando el usuario escribe una palabra
              AnimatedOpacity(
                child: Container(
                  child: Text(
                    '${puntosGanados > 0 ? 'Correcto, has ganado $puntosGanados puntos!' : 'Incorrecta o repetida, 0 puntos :C'}',
                    style: Theme.of(context).textTheme.display1.copyWith(
                          fontSize: 20,
                        ),
                  ),
                ),
                opacity: visi == 1.0 ? 1.0 : 0.0,
                duration: Duration(seconds: 1),
              ),

              /// Caja vacia con altura de 30 p
              SizedBox(
                height: 30,
              ),

              /// Container del boton 'refrescar'
              Container(
                width: 250,
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 20.0,
                        spreadRadius: 5.0,
                        offset: Offset(7.0, 7.0),
                      ),
                    ],
                  ),
                  child: Center(
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        Icons.autorenew,
                      ),
                      iconSize: 20,
                      tooltip: "refrescar tablero",
                      onPressed: () {
                        print("click it");

                        /// incrementa variable [nTablero], y genera un tablero con
                        /// caracteres aleatorios nuevos
                        setState(() {
                          nTablero++;
                          encontradas.clear();
                          tablero.crearTableroNuevo();
                        });
                      },
                    ),
                  ),
                ),
              ),

              /// Container principal del tablero
              Container(
                width: 250,
                height: 250,
                child: Board(
                  boardData: tablero.getTablero(),
                ),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 20.0,
                      spreadRadius: 5.0,
                      offset: Offset(7.0, 7.0),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
              ),

              /// Container del TextField
              Container(
                margin: EdgeInsets.only(top: 50),
                width: 250,
                child: TextField(
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                  ),
                  maxLength: 30,
                  decoration: InputDecoration(
                    hintText: "Escribe tu palabra aqui",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  controller: text_field_clean,

                  /// se encarga de desaparecer el texto de cuando
                  /// el usuario inserta una palabra
                  onTap: () {
                    visi = 0.0;
                  },
                  onSubmitted: (String in_string) {
                    /// Captura la cadena del usuario en la variable [user_string] y,
                    /// limpia el TextField posteriormente
                    setState(() {
                      user_string = in_string;
                      text_field_clean.text = "";
                      print(in_string);
                      verificarPalabra(in_string);
                    });
                  },
                ),
              ),

              /// Caja vacia con altura de 70 p
              SizedBox(
                height: 70,
              ),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        /// Boton 'Terminar' que nos dirije a la pantalla final de resultados
        onPressed: () {
          Navigator.of(context).pushNamed('/end');
        },
        label: Text('Terminar'),
        icon: Icon(Icons.check),
      ),
    );
  }
}

/// Inserta la lista de caracteres del tablero a Containers individuales
class Board extends StatelessWidget {
  final String boardData;

  const Board({
    Key key,
    this.boardData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
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

/// Controla la pantalla final de puntuacion del usuario
class EndScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope( 
      onWillPop: () async {
        return Navigator.popAndPushNamed(context, '/');
      },
      child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          children: <Widget>[
            /// Container que muestra un texto simple
            Container(
              child: Text(
                'Juego Finalizado!',
                style:
                    Theme.of(context).textTheme.display1.copyWith(fontSize: 42),
              ),
            ),

            /// Caja vacia con altura de 40 p
            SizedBox(
              height: 40,
            ),

            /// Container que muestra texto simple
            Container(
              child: Text('con', style: Theme.of(context).textTheme.display1),
            ),

            /// Container que imprime el puntaje en el centro de la pantalla con una fuente grande
            Container(
                child: Text(
              '${_GameScreenState.puntos}',
              style:
                  Theme.of(context).textTheme.display4.copyWith(fontSize: 200),
            )),

            /// Container que imprime los tableros usados por el usuario
            Container(
                child: Text(
              'puntos y ${_GameScreenState.nTablero} ${(_GameScreenState.nTablero == 1) ? 'tablero' : 'tableros'}',
              style: Theme.of(context).textTheme.display1,
            )),

            /// Caja vacia con altura de 10 p
            SizedBox(
              height: 10,
            ),

            /// Container que imprime el numero de palabras faltantes a encontrar en el diccionario
            Container(
                child: Text(
              '${_GameScreenState.nDiccionario} palabras faltantes de encontrar...',
              style:
                  Theme.of(context).textTheme.display1.copyWith(fontSize: 15),
            )),

            /// Caja vacia con altura de 40 p
            SizedBox(
              height: 40,
            ),

            /// Container del boton que nos envia al menu principal
            Container(
                child: RaisedButton.icon(
              /// Nos dirige a la pantalla inicial del juego
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              elevation: 20,
              label: Text('Regresar al Menu Principal',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(fontSize: 20)),
              icon: Icon(Icons.arrow_back),
              shape: StadiumBorder(),
            )),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      ),
    );
  }
}

/*Future<bool> _willPopCallback() async {
    return Navigator.canPop(context);
}

class _State extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
    );
  }
}*/