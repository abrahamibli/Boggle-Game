import 'dart:convert';
import 'dart:io';
import 'package:boggle_game/hashtable.dart';
import 'package:boggle_game/scoreFIle.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
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
  List<String> encontradas,
      encontradasTotales; // Lista palabras encontradas por el usuario
  static double
      visi; // Controla animacion de texto cuando usuario encuentra palabra
  final TextEditingController text_field_clean =
      TextEditingController(); // Controlador que limpia TextField cuando usuario deja de escribir en él
  static bool
      cargando; // Controla tiempo de carga del tablero cuando se inicia partida
  static String palUsuario = ''; // Formada cuando se hace Tap en el tablero
  Color colorBorde; // Verde si la palabra es correcta, Rojo en caso contrario

  /// Metodo que inicializa las variables utilizadas en esta clase [_GameScreenState]
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
    initTrie();
  }

  /// Invoca el metodo que inicializa el [trie] con las palabras del diccionario
  void initTrie() async {
    await trie.inicializar();

    /// Muestra una pantalla de carga cuando el trie esta llenando
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
        leading: Icon(
          Icons.close,
          color: Theme.of(context).primaryColor,
        ),
        actions: <Widget>[
          /// Boton que nos envia a la pantalla final de puntuacion
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0),
            child: RaisedButton.icon(
              /// Nos dirige a la pantalla inicial del juego
              onPressed: () {
                palUsuario = '';
                Navigator.of(context).pushNamed('/end');
              },
              color: Theme.of(context).accentColor,
              elevation: 0,
              label: Text(
                'Finalizar Partida',
                style: Theme.of(context).textTheme.button.copyWith(
                      fontSize: 13,
                      letterSpacing: -.4,
                    ),
              ),
              icon: Icon(Icons.done),
              shape: StadiumBorder(),
            ),
          ),
        ],
        iconTheme: new IconThemeData(color: Theme.of(context).accentColor),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Puntos: $puntos',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              letterSpacing: -.4,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),

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
                    height: 25,
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

                            /// Funcion personalizada para que el TextField se actualice
                            /// cada vez que se hace Tap en el tablero
                            onClick: (letra) {
                              setState(() {
                                palUsuario += letra;
                              });
                            }),
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

                  /// Ordena tres elementos; Boton Rojo, TextField, Boton Verde
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// Muestra el boton izquierdo al TextField
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

                        /// Boton Rojo X
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(
                            Icons.clear,
                          ),
                          iconSize: 20,
                          tooltip: "borrar palabra",

                          /// Borra el contenido del Textfield cuando se presiona
                          onPressed: () {
                            setState(() {
                              palUsuario = '';
                              _BoardState.checado = true;
                            });
                          },
                        ),
                      ),

                      /// Textfield que se actualiza conforme se hace Tap en el tablero mostrando
                      /// las cadenas que el usuario forma
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

                      /// Muestra el boton derecho al TextField
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

                        /// Boton Verde ./
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(
                            Icons.check,
                          ),
                          iconSize: 20,
                          tooltip: "verificar palabra",

                          /// Verifica el contenido del Textfield cuando se presiona y limpia la palabra
                          /// concatenada
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

                  /// Caja vacia con altura de 15 p
                  SizedBox(
                    height: 15,
                  ),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            ),
          ),
          SlideUpPanel(
            body: encontradasTotales,
          ),
        ],
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

/// Controla el Touch que se genera dentro del Grid del tablero
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
class EndScreen extends StatefulWidget {
  @override
  _EndScreenState createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  TextEditingController _nameController;
  List<Scores> _scores;

  @override
  void initState() {
    _nameController = TextEditingController();
    _scores = List<Scores>();
    readScores();
    super.initState();
  }

