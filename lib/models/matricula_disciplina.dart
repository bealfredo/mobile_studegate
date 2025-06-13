class MatriculaDisciplina {
  int id;
  double a1;
  double a2;
  double exameFinal;
  int frequencia;
  double mediaFinal;
  String statusMatriculaDisciplina;

  MatriculaDisciplina({
    required this.id,
    required this.a1,
    required this.a2,
    required this.exameFinal,
    required this.frequencia,
    required this.mediaFinal,
    required this.statusMatriculaDisciplina,
  });

  factory MatriculaDisciplina.fromJson(dynamic jsonData) {
    final json = jsonData as Map;

    return MatriculaDisciplina(
      id: json['id'],
      a1: (json['a1'] as num).toDouble(),
      a2: (json['a2'] as num).toDouble(),
      exameFinal: (json['exameFinal'] as num).toDouble(),
      frequencia: json['frequencia'],
      mediaFinal: (json['mediaFinal'] as num).toDouble(),
      statusMatriculaDisciplina: json['statusMatriculaDisciplina'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'a1': a1,
      'a2': a2,
      'exameFinal': exameFinal,
      'frequencia': frequencia,
      'mediaFinal': mediaFinal,
      'statusMatriculaDisciplina': statusMatriculaDisciplina,
    };
  }
}