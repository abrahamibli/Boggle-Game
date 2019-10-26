import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:diacritic/diacritic.dart';


class Nodo {
  static int tam;
  String letra;
  bool fin;
  List<Nodo> rutas;

  Nodo() {
    tam = 0;
    letra = null;
    fin = false;
    rutas = List<Nodo>(32);
  }

  void inicializar(String ruta) async {
    var file = File(ruta);
    Stream<List<int>> inputStream = file.openRead();
    var lines = Utf8Decoder(allowMalformed: true).bind(inputStream).transform(LineSplitter());
    //utf8.decoder
    try {
      await for(var line in lines) {
        //print('$line tiene ${line.length} caracteres');
        line = removeDiacritics(line);
        for(int pos=0;pos<line.length;pos++)
          if(line[pos] == 'ñ') line.replaceFirst(RegExp('ñ'), 'n', pos);
        //print(line);
        this.insertar(line);
        //print("\nPalabra '$line' insertada");
        Nodo.tam = 0;
      }
      //print('Archivo cerrado');
    }catch(e) {
      print(e);
    }
  }

  bool estaVacio() {
    bool vacio = true;
    int i = 0;
    while(vacio && i < 32) {
      vacio = (rutas[i] == null) ? true : false;
      i++;
    }
    return vacio;
  }

  int cantidadDeHijos() {
    int hijos = 0;
    int i = 0;
    while(i < 32) {
      if(rutas[i] != null) hijos++;
      i++;
    }
    return hijos;
  }

  void insertar(String palabra) { 
    Nodo trieX = this, aux;
    trieX = buscar(palabra);
    int pos = 0, cual;

    if(trieX.letra != null)
      pos = nuevaPosDePalabra(palabra);
    do {  
      if(pos < palabra.length) {
        cual = indice(palabra[pos]);
        aux = Nodo();
        aux.letra = palabra[pos];
        aux.fin = false;
        trieX.rutas[cual] = aux;
        trieX = trieX.rutas[cual];
      }
      pos++;
    }while(pos < palabra.length);

    trieX.fin = true;
  }

  int nuevaPosDePalabra(String palabra) {
    int i = 0;
    while(i < tam)
      i++;
    return i;  
  }

  Nodo buscar(String palabra) {
    int cual, i = 0;
    Nodo aux = this;

    cual = indice(palabra[i]);
    while(aux.rutas[cual] != null) { 
      aux = aux.rutas[cual];
      tam++;
      i++;
      if(i >= palabra.length)
        break;
      cual = indice(palabra[i]);
    }
    
    return aux;
  }

  int indice(String letra){
    int i = 0;
    if(letra.codeUnitAt(0) >= 'A'.codeUnitAt(0) && letra.codeUnitAt(0) <= 'Z'.codeUnitAt(0))
        i = letra.codeUnitAt(0)-'A'.codeUnitAt(0);
    else if(letra.codeUnitAt(0) >= 'a'.codeUnitAt(0) && letra.codeUnitAt(0) <= 'z'.codeUnitAt(0))
        i = letra.codeUnitAt(0)-'a'.codeUnitAt(0);
    else
        i=-1;
    return i;
  }

  List<String> autoCompletar(String prefijo) {
    Nodo trieX = this;
    List<String> lista = List<String>(); 
    int cual;

    for(int i = 0; i < prefijo.length; i++) {
      cual = indice(prefijo[i]);
      if(trieX.rutas[cual] == null)
        return lista;
      trieX = trieX.rutas[cual]; 
    }

    prefijo = prefijo.substring(0, prefijo.length-1);
    return trieX.todosLosPrefijos(lista, prefijo, trieX);
  }

  List<String> todosLosPrefijos(List<String> lista, String prefijo, Nodo nodoX) {
    if(nodoX.fin) {
      prefijo = "$prefijo${nodoX.letra}";
      lista.add(prefijo);
    }else {
      prefijo = "$prefijo${nodoX.letra}";
    }

    for(Nodo nodo in nodoX.rutas) {
      if(nodo != null) {
        todosLosPrefijos(lista, prefijo, nodo);
      }
    }
    
    return lista;
    
  }

