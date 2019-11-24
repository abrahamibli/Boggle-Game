class Scores {
  String _name;
  int _score;

  Scores(this._name, this._score);

  Scores.fromJson(Map<String, dynamic> json)
    : _name = json['name'],
      _score = json['score'];

  Map<String, dynamic> toJson() => {
    'name' : _name,
    'score' : _score,
  };

  get name => _name;
  
  get score => _score;

  @override
  String toString() {
    return 'nombre: $_name, puntuacion: $_score';
  }
}