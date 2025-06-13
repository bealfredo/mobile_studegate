class MatriculaDisciplina {
  final int id;
  final double? a1;          
  final double? a2;          
  final double? exameFinal;  
  final int? frequencia;     
  final double? mediaFinal;  
  final String statusMatriculaDisciplina;

  MatriculaDisciplina({
    required this.id,
    this.a1,         
    this.a2,         
    this.exameFinal, 
    this.frequencia, 
    this.mediaFinal, 
    required this.statusMatriculaDisciplina, // Mantive required pois o status é importante
  });

  // Se você tem um método fromJson, atualize-o também:
  factory MatriculaDisciplina.fromJson(Map<dynamic, dynamic> json) {
    return MatriculaDisciplina(
      id: json['id'],
      a1: json['a1'] != null ? (json['a1'] as num).toDouble() : null,
      a2: json['a2'] != null ? (json['a2'] as num).toDouble() : null,
      exameFinal: json['exameFinal'] != null ? (json['exameFinal'] as num).toDouble() : null,
      frequencia: json['frequencia'],
      mediaFinal: json['mediaFinal'] != null ? (json['mediaFinal'] as num).toDouble() : null,
      statusMatriculaDisciplina: json['statusMatriculaDisciplina'],
    );
  }

  // Se você tem um método toJson, atualize-o também:
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