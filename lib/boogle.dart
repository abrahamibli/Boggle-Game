import 'dart:convert';
import 'dart:math';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/services.dart' show rootBundle; // Libreria para permitir lectura del archivo presente en assets

/// Controla algunas de las funciones basicas de un trie standard
class Nodo {
  static int tam; // Tamaño de la palabra recorrida en el trie
  String letra; // Representa un caracter de la cadena
  bool fin; // Detecta el fin de una palabra cuando vale 'true'
  List<Nodo> rutas; // Hijos del nodo que puede representar otros nodos del alfabeto

  /// Inicializa los atributos como vacios o sin valor
  Nodo() {
    tam = 0; 
    letra = null;
    fin = false;
    rutas = List<Nodo>(32);
  }

  /// Lee el archivo 'diccionario.txt' dentro de /assets e
  /// e inicializa el trie con todas las palabras
  inicializar() async {
    String file = await rootBundle.loadString('assets/dic/diccionario.txt');
    LineSplitter ls = LineSplitter();
    List<String> lines = ls.convert(file);

    try {
      for (String line in lines) {
        line = removeDiacritics(line); // Remueve los posibles acentos que existan en las palabras
        for(int pos=0;pos<line.length;pos++)
          if(line[pos] == 'ñ') line.replaceFirst(RegExp('ñ'), 'n', pos); // Intercambia 'ñ' por 'n'
        this.insertar(line);
        Nodo.tam = 0;
      }
    }catch(e, stackTrace) {
      print(stackTrace);
    }
  }

  /// Regresa true si la estructura trie esta vacia
  bool estaVacio() {
    bool vacio = true;
    int i = 0;
    while(vacio && i < 32) {
      vacio = (rutas[i] == null) ? true : false;
      i++;
    }
    return vacio;
  }

  /// Regresa la cantidad de hijos que puede tener este nodo
  int cantidadDeHijos() {
    int hijos = 0;
    int i = 0;
    while(i < 32) {
      if(rutas[i] != null) hijos++;
      i++;
    }
    return hijos;
  }

  /// Inserta la palabra al trie caracter por caracter
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

  /// Regresa la posicion del caracter proximo a insertar en el trie
  int nuevaPosDePalabra(String palabra) {
    int i = 0;
    while(i < tam)
      i++;
    return i;  
  }

  /// Regresa el ultimo nodo recorrido en el trie de acuerdo a la 
  /// palabra que se quiere buscar
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

  /// Regresa el indice el cual deberia ocupar el caracter en
  /// la lista de rutas
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

  /// Regresa una cadena con los datos del nodo 'letra' y 'fin' 
  String toString() => "Letra: $letra | $fin";

}

/// Generador del tablero de caracteres aleatorios
class Tablero {
  Random rand = Random(); // instancia de [Random()] que toma valores enteros aleatorios
  static int tamx=5, tamy=5, numTab=0; // longitud del tablero
  List<List<String>> letras = List<List<String>>(tamx); // Tablero incializado en 5 filas
  final String abc = 'aabcdeefghiijklmnoopqrstuuvwxyz'; // Banco que representa el alfabeto

  /// Regresa una cadena de longitud 25 con las letras generadas aleatoriamente
  String getTablero() {
    StringBuffer buffer = StringBuffer();

    for(List<String> l in letras) {
      for(String s in l) {
        buffer.write(s);
      }
    }
    return buffer.toString();
  }

  /// Genera un nuevo tablero random con caracteres distintos 
  crearTableroNuevo() {
    for (var i = 0; i < tamx; i++) {
      List<String> list = new List<String>(tamy); // Tablero incializado con 5 columnas

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

  /// Regresa 'true' si el parametro [palabra] esta presente en el tablero.
  /// 
  /// Comprueba recursivamente los vecinos del caracter coincide con el 
  /// caracter siguiente de la [palabra] hasta que termina
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