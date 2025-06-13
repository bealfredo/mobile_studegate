
import 'package:flutter/material.dart';
import 'package:mobile_studegate/models/aluno.dart';
import 'package:mobile_studegate/models/curso.dart';
import 'package:mobile_studegate/models/disciplina.dart';
import 'package:mobile_studegate/screeens/boletim/boletim_table.dart';
import 'package:provider/provider.dart';
import 'package:mobile_studegate/providers/auth_provider.dart';


class BoletimViewScaffold extends StatefulWidget {
  final Curso curso;

  const BoletimViewScaffold({super.key, required this.curso});

  @override
  State<BoletimViewScaffold> createState() => _BoletimViewScaffoldState();
}

class _BoletimViewScaffoldState extends State<BoletimViewScaffold> {
  Key _listKey = UniqueKey();
  Curso? _selectedCurso;

   @override
  void initState() {
    super.initState();
    _selectedCurso = widget.curso;
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final Aluno? user = authProvider.user;
        
        if (user == null) {
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
              title: const Text(
                'Boletim Acadêmico',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: const Center(
              child: Text('Usuário não encontrado.'),
            ),
          );
        }
        
        // Se não tiver curso selecionado e o usuário tem cursos, seleciona o primeiro
        _selectedCurso ??= user.cursos.isNotEmpty ? user.cursos.first : null;
        
        // Se não tiver curso, exibe mensagem
        if (_selectedCurso == null) {
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
              title: const Text(
                'Boletim Acadêmico',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: const Center(
              child: Text('Nenhum curso encontrado.'),
            ),
          );
        }
        
        final List<Disciplina> disciplinas = _selectedCurso!.disciplinas;
        
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
              '${_selectedCurso!.nome} (Matriculado)',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: Colors.blue[900],
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'BOLETIM ACADÊMICO - ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Disciplinas do Semestre Letivo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
              child: disciplinas.isEmpty
                  ? const Center(child: Text('Nenhuma disciplina encontrada.'))
                  : ListView(
                      children: [
                        // Cards de disciplinas
                        ...disciplinas.map((disciplina) => 
                          DisciplinaCard.fromDisciplina(disciplina)).toList(),
                        
                        // Adicionar notas legais após todos os cards
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '* Situação passiva de alteração no decorrer do período letivo.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '- Documento sem valor legal.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            ],
          ),
        );
      },
    );
  }
}
