import 'package:mobile_studegate/models/disciplina.dart';

class Curso {
  int id;
  String nome;
  String codigo;
  List<Disciplina> disciplinas;

  Curso({
    required this.id,
    required this.nome,
    required this.codigo,
    required this.disciplinas,
  });

  factory Curso.fromJson(dynamic jsonData) {
    // Garantir que estamos trabalhando com um Map
    final json = jsonData as Map;
    
    return Curso(
      id: json['id'],
      nome: json['nome'],
      codigo: json['codigo'],
      disciplinas: json['disciplinas'] != null 
          ? (json['disciplinas'] as List).map((d) => Disciplina.fromJson(d)).toList() 
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'codigo': codigo,
      'disciplinas': disciplinas.map((disciplina) => disciplina.toJson()).toList(),
    };
  }
}