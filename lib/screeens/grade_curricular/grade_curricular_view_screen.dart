import 'package:flutter/material.dart';
import 'package:mobile_studegate/models/curso.dart';
import 'package:mobile_studegate/models/disciplina.dart';
import 'package:mobile_studegate/services/disciplina_service.dart';
import 'package:mobile_studegate/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class GradeCurricularViewScreen extends StatefulWidget {
  final Curso? curso;
  
  const GradeCurricularViewScreen({Key? key, this.curso}) : super(key: key);
  
  @override
  State<GradeCurricularViewScreen> createState() => _GradeCurricularViewScreenState();
}

class _GradeCurricularViewScreenState extends State<GradeCurricularViewScreen> {
  bool _isLoading = true;
  List<Disciplina> _disciplinas = [];
  Map<int, List<Disciplina>> _disciplinasPorPeriodo = {};
  
  @override
  void initState() {
    super.initState();
    _carregarDisciplinas();
  }
  
  Future<void> _carregarDisciplinas() async {
    if (widget.curso == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Obter todas as disciplinas do curso
      _disciplinas = await getDisciplinasByCurso(widget.curso!.id);
      
      // Agrupar disciplinas por período usando o campo periodoCurso
      _disciplinasPorPeriodo = {};
      
      for (var disciplina in _disciplinas) {
        if (!_disciplinasPorPeriodo.containsKey(disciplina.periodoCurso)) {
          _disciplinasPorPeriodo[disciplina.periodoCurso] = [];
        }
        
        _disciplinasPorPeriodo[disciplina.periodoCurso]!.add(disciplina);
      }
    } catch (e) {
      // Tratar erro
      print('Erro ao carregar disciplinas: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[900],
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              '${widget.curso?.nome ?? "Curso"} (Matriculado)',
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 16,
              ),
            ),
          ),
          body: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título da tela
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[200],
                    child: Text(
                      'Matriz Curricular - ${widget.curso?.nome ?? "CURSO"}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  
                  // Lista de períodos
                  Expanded(
                    child: _disciplinasPorPeriodo.isEmpty
                      ? const Center(child: Text('Nenhuma disciplina encontrada.'))
                      : ListView(
                          children: _buildPeriodosList(),
                        ),
                  ),
                ],
              ),
        );
      },
    );
  }

  // Método para construir a lista de períodos com Optativas no final  
  List<Widget> _buildPeriodosList() {
    List<int> periodos = _disciplinasPorPeriodo.keys.toList();
    
    // Remove período 0 da lista principal (se existir)
    periodos.remove(0);
    
    // Ordena os períodos numericamente
    periodos.sort();
    
    // Cria a lista de widgets para cada período
    List<Widget> periodoWidgets = periodos.map((periodo) {
      return _buildPeriodoSection(
        periodo, 
        _disciplinasPorPeriodo[periodo] ?? [],
        titulo: '$periodo° Período'
      );
    }).toList();
    
    // Adiciona Optativas ao final (se existir)
    if (_disciplinasPorPeriodo.containsKey(0)) {
      periodoWidgets.add(
        _buildPeriodoSection(
          0, 
          _disciplinasPorPeriodo[0] ?? [],
          titulo: 'Optativas'
        )
      );
    }
    
    return periodoWidgets;
  }
  
  Widget _buildPeriodoSection(int periodo, List<Disciplina> disciplinas, {required String titulo}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título do período (usando o parâmetro titulo em vez da formatação padrão)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          // color: Colors.blue[50],
          child: Text(
            titulo,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ),
        
        // Cabeçalho da tabela
        Container(
          color: Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Código',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  'Disciplina',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'CH',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        
        // Linhas de disciplinas
        ...disciplinas.map((disciplina) => _buildDisciplinaRow(disciplina)).toList(),
        
        const SizedBox(height: 20),
      ],
    );
  }
  
  Widget _buildDisciplinaRow(Disciplina disciplina) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              disciplina.codigo,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              disciplina.nome,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${disciplina.cargaHoraria}',
              style: const TextStyle(
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}