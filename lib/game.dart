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
  static int nTablero,
      puntos,
      nDiccionario; // Numero de refrescos del tablero, puntos totales del usuario, numero de palabras en el diccionario
  int puntosGanados; // Puntos parciales, multiplicador x5 cuando encuentra una palabra
  Nodo trie; // Nueva estructura trie
  Tablero tablero; // Nuevo Tablero
  String user_string; // Captura cadena escrita por el usuario en el TextField
  List<String> encontradas,
      encontradasTotales; // Lista palabras encontradas por el usuario
  static double visi; // Controla animacion de texto cuando usuario encuentra palabra
  final TextEditingController text_field_clean =
      TextEditingController(); // Controlador que limpia TextField cuando usuario deja de escribir en él
  static bool cargando;
  static String palUsuario = '';
  Color colorBorde;

  @override
  void initState() {
    super.initState();
    cargando = true;
    colorBorde = Colors.transparent;
    visi = 0.0;
    puntos = 0;
    puntosGanados = 0;
    nTablero = 1;
    nDiccionario = 80257;
    encontradas = List<String>();
    encontradasTotales = List<String>();
    tablero = Tablero();
    trie = Nodo();
    tablero.crearTableroNuevo();
    user_string = "";
    initTrie();
  }

  void initTrie() async {
    await trie.inicializar();
    setState(() {
      cargando = false;
    });
  }

  /// Suma puntos a [puntos] si la palabra fue correcta.
  ///
  /// Actualiza valores de variables [puntos], [nDiccionario] y la lista [encontradas] cuando
  /// una palabra es encontrada tanto en el tablero como en el trie
  verificarPalabra(String palabra) {
    Nodo donde;
    bool encontrado = false;

    donde = trie.buscar(palabra);
    if ((palabra.length == Nodo.tam) && donde.fin) {
      print("Palabra correcta!...");
      if (!encontradas.contains(palabra)) {
        puntosGanados = 5 * palabra.length;
        puntos += puntosGanados;
        nDiccionario--;
        encontradas.add(palabra);
        encontradasTotales.add(palabra);
        encontrado = true;
      }
      colorBorde = Colors.green;
      visi = 1.0;
    }
    Nodo.tam = 0;

    if (!encontrado) {
      puntosGanados = 0;
      visi = 1.0;
      colorBorde = Colors.red;
      print("Palabra no existe!...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Theme.of(context).accentColor),
        //leading: new Icon(Icons.menu, color: Colors.green,),
        title: Row(
          children: <Widget>[
            /// Coloca el numero de tableros actuales de la partida en la AppBar
            Text(
              'Tablero: $nTablero',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),

            /// Caja vacia con ancho de 45 p
            SizedBox(
              width: 45,
            ),

            /// Coloca el puntaje actual del usuario en la AppBar
            Text(
              'Puntos: $puntos',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ],
          mainAxisSize: MainAxisSize.max,
        ),
        elevation: 0,
      ),
      drawer: Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Theme.of(context).primaryColor),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 90,
                child: DrawerHeader(
                  child: Text(
                    'Palabras Encontradas',
                    style: Theme.of(context).textTheme.title,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    encontradasTotales.length,
                    (index) => Text(
                      '- ${encontradasTotales[index][0].toUpperCase() + encontradasTotales[index].substring(1)}',
                      style: Theme.of(context)
                          .textTheme
                          .body2
                          .copyWith(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "${5 - nTablero}",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                        ),
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
                            if (nTablero < 5) {
                              print("click it");
                              _BoardState.checado = true;
                              palUsuario = '';

                              /// incrementa variable [nTablero], y genera un tablero con
                              /// caracteres aleatorios nuevos
                              setState(() {
                                nTablero++;
                                encontradas.clear();
                                colorBorde = Colors.transparent;
                                tablero.crearTableroNuevo();
                              });
                            } else {
                              null;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Container principal del tablero
              Container(
                width: 250,
                height: 250,
                child: cargando
                    ? Center(child: CircularProgressIndicator())
                    : Board(
                        boardData: tablero.getTablero(),
                        onClick: (letra) {
                          setState(() {
                            palUsuario += letra;
                          });
                        } 
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

              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 42.5,
                    height: 50,
                    margin: EdgeInsets.only(top: 40),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
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
                      ),
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        Icons.clear,
                      ),
                      iconSize: 20,
                      tooltip: "borrar palabra",
                      onPressed: () {
                        setState(() {
                          palUsuario = '';
                          _BoardState.checado = true;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    width: 165,
                    height: 50,
                    child: Text(
                      palUsuario,
                      style: Theme.of(context)
                          .textTheme
                          .body2
                          .copyWith(color: Colors.black, fontSize: 24),
                      overflow: TextOverflow.ellipsis,
                    ),
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
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
                      border: Border.all(color: colorBorde),
                    ),
                  ),
                  Container(
                    width: 42.5,
                    height: 50,
                    margin: EdgeInsets.only(top: 40),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 20.0,
                          spreadRadius: 5.0,
                          offset: Offset(7.0, 7.0),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        Icons.check,
                      ),
                      iconSize: 20,
                      tooltip: "verificar palabra",
                      onPressed: () {
                        setState(() {
                          if (palUsuario != '') {
                            _BoardState.checado = true;
                            verificarPalabra(palUsuario);
                            palUsuario = '';
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),

              /// Caja vacia con altura de 70 p
              SizedBox(
                height: 60,
              ),
              RaisedButton.icon(
                color: Theme.of(context).accentColor,
                label: Text('Finalizar Partida',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(fontSize: 20)),
                icon: Icon(Icons.check),
                onPressed: () {
                  palUsuario = '';
                  Navigator.of(context).pushNamed('/end');
                },
                shape: StadiumBorder(),
                elevation: 12,
              ),
              SizedBox(
                height: 15,
              ),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    );
  }
}

/// Inserta la lista de caracteres del tablero a Containers individuales
class Board extends StatefulWidget {
  final String boardData;
  final Function(String letra) onClick;

  const Board({
    Key key,
    this.boardData,
    this.onClick,
  }) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<double> borde;
  List<FontWeight> letras;
  static bool checado;
  int idxAnt;
  bool vecino;

  _BoardState() {
    borde = [for (int i = 0; i < 25; i++) 1.0];
    letras = [for (int i = 0; i < 25; i++) FontWeight.normal];
    checado = false;
  }

  @override
  Widget build(BuildContext context) {
    if (checado) {
      borde = [for (int i = 0; i < 25; i++) 1.0];
      letras = [for (int i = 0; i < 25; i++) FontWeight.normal];
      idxAnt = null;
    }
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 5,
      children: List.generate(25, (index) {
        return Center(
          child: GestureDetector(
            onTap: () {
              _GameScreenState.visi = 0.0;
              vecino = false;
              if ((idxAnt == index - 1 ||
                      idxAnt == index + 1 ||
                      idxAnt == index - 5 ||
                      idxAnt == index + 5 ||
                      idxAnt == index - 4 ||
                      idxAnt == index - 6 ||
                      idxAnt == index + 4 ||
                      idxAnt == index + 6 ||
                      idxAnt == null) &&
                  idxAnt != index) vecino = true;
                  setState(() {
                    checado = false;
                    if (borde[index] == 1.0 && vecino) {
                      borde[index] = 2.5;
                      letras[index] = FontWeight.w700;
                      idxAnt = index;
                      widget.onClick(widget.boardData[index]);
                    } else if (borde[index] == 2.5 && vecino) {
                      borde[index] = 4.0;
                      letras[index] = FontWeight.bold;
                      idxAnt = index;
                      widget.onClick(widget.boardData[index]);
                    } else if (vecino) {
                      idxAnt = index;
                      widget.onClick(widget.boardData[index]);
                    }
                  });
                
            },
            child: Container(
              width: 37,
              height: 37,
              alignment: Alignment.center,
              child: Text(
                '${widget.boardData[index]}',
                style: Theme.of(context).textTheme.headline.copyWith(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: letras[index]),
              ),
              decoration: BoxDecoration(
                border: Border.all(width: borde[index]),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
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
        Navigator.popUntil(context, ModalRoute.withName('/'));
        return false;
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
                  style: Theme.of(context)
                      .textTheme
                      .display1
                      .copyWith(fontSize: 42),
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
                style: Theme.of(context).textTheme.display4.copyWith(
                      fontSize: 200,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -20,
                    ),
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
                color: Theme.of(context).accentColor,
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
