import 'package:mobile_studegate/models/matricula_disciplina.dart';

class Disciplina {
  int id;
  String periodoLetivo;
  String codigo;
  String nome;
  int cargaHoraria;
  int creditos;
  int periodoCurso;
  List<MatriculaDisciplina> matriculas;

  Disciplina({
    required this.id,
    required this.periodoLetivo,
    required this.codigo,
    required this.nome,
    required this.cargaHoraria,
    required this.creditos,
    required this.periodoCurso,
    required this.matriculas,
  });

  factory Disciplina.fromJson(dynamic jsonData) {
    final json = jsonData as Map;

    return Disciplina(
      id: json['id'],
      periodoLetivo: json['periodoLetivo'],
      codigo: json['codigo'],
      nome: json['nome'],
      cargaHoraria: json['cargaHoraria'],
      creditos: json['creditos'],
      periodoCurso: json['periodoCurso'],
      matriculas: json['matriculas'] != null
          ? (json['matriculas'] as List)
              .map((m) => MatriculaDisciplina.fromJson(m))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'periodoLetivo': periodoLetivo,
      'codigo': codigo,
      'nome': nome,
      'cargaHoraria': cargaHoraria,
      'creditos': creditos,
      'periodoCurso': periodoCurso,
      'matriculas': matriculas.map((matricula) => matricula.toJson()).toList(),
    };
  }
}