import 'package:flutter/material.dart';
import 'package:mobile_studegate/models/disciplina.dart';
import 'package:mobile_studegate/models/matricula_disciplina.dart';

class DisciplinaCard extends StatelessWidget {
  final String periodoLetivo;
  final String codigo;
  final String nome;
  final String situacao;
  final int faltas;
  final double a1;
  final double a2;
  final double exameFinal;
  final double mediaSemestral;
  final double mediaFinal;
  final Color situacaoColor;

  const DisciplinaCard({
    Key? key,
    required this.periodoLetivo,
    required this.codigo,
    required this.nome,
    required this.situacao,
    required this.faltas,
    required this.a1,
    required this.a2,
    required this.exameFinal,
    required this.mediaSemestral,
    required this.mediaFinal,
    this.situacaoColor = Colors.black,
  }) : super(key: key);

  // Construtor de fábrica para criar um card de uma disciplina
  factory DisciplinaCard.fromDisciplina(Disciplina disciplina) {
    MatriculaDisciplina? matricula = 
        disciplina.matriculas.isNotEmpty ? disciplina.matriculas.first : null;
    
    Color situacaoColor = Colors.grey;
    if (matricula != null) {
      if (matricula.statusMatriculaDisciplina.toLowerCase().contains('aprovado')) {
        situacaoColor = Colors.green;
      } else if (matricula.statusMatriculaDisciplina.toLowerCase().contains('reprovado')) {
        situacaoColor = Colors.red;
      } else {
        situacaoColor = Colors.blue;
      }
    }

    return DisciplinaCard(
      periodoLetivo: disciplina.periodoLetivo,
      codigo: disciplina.codigo,
      nome: disciplina.nome,
      situacao: matricula?.statusMatriculaDisciplina ?? 'Matriculado',
      faltas: matricula?.frequencia ?? 0,
      a1: matricula?.a1 ?? 0.0,
      a2: matricula?.a2 ?? 0.0,
      exameFinal: matricula?.exameFinal ?? 0.0,
      mediaSemestral: (matricula?.a1 ?? 0.0) * 0.4 + (matricula?.a2 ?? 0.0) * 0.6,
      mediaFinal: matricula?.mediaFinal ?? 0.0,
      situacaoColor: situacaoColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com período, código, nome e situação
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$periodoLetivo - $codigo',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nome,
                        style: const TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: situacaoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: situacaoColor),
                    ),
                    child: Text(
                      situacao,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: situacaoColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Tabela de notas e faltas
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Cabeçalho da tabela
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: Row(
                        children: [
                          _buildTableHeader('Faltas', 1),
                          _buildTableHeader('A1', 1),
                          _buildTableHeader('A2', 1),
                          _buildTableHeader('Exame', 1),
                          _buildTableHeader('M.Sem', 1),
                          _buildTableHeader('M.Final', 1),
                        ],
                      ),
                    ),
                  ),
                  
                  // Valores
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Row(
                      children: [
                        _buildTableCell(faltas.toString(), 1),
                        _buildTableCell(a1.toStringAsFixed(1), 1),
                        _buildTableCell(a2.toStringAsFixed(1), 1),
                        _buildTableCell(exameFinal.toStringAsFixed(1), 1),
                        _buildTableCell(mediaFinal.toStringAsFixed(1), 1),
                        _buildTableCell(
                          mediaFinal.toStringAsFixed(1),
                          1,
                          textColor: mediaFinal >= 6.0 ? Colors.green : 
                                    mediaFinal > 0 ? Colors.red : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text, int flex, {
    Color textColor = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: textColor,
          fontWeight: fontWeight,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}