  readScores() async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      File file = File('${dir.path}/scores.json');
      List json = jsonDecode(await file.readAsString());
      List<Scores> auxScores = [];
      for (var score in json) {
        auxScores.add(Scores.fromJson(score));
      }
      setState(() => _scores = auxScores);
    } catch (e) {
      writeScore();
      readScores();
    }
  }

  writeScore() async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      File file = File('${dir.path}/scores.json');
      String jsonText = jsonEncode(_scores);
      await file.writeAsString(jsonText);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, ModalRoute.withName('/'));
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: Column(
                children: <Widget>[
                  /// Container que muestra un texto simple
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      child: Text(
                        'Juego Finalizado!',
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(fontSize: 42),
                      ),
                    ),
                  ),

                  /// Caja vacia con altura de 40 p
                  SizedBox(
                    height: 20,
                  ),

                  /// Container que muestra texto simple
                  Container(
                    child: Text('con',
                        style: Theme.of(context).textTheme.display1),
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
                    style: Theme.of(context)
                        .textTheme
                        .display1
                        .copyWith(fontSize: 15),
                  )),

                  /// Caja vacia con altura de 40 p
                  SizedBox(
                    height: 20,
                  ),

                  /// TextField para ingresar nombre
                  Container(
                    padding: EdgeInsets.only(bottom: 7, left: 25, right: 25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 20.0,
                          spreadRadius: 5.0,
                          offset: Offset(7.0, 7.0),
                        ),
                      ],
                    ),
                    width: 265,
                    child: TextField(
                      controller: _nameController,
                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
                      decoration: InputDecoration(
                        hintText: 'Escribe tu nombre aqui',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintStyle: Theme.of(context).textTheme.title.copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ),

                  /// Caja vacia con altura de 40 p
                  SizedBox(
                    height: 20,
                  ),

                  /// Container del boton que nos envia al menu principal
                  Container(
                    child: RaisedButton.icon(
                      /// Nos dirige a la pantalla inicial del juego
                      onPressed: () {
                        if (_nameController.text != '') {
                          _scores.add(Scores(
                              _nameController.text, _GameScreenState.puntos));
                          writeScore();
                          print(_scores);
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Escribe un nombre!'),
                              content: Text(
                                  'Necesitas escribir tu nombre para guardar la puntuacion'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                            barrierDismissible: false,
                          );
                        }
                      },
                      color: Theme.of(context).accentColor,
                      elevation: 20,
                      label: Text('Guardar Puntuacion',
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(fontSize: 20)),
                      icon: Icon(Icons.score),
                      shape: StadiumBorder(),
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  )
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SlideUpPanel extends StatefulWidget {
  final String _title;
  final List _body;

  SlideUpPanel({Key key, title, body})
      : _body = body,
        _title = title,
        super(key: key);

  @override
  _SlideUpPanelState createState() => _SlideUpPanelState(_body, _title);
}

class _SlideUpPanelState extends State<SlideUpPanel> {
  String _title;
  List _body;

  _SlideUpPanelState(this._body, this._title);

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
        topRight: Radius.circular(24), topLeft: Radius.circular(24));
    return SlidingUpPanel(
      backdropOpacity: .1,
      backdropEnabled: true,
      borderRadius: radius,
      minHeight: 50,
      maxHeight: 300,
      color: Theme.of(context).primaryColor,
      panel: Column(
        children: <Widget>[
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: radius,
            ),
            child: Center(
              child: Text('Palabras Encontradas',
                  style: Theme.of(context).textTheme.title),
            ),
          ),
          Container(
            height: 250,
            child: ListView(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                /// Muestra cada palabra de la lista [encontradasTotales] en el cuerpo
                /// de la pantalla deslizante
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      _body.length,
                      (index) => Card(
                        color: Colors.white,
                        child: Container(
                          height: 30,
                          width: 200,
                          alignment: Alignment.center,
                          child: Text(
                            '${_body[index][0].toUpperCase() + _body[index].substring(1)}',
                            style: Theme.of(context).textTheme.body2.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      collapsed: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: radius,
        ),
        child: Center(
          child: Text('Palabras Encontradas',
              style: Theme.of(context).textTheme.title),
        ),
      ),
    );
  }
}