  void eliminar(String palabra) {
    int cual, i = 0, avance_trie = 0;
    String sig_letra = palabra[0];
    Nodo trieX = this, aux = this;

    do { 
      cual = indice(palabra[i]); 
      trieX = trieX.rutas[cual];
      i++;
      avance_trie++;
      if(avance_trie == palabra.length) {
        if(!trieX.estaVacio()) {
          aux = trieX;
          sig_letra = null;
        }
      }else if(trieX.cantidadDeHijos() > 1 || trieX.fin) {
        aux = trieX;
        sig_letra = palabra[i];
      }
    }while(i < palabra.length);

    if(sig_letra != null || aux == this) {
      cual = indice(sig_letra[0]);
      aux.rutas[cual] = null;
    }else 
      aux.fin = false;
  }

  String toString() => "Letra: $letra | $fin";

}

class Tablero {
  Random rand = Random();
  static int tamx=5, tamy=5, numTab=0;
  List<List<String>> letras = List<List<String>>(tamx);
  final String abc = 'aabcdeefghiijklmnoopqrstuuvwxyz';

  String getTablero() {
    StringBuffer buffer = StringBuffer();

    for(List<String> l in letras) {
      for(String s in l) {
        buffer.write(s);
      }
    }
    return buffer.toString();
  }

  //Tablero random nuevo
  crearTableroNuevo() {
    for (var i = 0; i < tamx; i++) {
      List<String> list = new List<String>(tamy);

      for (var j = 0; j < tamy; j++) {
        list[j] = null;
      }
      letras[i] = list;
    }
    for(int i=0;i<tamx;i++) {
      for(int j=0;j<tamy;j++) {
        letras[i][j] = abc[rand.nextInt(abc.length)];
      }
    }
    numTab++;
  }

  //Imprimir tablero en pantalla
  imprimir(int puntos) {
    //Limpiar terminal
    print('\x1B[2J\x1B[0;0H');
    print('--------------------- NIVEL $numTab ---------------------  Puntos: $puntos\n');
    for(int i=0;i<tamx;i++) {
      for(int j=0;j<tamy;j++) {
        stdout.write(letras[i][j] + '\t');
      }
      print('\n');
    }
  }

  bool palabraExiste(String palabra, int pos, int x, int y) {
    if(pos==palabra.length) return true;
    if(letras[x][y] != palabra[pos]) return false;
    for(int i=x-1; i<=x+1; i++) {
      for(int j=y-1; j<=y+1; j++) {
        if((i==x && j==y))
          continue;
        if(i>=0 && j>=0 && i<tamx && j<tamy) {
          if(palabraExiste(palabra, pos + 1, i, j))
            return true;
        }
      }
    }
    return false;
  }
}

class Boogle {
  Tablero tablero;
  Nodo trie;

  Boogle(this.trie) {
    tablero = Tablero();
  }

  nuevaPartida() {
    String palabras; 
    int puntos=0;
    Nodo donde;
    bool encontrado;
    do{
      tablero.crearTableroNuevo();
      tablero.imprimir(puntos);
      print('\n\nPalabras Encontradas: ');
      do {
        encontrado = false;
        palabras = stdin.readLineSync();
        for(int i=0;i<Tablero.tamx;i++) {
          for(int j=0;j<Tablero.tamy;j++) {
              if(tablero.palabraExiste(palabras, 0, i, j)){
                donde = trie.buscar(palabras);
                if((palabras.length == Nodo.tam) && donde.fin) {
                  puntos+=25;
                  print("Palabra correcta!... Ganaste 25 puntos");
                  encontrado=true;
                }
                Nodo.tam = 0;
              }
          }
        }
        if(!encontrado) {
          print("Palabra no existe!... Ganaste 0 puntos");
        }
      }while(!encontrado);
      stdin.readLineSync();
    }while(puntos!=100);
  }
}

void main() async{
  //Inicializando variables y trie con diccionario
  Nodo trie = Nodo();
  await trie.inicializar("../dic/diccionario.txt");
  Boogle boogle = Boogle(trie);
  int opc;

  //Menu principal
  do{
    //Limpiar terminal
    print('\x1B[2J\x1B[0;0H');
    print('-------------- BOOGLE MENU PRINCIPAL --------------\n');
    print('1) Nueva Partida');
    print('2) Salir');
    stdout.write('OPCION: ');
    opc = int.parse(stdin.readLineSync());

    switch(opc) {
      //Nueva Partida
      case 1:
        boogle.nuevaPartida();
        break;
      case 2:
        break;
      case 69:
        print("lol nice lmao gg\n");
        print(trie.buscar(stdin.readLineSync()));
        break;
      default:
        print('**Opcion Incorrecta**');
    }
  }while(opc!=2);
}